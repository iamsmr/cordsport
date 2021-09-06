part of 'location_bloc.dart';

enum LocationStatus { unkown, success, error }

class LocationState extends Equatable {
  final LatLng? location;
  final LocationStatus status;
  final Failure failure;
  const LocationState({
    required this.location,
    required this.status,
    required this.failure,
  });

  static LocationState initial() {
    return LocationState(
      location: null,
      status: LocationStatus.unkown,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [location, status, failure];

  LocationState copyWith({
    LatLng? location,
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
