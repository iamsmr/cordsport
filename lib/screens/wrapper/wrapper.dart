import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/blocs/location/location_bloc.dart';
import 'package:codespot/blocs/user/user_bloc.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:codespot/repositories/user/user-repository.dart';
import 'package:codespot/screens/navigation/cubit/bottom_nav_bar_cubit.dart';
import 'package:codespot/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:codespot/screens/Authentication/login-page.dart';

class Wrapper extends StatelessWidget {
  static const String routeName = "/wrapper";
  static Route route() => PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, __, ___) => Wrapper(),
      );
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
                )..add(UserGetUserWitId()),
              ),
              BlocProvider(
                create: (context) => LocationBloc(
                  userBloc: context.read<UserBloc>(),
                  authBloc: context.read<AuthBloc>(),
                  locationReository: context.read<LocationReository>(),
                )..add(LocationEventGetLocation()),
              ),
              BlocProvider(
                create: (context) => BottomNavBarCubit(),
                child: NavScreen(),
              ),
            ],
            child: NavScreen(),
          );
        } else {
          return LoginPage();
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
  late TextEditingController _codeName;
  @override
  void initState() {
    _codeName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _codeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F5FA),
      appBar: AppBar(
        title: Text("Code Name"),
        leading: SizedBox(),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
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
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Code Name",
                  ),
                ),
              ),
              SizedBox(height: 50),
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  if (_codeName.text.isNotEmpty) {
                    context.read<UserBloc>().add(
                          UserUpdateCodeName(codeName: _codeName.text),
                        );
                  }
                },
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 17),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Color(0xffFBD737),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
