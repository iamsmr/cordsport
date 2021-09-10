import 'package:bloc/bloc.dart';
import 'package:codespot/models/models.dart';
import 'package:equatable/equatable.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageState.initial());

  void messageChaned(String message) {
    emit(state.copyWith(status: MessageStatus.initial, message: message));
  }

  void sendMessage(){

  }


}
