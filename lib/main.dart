
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:codespot/blocs/bloc_observer.dart';
import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/repositories/repositories.dart';

import 'package:codespot/screens/Authentication/cubit/auth-cubit.dart';
import 'package:codespot/config/custom_router.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<UserRepository>(create: (_) => UserRepository())
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
          ),
        ],
        child: MaterialApp(
          title: 'Cordspot',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: '/wrapper',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              elevation: 1,
              centerTitle: true,
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.grey),
            ),
            primarySwatch: Colors.yellow,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
