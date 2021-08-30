import 'package:codespot/screens/Authentication/cubit/auth-cubit.dart';
import 'package:codespot/screens/Authentication/verification-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<AuthCubit, AuthCubitState>(
          listener: (context, state) {
            print(state);
            if (state.status == PhoneAuthStatus.error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Something Went Wrong!."),
                  content: Text(state.failure.message ?? ''),
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
              body: SafeArea(
                child: Stack(
                  children: [
                    Center(
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
                              Form(
                                key: _formKey,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: InternationalPhoneNumberInput(
                                    inputBorder: InputBorder.none,
                                    validator: (val) {
                                      String patttern =
                                          r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                      RegExp regExp = new RegExp(patttern);
                                      if (!regExp.hasMatch(val!)) {
                                        return "Enter a valid phone";
                                      } else if (val.length < 8) {
                                        return "Plase Enter phone number";
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.phone,
                                    selectorConfig: SelectorConfig(
                                      showFlags: true,
                                      selectorType:
                                          PhoneInputSelectorType.DROPDOWN,
                                    ),
                                    onInputChanged: (PhoneNumber value) {
                                      context
                                          .read<AuthCubit>()
                                          .phoneNumberChanged(
                                            value.phoneNumber!,
                                          );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              MaterialButton(
                                minWidth: double.infinity,
                                height: 50,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    verifyPhoneNumber(context);
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
                              const SizedBox(height: 30),
                              InkWell(
                                onTap: () {
                                  context
                                      .read<AuthCubit>()
                                      .loginWithGoogleAcc();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Container(
                                    height: 57,
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              185, 182, 182, 0.5),
                                          offset: Offset(0, 2),
                                          blurRadius: 72,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Image.asset(
                                          "assets/images/google_logo.png",
                                          height: 29,
                                          width: 29,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Continue with google",
                                          style: TextStyle(
                                            color: Color(0xff777777),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (state.status == PhoneAuthStatus.loading)
                      linearProgressLoading(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void verifyPhoneNumber(BuildContext context) {
    context.read<AuthCubit>().verifyPhoneNumber();
  }

  Widget linearProgressLoading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
      ),
      child: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 5,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.yellow[900]!,
            ),
          ),
        ],
      ),
    );
  }
}
