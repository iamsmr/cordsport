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

class UserGetUserWitId extends UserEvent {
  final String? id;

  const UserGetUserWitId({this.id});

  @override
  List<Object?> get props => [id];
}

class UserUpdateCordinates extends UserEvent {
  final GeoPoint latLng;
  final String? id;
  const UserUpdateCordinates({required this.latLng, this.id});
  @override
  List<Object?> get props => [latLng,id];
}
