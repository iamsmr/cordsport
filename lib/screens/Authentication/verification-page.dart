import 'package:codespot/screens/Authentication/cubit/auth-cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';
class VerificationPage extends StatefulWidget {
  static const String routeName = "/phoneVerification";
  static Route route() =>
      MaterialPageRoute(builder: (context) => VerificationPage());

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Phone Number"),
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
                SizedBox(height: 20),
                Text(
                  "You will recive 4 digit\ncode to verify",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: PinPut(
                    animationDuration: Duration(seconds: 0),
                    checkClipboard: true,
                    onChanged: (val) {
                      context.read<AuthCubit>().smsCodeChanged(val);
                    },
                    fieldsCount: 4,
                    withCursor: true,
                    textStyle: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                    eachFieldWidth: 55.0,
                    eachFieldHeight: 55.0,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                  ),
                ),
                SizedBox(height: 50),
                MaterialButton(
                  minWidth: 200,
                  height: 50,
                  onPressed: () {
                    context.read<AuthCubit>().signInWithPhoneNumber();
                  },
                  child: Text(
                    "Verify",
                    style: TextStyle(fontSize: 17),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Color(0xffFBD737),
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
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(198, 193, 193, 0.25),
        offset: Offset(0, 4),
        blurRadius: 4,
      )
    ],
  );
}

// +15555215554
