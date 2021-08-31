import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:codespot/blocs/bloc-observer.dart';
import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/repositories/repositories.dart';

import 'package:codespot/screens/Authentication/cubit/auth-cubit.dart';
import 'package:codespot/config/custom-router.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<LocationReository>(
          create: (_) => LocationReository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          )
        ],
        child: MaterialApp(
          title: 'Cordspot',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: "/wrapper",
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              elevation: 1,
              centerTitle: true,
              color: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.grey,
              ),
            ),
            primarySwatch: Colors.yellow,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
