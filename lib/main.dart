import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/config/custom-router.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(
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
