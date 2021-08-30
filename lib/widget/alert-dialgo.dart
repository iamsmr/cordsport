import 'package:flutter/material.dart';

class CustomErrorDialgo extends StatelessWidget {
  final String title;
  final String content;
  const CustomErrorDialgo({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title),
      content: Text(content),
      actions: [
        MaterialButton(
          minWidth: double.infinity,
          color: const Color(0xffFBD737),
          child: Text("Cancel"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
