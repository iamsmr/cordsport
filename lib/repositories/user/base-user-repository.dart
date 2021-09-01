import 'package:codespot/models/models.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithID({required String id});
  Stream<List<User>> getUserWithInRadius({
    required GeoFirePoint center,
    required double radius,
  });
}
