part of 'message_cubit.dart';

enum MessageStatus { initial, sending, send, error }

class MessageState extends Equatable {
  final MessageStatus status;
  final Failure failure;
  final String message;

  const MessageState({
    required this.status,
    required this.failure,
    required this.message,
  });

  factory MessageState.initial() {
    return const MessageState(
      status: MessageStatus.initial,
      failure: Failure(),
      message: "",
    );
  }

  @override
  List<Object> get props => [status, failure, message];

  MessageState copyWith({
    MessageStatus? status,
    Failure? failure,
    String? message,
  }) {
    return MessageState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }

  @override
  bool get stringify => true;
}
