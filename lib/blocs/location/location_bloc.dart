import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/config/paths.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationReository _locationReository;
  final FirebaseFirestore _firebaseFirestore;
  final AuthBloc _authBloc;

  late StreamSubscription<LatLng> _userSubscribtion;

  LocationBloc({
    required LocationReository locationReository,
     FirebaseFirestore? firebaseFirestore,
    required AuthBloc authBloc,
  })  : _locationReository = locationReository,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _authBloc = authBloc,
        super(LocationState.initial()) {
    _userSubscribtion =
        _locationReository.locationChange().listen((userLocation) {
      add(
        LocationEventUpdateLocation(
          userLocation: userLocation,
        ),
      );
      _firebaseFirestore
          .collection(Paths.users)
          .doc(_authBloc.state.user?.uid)
          .update({
        "cordinates": GeoPoint(
          userLocation.latitude,
          userLocation.longitude,
        )
      });
    });
  }

  @override
  Future<void> close() {
    _userSubscribtion.cancel();
    return super.close();
  }

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is LocationEventGetLocation) {
      yield* _mapUserLocationToUserLocationState();
    } else if (event is LocationEventUpdateLocation) {
      yield* _mapLocationStreamToState(event);
    }
  }

  Stream<LocationState> _mapUserLocationToUserLocationState() async* {
    LatLng location = await _locationReository.getLocation();
    yield state.copyWith(
      status: LocationStatus.success,
      location: location,
    );
  }

  Stream<LocationState> _mapLocationStreamToState(
      LocationEventUpdateLocation location) async* {
    yield state.copyWith(
      location: location.userLocation,
      status: LocationStatus.success,
    );
  }
}
