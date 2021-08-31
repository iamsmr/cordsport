import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/location/base-location-repository.dart';
import 'package:location/location.dart';

class LocationReository extends BaseLocationRepository {
  final Location _location;

  LocationReository({Location? location}) : _location = location ?? Location();

  @override
  Future<UserLocation> getLocation() async {
    try {
      final locationData = await _location.getLocation();
      return UserLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );
    } catch (e) {
      throw Failure(message: e.toString());
    }
  }

  @override
  Stream<UserLocation> locationChange() async* {
    yield* await _location.requestPermission().then(
      (value) {
        return _location.onLocationChanged.map(
          (locationData) => UserLocation(
            latitude: locationData.latitude!,
            longitude: locationData.latitude!,
          ),
        );
      },
    );
  }
}
