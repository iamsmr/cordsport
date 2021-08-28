import 'package:codespot/screens/Authentication/phone-auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  static const String routeName = "/wrapper";
  static Route route() => MaterialPageRoute(builder: (_) => Wrapper());
  @override
  Widget build(BuildContext context) {
    return PhoneAuthPage();
  }
}
