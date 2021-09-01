import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:codespot/screens/Authentication/login-page.dart';

class Wrapper extends StatelessWidget {
  static const String routeName = "/wrapper";
  static Route route() => PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => Wrapper(),
      );
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return NavScreen();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
