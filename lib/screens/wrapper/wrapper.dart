import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/blocs/user/user_bloc.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:codespot/repositories/user/user_repository.dart';
import 'package:codespot/screens/navigation/cubit/bottom_nav_bar_cubit.dart';
import 'package:codespot/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:codespot/screens/Authentication/login_page.dart';

class Wrapper extends StatelessWidget {
  static const String routeName = "/wrapper";

  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState.status == AuthStatus.authenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => UserBloc(
                  authBloc: context.read<AuthBloc>(),
                  userRepository: context.read<UserRepository>(),
                )..add(UserGetCurrentUser()),
              ),
              BlocProvider(
                create: (context) => LocationBloc(
                  userRepository: context.read<UserRepository>(),
                  userBloc: context.read<UserBloc>(),
                )..add(LocationStarted()),
              ),
              BlocProvider(
                create: (context) => BottomNavBarCubit(),
                child: NavScreen(),
              ),
            ],
            child: NavScreen(),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class CodeNameSetting extends StatefulWidget {
  const CodeNameSetting({Key? key}) : super(key: key);

  @override
  _CodeNameSettingState createState() => _CodeNameSettingState();
}

class _CodeNameSettingState extends State<CodeNameSetting> {
  final TextEditingController _codeName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F5FA),
      appBar: AppBar(
        title: const Text("Code Name"),
        leading: const SizedBox(),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                      offset: Offset(2, 3),
                      spreadRadius: 1,
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: TextFormField(
                  autofocus: true,
                  controller: _codeName,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Code Name",
                  ),
                ),
              ),
              const SizedBox(height: 50),
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  if (_codeName.text.isNotEmpty) {
                    _updateCodeName(context);
                  }
                },
                child: const Text("Continue", style: TextStyle(fontSize: 17)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color(0xffFBD737),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateCodeName(BuildContext context) {
    context.read<UserBloc>().add(UserUpdateCodeName(codeName: _codeName.text));
  }
}
