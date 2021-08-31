import 'package:codespot/models/user-location.dart';

abstract class BaseLocationRepository {
  Future<UserLocation> getLocation();
  Stream<UserLocation> locationChange();
}
