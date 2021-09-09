part of 'user_bloc.dart';

enum UserStatus { unknown, success, error }

class UserState extends Equatable {
  final List<User> users;
  final Failure failure;
  final UserStatus status;
  final User currentUser;

  const UserState({
    required this.currentUser,
    required this.users,
    required this.failure,
    required this.status,
  });

  factory UserState.initial() {
    return UserState(
      users: const [],
      failure: const Failure(),
      status: UserStatus.unknown,
      currentUser: User.empty(),
    );
  }

  @override
  List<Object> get props => [users, failure, status, currentUser];

  UserState copyWith({
    List<User>? users,
    Failure? failure,
    UserStatus? status,
    User? currentUser,
  }) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
      users: users ?? this.users,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
