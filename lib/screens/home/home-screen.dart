import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/blocs/user/user_bloc.dart';
import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/user/user-repository.dart';
import 'package:codespot/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _googleMapController;
  final double zoomLevel = 11;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      context.read<LocationBloc>().add(LocationEventGetLocation());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, locationState) {
        context
            .read<UserRepository>()
            .getUserWithInRadius(
              radius: 10,
              center: locationState.location ?? LatLng(0, 0),
            )
            .listen((users) {
          context.read<UserBloc>().add(UserUpdateUser(users: users));
        });
      },
      builder: (context, locationState) {
        if (locationState.location != null) {
          return BlocConsumer<UserBloc, UserState>(
            listener: (context, userState) {},
            builder: (context, userState) {
              return WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  body: GoogleMap(
                    zoomControlsEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomGesturesEnabled: true,
                    onMapCreated: (controller) {
                      setState(() {
                        _googleMapController = controller;
                      });
                    },
                    onCameraMove: (position) {
                      setState(() {
                        _googleMapController.moveCamera(
                            CameraUpdate.newCameraPosition(position));
                      });
                    },
                    myLocationEnabled: true,
                    markers: Set.from(
                      userState.users.map((user) {
                        Marker(
                          position: user.cordinates,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue,
                          ),
                          markerId: MarkerId(user.uid),
                        );
                      }),
                    ),
                    mapType: MapType.normal,
                    circles: Set.from([
                      Circle(
                        circleId: CircleId("1km radius circle"),
                        center: locationState.location!,
                        radius: 1000,
                        fillColor: Colors.blue.withOpacity(.3),
                        strokeWidth: 2,
                        strokeColor: const Color(0xff4361FF),
                      )
                    ]),
                    initialCameraPosition: CameraPosition(
                      zoom: 15,
                      target: locationState.location!,
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Loading();
      },
    );
  }
}
