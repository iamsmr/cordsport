import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/models/user-location.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationReository _locationReository;
  late StreamSubscription<UserLocation> _userSubscribtion;

  LocationBloc({required LocationReository locationReository})
      : _locationReository = locationReository,
        super(LocationState.initial()) {
    _userSubscribtion = _locationReository.locationChange().listen(
          (userLocation) => add(
            LocationEventUpdateLocation(userLocation: userLocation),
          ),
        );
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
    UserLocation location = await _locationReository.getLocation();
    yield state.copyWith(
      status: LocationStatus.success,
      location: location,
    );
  }

  Stream<LocationState> _mapLocationStreamToState(location) async* {
    yield state.copyWith(
      location: location,
      status: LocationStatus.success,
    );
  }
}
