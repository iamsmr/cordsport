import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:codespot/screens/Authentication/cubit/auth-cubit.dart';
import 'package:codespot/screens/Authentication/login-page.dart';
import 'package:codespot/screens/home/home-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatelessWidget {
  static const String routeName = "/wrapper";
  static Route route() => MaterialPageRoute(builder: (_) => Wrapper());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print(state.status);
        if (state.status == AuthStatus.authenticated) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
