import 'package:codespot/screens/Authentication/cubit/phoneauth_cubit.dart';
import 'package:codespot/screens/Authentication/verification-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatefulWidget {

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
          listener: (context, state) {
            print(state);
            if (state.status == PhoneAuthStatus.error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(state.failure.message ?? ""),
                ),
              );
            } else if (state.status == PhoneAuthStatus.goToVerification &&
                state.smsCode == null) {
              Navigator.pushNamed(context, VerificationPage.routeName);
            }
          },
          builder: (context, state) {
            return Scaffold(
              // resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xffF6F5FA),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/Logo.png",
                          height: 60,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "CORDSPOT",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "location based anynomous\nchating application",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 50),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            onChanged: (val) => context
                                .read<PhoneAuthCubit>()
                                .phoneNumberChanged(val),
                            style: TextStyle(height: 1.6),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9+]+'),
                              ),
                              LengthLimitingTextInputFormatter(15),
                            ],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: false,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                color: Color(0xffCACACA),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          onPressed: () {
                            context.read<PhoneAuthCubit>().verifyPhoneNumber();
                          },
                          child: Text(
                            "Continue",
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
          },
        ),
      ),
    );
  }
}
