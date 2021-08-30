import 'package:codespot/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:codespot/screens/Authentication/login-page.dart';
import 'package:codespot/screens/home/home-page.dart';

class Wrapper extends StatelessWidget {
  static const String routeName = "/wrapper";
  static Route route() => MaterialPageRoute(builder: (_) => Wrapper());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
