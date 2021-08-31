part of 'location_bloc.dart';

enum LocationStatus { unkown, success, error }

class LocationState extends Equatable {
  final UserLocation location;
  final LocationStatus status;
  final Failure failure;
  const LocationState({
    required this.location,
    required this.status,
    required this.failure,
  });

  static LocationState initial() {
    return LocationState(
      location: UserLocation(latitude: 0, longitude: 0),
      status: LocationStatus.unkown,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [location, status, failure];

  LocationState copyWith({
    UserLocation? location,
    LocationStatus? status,
    Failure? failure,
  }) {
    return LocationState(
      location: location ?? this.location,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
