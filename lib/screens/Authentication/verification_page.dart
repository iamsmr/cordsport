import 'package:codespot/screens/Authentication/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerificationPage extends StatefulWidget {
  static const String routeName = "/phoneVerification";

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Phone Number"),
      ),
      backgroundColor: const Color(0xffF6F5FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/verification.png"),
                const SizedBox(height: 20),
                Text(
                  "You will recive 4 digit\ncode to verify",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: PinPut(
                    animationDuration: const Duration(seconds: 0),
                    checkClipboard: true,
                    onChanged: (val) {
                      context.read<AuthCubit>().smsCodeChanged(val);
                    },
                    fieldsCount: 6,
                    withCursor: true,
                    textStyle: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                    eachFieldWidth: 45.0,
                    eachFieldHeight: 55.0,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                  ),
                ),
                const SizedBox(height: 50),
                MaterialButton(
                  minWidth: 200,
                  height: 50,
                  onPressed: () {
                    context.read<AuthCubit>().signInWithPhoneNumber();
                  },
                  child: const Text(
                    "Verify",
                    style: TextStyle(fontSize: 17),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: const Color(0xffFBD737),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(198, 193, 193, 0.25),
        offset: Offset(0, 4),
        blurRadius: 4,
      )
    ],
  );
}

// +15555215554
