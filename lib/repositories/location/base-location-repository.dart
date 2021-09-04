import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class BaseLocationRepository {
  Future<LatLng> getLocation();
  Stream<LatLng> locationChange();
}
