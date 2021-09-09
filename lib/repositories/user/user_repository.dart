import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/config/paths.dart';
import 'package:codespot/models/user.dart';
import 'package:codespot/repositories/user/base_user_repository.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({
    FirebaseFirestore? firebaseFirestore,
    Geoflutterfire? geoflutterfire,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithID({required String id}) async {
    final docSnap =
        await _firebaseFirestore.collection(Paths.users).doc(id).get();
    return docSnap.exists ? User.fromDocument(docSnap) : User.empty();
  }

  /// rturn [users] within only 1km or 1000m radiius

  @override
  Stream<List<User>> getUserWithInRadius({
    required double radius,
    required Position center,
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
      List<QueryDocumentSnapshot<Object?>> users, Position center) {
    List<QueryDocumentSnapshot<Object?>> _newUsers = [];
    for (int i = 0; i < users.length; i++) {
      final point = center;
      final data = users[i].data() as Map<String, dynamic>;
      final cordinats = data["cordinates"] as GeoPoint;

      final distance = Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        cordinats.latitude,
        cordinats.longitude,
      );
      if (distance <= 1000) {
        _newUsers.add(users[i]);
      }
    }

    return _newUsers;
  }

  @override
  Future<void> updateCordinates({
    required String id,
    required Position position,
  }) async {
    await _firebaseFirestore.collection(Paths.users).doc(id).update({
      "cordinates": toGeoPoint(position),
    });
  }

  @override
  Future<void> updateCodeName({
    required String codeName,
    required String id,
  }) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(id)
        .update({"codeName": codeName});
  }

  GeoPoint toGeoPoint(Position position) {
    return GeoPoint(position.latitude, position.longitude);
  }
}
