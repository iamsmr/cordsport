import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/models/user.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  UserBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(UserState.initial());


  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserGetCurrentUser) {
      yield* _mapGetCurrentUserEventToState(event);
    } else if (event is UserUpdatePosition) {
      yield* _mapUpdatePositonEventsToState(event);
    } else if (event is UserUpdateUser) {
      yield* _mapUpdateUserEventToState(event);
    } else if (event is UserUpdateCodeName) {
      yield* _mapUpdateCodeNameEventToState(event);
    }
  }

  Stream<UserState> _mapUpdateUserEventToState(UserUpdateUser event) async* {
    yield state.copyWith(users: event.users, status: UserStatus.success);
  }

  Stream<UserState> _mapGetCurrentUserEventToState(
    UserGetCurrentUser event,
  ) async* {
    User user = await _userRepository.getUserWithID(
      id: _authBloc.state.user!.uid,
    );

    yield state.copyWith(currentUser: user, status: UserStatus.success);
  }

  Stream<UserState> _mapUpdateCodeNameEventToState(
      UserUpdateCodeName event) async* {
    await _userRepository.updateCodeName(
      codeName: event.codeName,
      id: _authBloc.state.user!.uid,
    );
    yield state.copyWith(status: UserStatus.success);
  }

  Stream<UserState> _mapUpdatePositonEventsToState(
    UserUpdatePosition event,
  ) async* {
    await _userRepository.updateCordinates(
      id: event.id ?? _authBloc.state.user!.uid,
      position: event.position,
    );
    // add(UserGetCurrentUser());
    yield state.copyWith(status: UserStatus.success);
  }
}
