import 'package:codespot/models/models.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  final User user;

  const ChatRoom({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.codeName)),
      body: Column(
        children: [
          Spacer(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: 60,
          width: double.infinity,
          child: Row(
            children: [
              // TODO: implemnt image test field
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Message",
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.send))
            ],
          ),
        ),
      ),
    );
  }
}
