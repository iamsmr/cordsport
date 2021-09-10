import 'package:bloc/bloc.dart';
import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/models/message.dart';
import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/chat/chat_repository.dart';
import 'package:equatable/equatable.dart';
part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final ChatRepository _chatRepository;
  final AuthBloc _authBloc;
  MessageCubit({
    required ChatRepository chatRepository,
    required AuthBloc authBloc,
  })  : _chatRepository = chatRepository,
        _authBloc = authBloc,
        super(MessageState.initial());

  void messageChaned(String message) {
    emit(state.copyWith(status: MessageStatus.initial, message: message));
  }

  void sendMessage(User? otherUser) async {
    if (otherUser == null &&
        state.message.isEmpty &&
        _authBloc.state.user == null) return;

    try {
      emit(state.copyWith(status: MessageStatus.sending));
      final User other = otherUser!;
      final User me = User.empty().copyWith(uid: _authBloc.state.user!.uid);
      final convId = other.uid + me.uid;
      final Message message = Message(
        text: state.message,
        other: other,
        me: me,
        datetime: DateTime.now(),
        messageRead: false,
        convercationId: normalize(convId),
      );
      await _chatRepository.sendMessage(message: message);
      emit(state.copyWith(status: MessageStatus.send));
    } on Failure catch (e) {
      emit(state.copyWith(status: MessageStatus.error, failure: e));
    }
  }

  String normalize(String str) => (str
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]', caseSensitive: false), '')
          .split('')
        ..sort())
      .join('');
}
