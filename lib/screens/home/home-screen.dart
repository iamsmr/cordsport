import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/repositories/location/location-repository.dart';
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
      listener: (context, state) {},
      builder: (context, state) {
        final latLan =
            LatLng(state.location.latitude, state.location.longitude);
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
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
              mapType: MapType.normal,
              circles: Set.from([
                Circle(
                  circleId: CircleId("1km radius circle"),
                  center: latLan,
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
          ),
        );
      },
    );
  }
}
