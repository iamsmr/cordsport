import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class User extends Equatable {
  final String codeName;
  final LatLng cordinates;
  final String email;
  final String phoneNumber;
  final String profileUrl;
  final String uid;
  const User({
    required this.codeName,
    required this.cordinates,
    required this.email,
    required this.phoneNumber,
    required this.profileUrl,
    required this.uid,
  });

  @override
  List<Object> get props {
    return [
      codeName,
      cordinates,
      email,
      phoneNumber,
      profileUrl,
      uid,
    ];
  }

  Map<String, dynamic> toDocument() {
    return {
      "codeName": codeName,
      "cordinates": _toGeoPoint(cordinates),
      "email": email,
      "phoneNumber": phoneNumber,
      "profileUrl": profileUrl,
      "uid": uid
    };
  }

  factory User.empty() {
    return User(
      codeName: "",
      cordinates: LatLng(0, 0),
      email: "",
      phoneNumber: "",
      profileUrl: "",
      uid: "",
    );
  }

  factory User.fromDocument(DocumentSnapshot snap) {
    final data = snap.data() as Map;
    return User(
      codeName: data["codeName"] ?? "",
      cordinates: _toLatLang(data["cordinates"]),
      email: data["email"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      profileUrl: data["profileUrl"] ?? "",
      uid: data["uid"] ?? "",
    );
  }

  User copyWith({
    String? codeName,
    LatLng? cordinates,
    String? email,
    String? phoneNumber,
    String? profileUrl,
    String? uid,
  }) {
    return User(
      codeName: codeName ?? this.codeName,
      cordinates: cordinates ?? this.cordinates,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileUrl: profileUrl ?? this.profileUrl,
      uid: uid ?? this.uid,
    );
  }
}

LatLng _toLatLang(GeoPoint point) {
  return LatLng(point.latitude, point.longitude);
}

GeoPoint _toGeoPoint(LatLng latLng) {
  return GeoPoint(latLng.latitude, latLng.longitude);
}
