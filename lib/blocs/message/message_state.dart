part of 'message_bloc.dart';

enum MessageStatus { initial, loading, loaded, error }

class MessageState extends Equatable {
  final List<Message?> messages;
  final Failure failure;
  final MessageStatus messageStatus;
  const MessageState({
    required this.messages,
    required this.failure,
    required this.messageStatus,
  });

  factory MessageState.initial() {
    return const MessageState(
      messageStatus: MessageStatus.initial,
      failure: Failure(),
      messages: [],
    );
  }

  @override
  List<Object> get props => [messages, failure, messageStatus];

  MessageState copyWith({
    List<Message?>? messages,
    Failure? failure,
    MessageStatus? messageStatus,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      failure: failure ?? this.failure,
      messageStatus: messageStatus ?? this.messageStatus,
    );
  }

  @override
  bool get stringify => true;
}
