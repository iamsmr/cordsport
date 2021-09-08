import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/location/base-location-repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationReository extends BaseLocationRepository {
  final Location _location;

  LocationReository({Location? location}) : _location = location ?? Location();

  @override
  Future<LatLng> getLocation() async {
    try {
     return await _location.getLocation().then((LocationData locationData) {
        return LatLng(locationData.latitude!, locationData.longitude!);
      }).onError((error, stackTrace) => throw Failure(message: error.toString()));
    } catch (e) {
      throw Failure(message: e.toString());
    }
  }

  @override
  Stream<LatLng?> locationChange() async* {
    yield* await _location.requestPermission().then(
      (value) {
        return _location.onLocationChanged.map((LocationData locationData) {
          if (locationData.latitude != null && locationData.longitude != null) {
            return LatLng(locationData.latitude!, locationData.longitude!);
          }
        });
      },
    );
  }
}
