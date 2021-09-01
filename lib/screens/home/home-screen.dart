import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/user/user-repository.dart';
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
    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder<List<User>>(
          stream: context.read<UserRepository>().getUserWithInRadius(
                radius: 1000,
                center: context.read<LocationBloc>().state.location,
              ),
          builder: (context, snapshot) {
            final users = snapshot.data ?? [];
            print(users);
            return Scaffold(
              body: GoogleMap(
                zoomControlsEnabled: true,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                onCameraMove: (CameraPosition position) {},
                onMapCreated: (controller) {
                  setState(() {
                    _googleMapController = controller;
                  });
                },
                myLocationEnabled: true,
                markers: Set.from(
                  users.map((user) {
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
                    center: context.read<LocationBloc>().state.location,
                    radius: 1000,
                    fillColor: Colors.blue.withOpacity(.3),
                    strokeWidth: 2,
                    strokeColor: const Color(0xff4361FF),
                  )
                ]),
                initialCameraPosition: CameraPosition(
                  zoom: 15,
                  target: LatLng(
                    context.read<LocationBloc>().state.location.latitude,
                    context.read<LocationBloc>().state.location.longitude,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
