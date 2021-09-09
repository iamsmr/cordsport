import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/config/paths.dart';
import 'package:codespot/models/message.dart';
import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/chat/base_chat_repository.dart';
import 'package:flutter/services.dart';

class ChatRepository extends BaseChatRepository {
  final FirebaseFirestore _firebaseFirestore;

  ChatRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<Message?>>> getMessage({
    required String convId,
    required String msgId,
  }) {
    try {
      final message = _firebaseFirestore
          .collection(Paths.conversations)
          .doc(convId)
          .collection(Paths.messages)
          .snapshots()
          .map((messages) => _mapQuerySnapToMessageModel(messages.docs));

      return message;
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on SocketException catch (e) {
      throw Failure(message: e.message);
    }
  }

  List<Future<Message?>> _mapQuerySnapToMessageModel(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs.map((message) => Message.fromDocument(message)).toList();
  }

  @override
  Future<void> sendMessage({required Message message}) async {
    try {
      await _firebaseFirestore
          .collection(Paths.conversations)
          .doc(message.convercationId)
          .collection(Paths.messages)
          .add(message.toDocument());
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on SocketException catch (e) {
      throw Failure(message: e.message);
    }
  }
}
