import 'package:codespot/config/custom-router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: "/wrapper",
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
    );
  }
}
