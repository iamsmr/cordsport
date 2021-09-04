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

  @override
  Stream<List<User>> getUserWithInRadius({
    required double radius,
    required LatLng center,
  }) {
    CollectionReference _collectionRef =
        _firebaseFirestore.collection(Paths.users);
    return _geoflutterfire
        .collection(collectionRef: _collectionRef)
        .within(
          center: _latLangToGeoFirePoint(center),
          radius: radius,
          field: "cordinates",
        )
        .map((users) => users.map((user) => User.fromDocument(user)).toList());
  }

  GeoFirePoint _latLangToGeoFirePoint(LatLng latLng) {
    return GeoFirePoint(latLng.latitude, latLng.longitude);
  }
}
