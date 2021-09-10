part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class MessageUpdateMessage extends MessageEvent {
  final List<Message?> messages;
  const MessageUpdateMessage({
    required this.messages,
  });

  @override
  List<Object?> get props => [messages];
}
