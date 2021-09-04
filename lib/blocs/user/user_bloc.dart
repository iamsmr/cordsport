import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/models/user.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final LocationBloc _locationBloc;
  late StreamSubscription<List<User>> _userSubscribtion;

  UserBloc({
    required UserRepository userRepository,
    required LocationBloc locationBloc,
  })  : _userRepository = userRepository,
        _locationBloc = locationBloc,
        super(UserState.initial()) {
    _userSubscribtion = _userRepository
        .getUserWithInRadius(
      radius: 100,
      center: _locationBloc.state.location,
    )
        .listen((users) {
      add(UserUpdateUser(users: users));
    });
  }

  @override
  Future<void> close() {
    _userSubscribtion.cancel();
    return super.close();
  }

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserUpdateUser) {
      yield* _mapUpdateUserEventToState(event);
    }
  }

  Stream<UserState> _mapUpdateUserEventToState(UserUpdateUser event) async* {
    yield state.copyWith(
      users: event.users,
      latLng: _locationBloc.state.location,
      status: UserStatus.success,
    );
  }

  GeoFirePoint _latLangToGeoFirePoint(LatLng latLng) {
    return GeoFirePoint(latLng.latitude, latLng.longitude);
  }
}
