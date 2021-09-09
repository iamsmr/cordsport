import 'package:codespot/models/models.dart';
import 'package:geolocator/geolocator.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithID({required String id});
  Future<void> updateCordinates({
    required String id,
    required Position position,
  });
  Stream<List<User>> getUserWithInRadius({
    required Position center,
    required double radius,
  });
  Future<void> updateCodeName({required String codeName, required String id});
}
