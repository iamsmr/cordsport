import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final String code;

  const Failure({this.message = "", this.code = ""});

  @override
  List<Object?> get props => [message, code];
}
