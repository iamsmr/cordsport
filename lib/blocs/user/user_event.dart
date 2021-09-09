part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserUpdateUser extends UserEvent {
  final List<User> users;
  const UserUpdateUser({required this.users});

  @override
  List<Object> get props => [users];
}

class UserGetCurrentUser extends UserEvent {}

class UserUpdatePosition extends UserEvent {
  final Position position;
  final String? id;
  const UserUpdatePosition({required this.position, this.id});
  @override
  List<Object?> get props => [position, id];
}

class UserUpdateCodeName extends UserEvent {
  final String codeName;
  const UserUpdateCodeName({required this.codeName});
}
