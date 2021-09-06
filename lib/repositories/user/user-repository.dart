import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/config/paths.dart';
import 'package:codespot/models/user.dart';
import 'package:codespot/repositories/user/base-user-repository.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Geoflutterfire _geoflutterfire;

  UserRepository({
    FirebaseFirestore? firebaseFirestore,
    Geoflutterfire? geoflutterfire,
  })  : _geoflutterfire = geoflutterfire ?? Geoflutterfire(),
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithID({required String id}) async {
    final docSnap =
        await _firebaseFirestore.collection(Paths.users).doc(id).get();
    return docSnap.exists ? User.fromDocument(docSnap) : User.empty();
  }

  /// rturn [users] within only 1km radiius

  @override
  Stream<List<User>> getUserWithInRadius({
    required double radius,
    required LatLng center,
  }) {
    CollectionReference _collectionRef =
        _firebaseFirestore.collection(Paths.users);
    final allUsers = _collectionRef.snapshots().map((users) =>
        _distanceQuery(users.docs, center)
            .map((user) => User.fromDocument(user))
            .toList());
    return allUsers;
  }

  List<QueryDocumentSnapshot<Object?>> _distanceQuery(
      List<QueryDocumentSnapshot<Object?>> users, LatLng center) {
    List<QueryDocumentSnapshot<Object?>> _newUsers = [];
    for (int i = 0; i < users.length; i++) {
      final point = _latLangToGeoFirePoint(center);
      final data = users[i].data() as Map<String, dynamic>;
      final cordinats = data["cordinates"];
      final latitude = cordinats.latitude;
      final longitude = cordinats.longitude;
      final distacne = point.distance(lat: latitude, lng: longitude);
      if (distacne <= 1000) {
        _newUsers.add(users[i]);
      }
    }

    return _newUsers;
  }

  GeoFirePoint _latLangToGeoFirePoint(LatLng latLng) {
    return GeoFirePoint(latLng.latitude, latLng.longitude);
  }

  @override
  Future<void> updateCordinates({
    required String id,
    required GeoPoint cordinates,
  }) async {
    await _firebaseFirestore.collection(Paths.users).doc(id).update({
      "cordinates": cordinates,
    });
  }

  @override
  Future<void> updateCodeName(
      {required String codeName, required String id}) async {
    await _firebaseFirestore.collection(Paths.users).doc(id).update(
      {"codeName": codeName},
    );
  }
}
