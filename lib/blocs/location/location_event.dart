part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LocationEventGetLocation extends LocationEvent {}

class LocationEventUpdateLocation extends LocationEvent {
  final LatLng? userLocation;
  const LocationEventUpdateLocation({this.userLocation});

  @override
  List<Object?> get props => [userLocation];
}
