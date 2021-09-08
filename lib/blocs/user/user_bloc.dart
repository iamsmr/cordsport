import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/models/user.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  late StreamSubscription<List<User>> _userSubscribtion;
  final AuthBloc _authBloc;

  UserBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(UserState.initial());
  @override
  Future<void> close() {
    _userSubscribtion.cancel();
    return super.close();
  }

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserGetUserWitId) {
      yield* _mapGetUserWithIdEventToState(event);
    } else if (event is UserUpdateCordinates) {
      yield* _mapUpdateCordinatesEventToState(event);
    } else if (event is UserUpdateUser) {
      yield* _mapUpdateUserEventToState(event);
    } else if (event is UserUpdateCodeName) {
      yield* _mapUpdateCodeNameToState(event);
    }
  }

  Stream<UserState> _mapUpdateUserEventToState(UserUpdateUser event) async* {
    yield state.copyWith(users: event.users, status: UserStatus.success);
  }

  Stream<UserState> _mapGetUserWithIdEventToState(
      UserGetUserWitId event) async* {
    final user = await _userRepository.getUserWithID(
      id: event.id ?? _authBloc.state.user!.uid,
    );
    yield state.copyWith(user: user, status: UserStatus.success);
  }

  Stream<UserState> _mapUpdateCodeNameToState(UserUpdateCodeName event) async* {
    await _userRepository.updateCodeName(
      codeName: event.codeName,
      id: _authBloc.state.user!.uid,
    );
    yield state.copyWith(status: UserStatus.success);
  }

  Stream<UserState> _mapUpdateCordinatesEventToState(
    UserUpdateCordinates event,
  ) async* {
    await _userRepository.updateCordinates(
      id: event.id ?? _authBloc.state.user!.uid,
      cordinates: event.latLng,
    );
    add(UserGetUserWitId());
    yield state.copyWith(status: UserStatus.success);
  }
}
