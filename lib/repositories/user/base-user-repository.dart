import 'package:codespot/models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithID({required String id});
  Stream<List<User>> getUserWithInRadius({
    required LatLng center,
    required double radius,
  });
}
