part of 'user_bloc.dart';

enum UserStatus { unknown, success, error }

class UserState extends Equatable {
  final List<User> users;
  final Failure failure;
  final UserStatus status;
  final LatLng latLng;

  const UserState({
    required this.latLng,
    required this.users,
    required this.failure,
    required this.status,
  });

  factory UserState.initial() {
    return UserState(
      users: [],
      latLng: LatLng(26.501185, 87.27583329999999) /*LatLng(0, 0)*/,
      failure: Failure(),
      status: UserStatus.unknown,
    );
  }

  @override
  List<Object> get props => [users, failure, latLng, status];

  UserState copyWith({
    List<User>? users,
    Failure? failure,
    UserStatus? status,
    LatLng? latLng,
  }) {
    return UserState(
      users: users ?? this.users,
      failure: failure ?? this.failure,
      status: status ?? this.status,
      latLng: latLng ?? this.latLng,
    );
  }
}
