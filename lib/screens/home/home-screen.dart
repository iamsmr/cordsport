import 'dart:typed_data';

import 'package:codespot/blocs/auth/auth_bloc.dart';
import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/blocs/user/user_bloc.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late GoogleMapController _googleMapController;

  bool _isCurrentUser(BuildContext context, String uid) {
    return uid == context.read<AuthBloc>().state.user?.uid;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    final byte = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();

    return byte;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(),
      appBar: AppBar(
          leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: Icon(Icons.notes_rounded),
          ),
          title: const Text(
            "CORDSPOT",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            )
          ]),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, locationState) {
          context
              .read<UserRepository>()
              .getUserWithInRadius(
                radius: 10,
                center: locationState.location!,
              )
              .listen((users) {
            context.read<UserBloc>().add(UserUpdateUser(users: users));
          });
        },
        builder: (context, locationState) {
          return locationState.location == null
              ? Column(
                  children: [LinearProgressIndicator()],
                )
              : GoogleMap(
                  onMapCreated: (controller) {
                    setState(() {
                      _googleMapController = controller;
                    });
                  },
                  mapType: MapType.terrain,
                  myLocationEnabled: true,
                  markers: Set.from(
                    context.read<UserBloc>().state.users.map((user) {
                      // final Uint8List markerIcon = await getBytesFromAsset(
                      //   'assets/images/active.png',
                      //   100,
                      // );
                      return Marker(
                        icon: BitmapDescriptor.defaultMarker,
                        // icon: BitmapDescriptor.fromBytes(markerIcon),
                        // icon: BitmapDescriptor.defaultMarkerWithHue(
                        //     _isCurrentUser(context, user.uid) ? 0 : 200),
                        infoWindow: InfoWindow(
                          title: user.codeName,
                          snippet: _isCurrentUser(context, user.uid)
                              ? "You"
                              : "User",
                        ),
                        markerId: MarkerId(user.uid),
                        position: user.cordinates,
                      );
                    }).toList(),
                  ),
                  circles: Set.from([
                    if (locationState.location != null)
                      Circle(
                        circleId: CircleId("1km circle"),
                        center: locationState.location!,
                        radius: 1000,
                        fillColor: Colors.blue.withOpacity(.2),
                        strokeWidth: 2,
                        strokeColor: Colors.blue,
                      )
                  ]),
                  initialCameraPosition: CameraPosition(
                    target: locationState.location!,
                    zoom: 15,
                  ),
                );
        },
      ),
    );
  }
}
