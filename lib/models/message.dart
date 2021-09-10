import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codespot/config/paths.dart';
import 'package:equatable/equatable.dart';

import 'package:codespot/models/models.dart';

class Message extends Equatable {
  final String text;
  final User other;
  final User me;
  final DateTime datetime;
  final bool messageRead;
  final String? messageId;
  final String convercationId;

  const Message({
    this.messageId,
    required this.text,
    required this.other,
    required this.me,
    required this.datetime,
    required this.messageRead,
    required this.convercationId,
  });

  Message copyWith({
    String? text,
    User? other,
    User? me,
    DateTime? timestamp,
    bool? messageRead,
    String? messageId,
    String? convercationId,
  }) {
    return Message(
      text: text ?? this.text,
      other: other ?? this.other,
      me: me ?? this.me,
      datetime: timestamp ?? datetime,
      messageRead: messageRead ?? this.messageRead,
      messageId: messageId ?? this.messageId,
      convercationId: convercationId ?? this.convercationId,
    );
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toDocument() {
    return {
      'text': text,
      'other': toDocumentRefrence(other),
      'me': toDocumentRefrence(me),
      'timestamp': datetime.millisecondsSinceEpoch,
      'messageRead': messageRead,
      'convercationId': convercationId,
    };
  }

  static Future<Message?> fromDocument(DocumentSnapshot snapshot) async {
    final data = snapshot.data() as Map<String, dynamic>;
    final senderref = data["other"] as DocumentReference?;
    final meRef = data["me"] as DocumentReference?;

    if (senderref != null && meRef != null) {
      final senderDoc = await senderref.get();
      final meDoc = await meRef.get();

      if (senderDoc.exists && meDoc.exists) {
        return Message(
          text: data['text'] ?? "",
          other: User.fromDocument(senderDoc),
          me: User.fromDocument(meDoc),
          datetime: (data["timestamp"] as Timestamp).toDate(),
          messageRead: data["messageRead"] ?? false,
          messageId: data["messageId"] ?? "",
          convercationId: data["convercationId"] ?? "",
        );
      }
    }
  }

  static DocumentReference toDocumentRefrence(User user) {
    return FirebaseFirestore.instance.collection(Paths.users).doc(user.uid);
  }

  @override
  List<Object?> get props {
    return [
      text,
      other,
      me,
      datetime,
      messageRead,
      messageId,
      convercationId,
    ];
  }
}
