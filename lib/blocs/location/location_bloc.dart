import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/blocs/user/user_bloc.dart';
import 'package:codespot/config/paths.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationReository _locationReository;
  final UserBloc _userBloc;
  final FirebaseFirestore _firebaseFirestore;
  final AuthBloc _authBloc;

  late StreamSubscription<LatLng?> _userSubscribtion;

  LocationBloc({
    required UserBloc userBloc,
    required LocationReository locationReository,
    FirebaseFirestore? firebaseFirestore,
    required AuthBloc authBloc,
  })  : _locationReository = locationReository,
        _userBloc = userBloc,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _authBloc = authBloc,
        super(LocationState.initial()) {
    _userSubscribtion = _locationReository.locationChange().listen((latLang) {
      add(LocationEventUpdateLocation(userLocation: latLang));
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
    final location = await _locationReository.getLocation();
    yield state.copyWith(
      location: location,
      status: LocationStatus.success,
    );
  }

  Stream<LocationState> _mapLocationStreamToState(
      LocationEventUpdateLocation location) async* {
    _userBloc
      ..add(
        UserUpdateCordinates(latLng: _toGeoPoint(location.userLocation!)),
      );
    yield state.copyWith(
      location: location.userLocation,
      status: LocationStatus.success,
    );
  }

  GeoPoint _toGeoPoint(LatLng latLng) {
    return GeoPoint(latLng.latitude, latLng.longitude);
  }
}
