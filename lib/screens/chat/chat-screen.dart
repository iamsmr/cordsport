import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/blocs/user/user_bloc.dart';
import 'package:codespot/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Chat Screen"),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
                icon: Icon(Icons.exit_to_app),
              )
            ],
          ),
          backgroundColor: const Color(0xffF6F5FA),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: state.users.length,
              itemBuilder: (context, int index) {
                final user = state.users[index];
                return Container(
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatRoom(user: user)),
                    ),
                    title: Text(user.codeName),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xffFBD737),
                      child: Icon(Icons.person, color: Colors.grey[600]),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
