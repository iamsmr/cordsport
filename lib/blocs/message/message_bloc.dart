import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/models/message.dart';
import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/chat/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository _chatRepository;
  final AuthBloc _authBloc;
  final User otherUser;

  StreamSubscription<List<Future<Message?>>>? _messageSubscription;

  MessageBloc({
    required this.otherUser,
    required ChatRepository chatRepository,
    required AuthBloc authBloc,
  })  : _chatRepository = chatRepository,
        _authBloc = authBloc,
        super(MessageState.initial()) {
    _messageSubscription?.cancel();
    final convId = normalize(otherUser.uid + _authBloc.state.user!.uid);

    _messageSubscription =
        _chatRepository.getMessage(convId: convId).listen((messages) async {
      final allMessage = await Future.wait(messages);
      add(MessageUpdateMessage(messages: allMessage));
    });
  }
  String normalize(String str) => (str
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]', caseSensitive: false), '')
          .split('')
        ..sort())
      .join('');

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is MessageUpdateMessage) {
      yield* _mapNotificationUpdateEventToState(event);
    }
  }

  Stream<MessageState> _mapNotificationUpdateEventToState(
      MessageUpdateMessage event) async* {
    yield state.copyWith(
      messages: event.messages,
      messageStatus: MessageStatus.loaded,
    );
  }
}
