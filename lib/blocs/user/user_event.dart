part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserUpdateUser extends UserEvent {
  final List<User> users;
  const UserUpdateUser({
    required this.users,
  });

  @override
  List<Object> get props => [users];
}
