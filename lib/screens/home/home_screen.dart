import 'dart:typed_data';

import 'package:codespot/blocs/auth/auth_bloc.dart';
import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/blocs/user/user_bloc.dart';
import 'package:codespot/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  Uint8List? _markerIcon;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      context.read<LocationBloc>().add(LocationStarted());
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/images/active.png', 50);
      setState(() => _markerIcon = markerIcon);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
      if (locationState is LocationInitial) {
        return const Loading();
      } else if (locationState is LocationLoadSuccess) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            return Scaffold(
                key: _scaffoldKey,
                drawer: const Drawer(),
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.notes_rounded),
                  ),
                  title: const Text(
                    "CORDSPOT",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        context.read<UserBloc>().add(
                              UserGetUserWithRadius(
                                  center: locationState.position),
                            );
                      },
                    )
                  ],
                ),
                body: BlocBuilder<UserBloc, UserState>(
                    builder: (context, userState) {
                  return GoogleMap(
                    onMapCreated: (controller) {
                      setState(() {
                        _googleMapController = controller;
                      });
                    },
                    mapType: MapType.terrain,
                    myLocationEnabled: false,
                    markers: Set.from(
                      userState.users.map((user) {
                        return Marker(
                          icon: BitmapDescriptor.defaultMarker,
                          // icon: BitmapDescriptor.fromBytes(_markerIcon!),

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
                      }),
                    ),
                    circles: {
                      Circle(
                        circleId: const CircleId("1km circle"),
                        center: toLatlng(locationState.position),
                        radius: 1000,
                        fillColor: Colors.blue.withOpacity(.2),
                        strokeWidth: 2,
                        strokeColor: Colors.blue,
                      )
                    },
                    initialCameraPosition: CameraPosition(
                      target: toLatlng(locationState.position),
                      zoom: 15,
                    ),
                  );
                }));
          },
        );
      } else {
        return Container();
      }
    });
  }

  LatLng toLatlng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }
}
