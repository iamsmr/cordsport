import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithID({required String id});
  Future<void> updateCordinates({
    required String id,
    required GeoPoint cordinates,
  });
  Stream<List<User>> getUserWithInRadius({
    required LatLng center,
    required double radius,
  });
  Future<void> updateCodeName({required String codeName,required String id});
}
