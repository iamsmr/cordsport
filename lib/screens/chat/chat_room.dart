import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/blocs/message/message_bloc.dart';
import 'package:codespot/models/models.dart';
import 'package:codespot/screens/chat/cubit/message_cubit.dart' as cubit;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoom extends StatefulWidget {
  final User user;

  const ChatRoom({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
 final TextEditingController _message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.codeName)),
      body: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              // controller: listScrollController,
              child: Column(
                children: List.generate(state.messages.length, (index) {
                  final message = state.messages[index];
                  if (message != null) {
                    bool isMe = message.me.uid ==
                        context.read<AuthBloc>().state.user!.uid;
                    return Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xffFBD737)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 13,
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocConsumer<cubit.MessageCubit, cubit.MessageState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BottomAppBar(
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: 60,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _message,
                      onChanged: (val) {
                        context.read<cubit.MessageCubit>().messageChaned(val);
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (state.status != cubit.MessageStatus.sending) {
                        _message.clear();
                        context
                            .read<cubit.MessageCubit>()
                            .sendMessage(widget.user);
                      }
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
