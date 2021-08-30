import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<auth.User?> _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial()) {
    _userSubscription = _authRepository.userChanged.listen(
      (user) => add(AuthUserChanged(user: user)),
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthLogoutRequested) {
      _authRepository.logout();
    } else if (event is AuthUserChanged) {
      yield* _mapUserChangeEventToState(event);
    }
  }

  Stream<AuthState> _mapUserChangeEventToState(AuthUserChanged event) async* {
    yield event.user != null
        ? AuthState.authenticated(user: event.user!)
        : AuthState.unauthenticated();
  }
}
