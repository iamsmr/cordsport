part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {}

class LocationStarted extends LocationEvent {
  @override
  List<Object?> get props => [];
}

class LocationChanged extends LocationEvent {
  final Position position;
  LocationChanged({required this.position});
  @override
  List<Object?> get props => [position];
}

class LocationUserGetUserWithInOneKiloMterDistance extends LocationEvent {
  @override
  List<Object?> get props => [];
}
