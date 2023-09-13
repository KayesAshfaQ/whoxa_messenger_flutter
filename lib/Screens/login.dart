// ignore_for_file: unused_element

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutterwhatsappclone/Screens/bottombar/newTabber.dart';
import 'package:flutterwhatsappclone/Screens/forgot_pass.dart';
import 'package:flutterwhatsappclone/Screens/signup.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';

import 'package:flutterwhatsappclone/share_preference/preferencesKey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  String _token = '';

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  _getToken() {
    FirebaseMessaging().getToken().then((token) {
      setState(() {
        _token = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: LayoutBuilder(builder: (context, constraint) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                        child: IntrinsicHeight(
                          child: Stack(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Center(
                                        child: Image.network(
                                      appLogo,
                                      height: 100,
                                    )),
                                  ),
                                  Container(
                                    height: 50,
                                  ),
                                  _emailTextfield(context),
                                  _passwordTextfield(context),
                                  // _forgotPassword(),
                                  _loginButton(context),
                                ],
                              ),
                              isLoading == true
                                  ? Center(child: loader())
                                  : Container(),
                            ],
                          ),
                        )),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                _dontHaveAnAccount(context),
              ],
            );
          })),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          focusNode: emailNode,
          textInputAction: TextInputAction.next,
          controller: emailController,
          hintText: 'Enter username',
          prefixIcon: Icon(
            Icons.person,
            size: 30.0,
            color: appColorBlue,
          ),
        ));
  }

  Widget _passwordTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          focusNode: passwordNode,
          controller: passwordController,
          obscureText: true,
          hintText: 'Enter Password',
          maxLines: 1,
          prefixIcon: Icon(
            Icons.lock,
            size: 30.0,
            color: appColorBlue,
          ),
        ));
  }

  Widget _forgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            setState(() {
              emailNode.unfocus();
              passwordNode.unfocus();
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgetPass()),
            );
          },
          child: Text.rich(
            TextSpan(
              text: 'Forgot Password?',
              style: TextStyle(
                fontSize: 14,
                color: appColorBlue,
                fontWeight: FontWeight.normal,
                fontFamily: "Poppins-Medium",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 0, left: 20),
        child: SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.screenWidth,
          child: CustomButtom(
            title: 'Log In',
            color: appColorBlue,
            textColor: appColorWhite,
            onPressed: () {
              if (emailController.text != '' && passwordController.text != '') {
                setState(() {
                  emailNode.unfocus();
                  passwordNode.unfocus();
                });

                _signInWithEmailAndPassword();
              } else {
                if (emailController.text.isEmpty) {
                  setState(() {
                    emailNode.unfocus();
                    passwordNode.unfocus();
                  });
                  Toast.show("Username is required", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                } else if (passwordController.text.isEmpty) {
                  setState(() {
                    emailNode.unfocus();
                    passwordNode.unfocus();
                  });
                  Toast.show("Password is required", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _dontHaveAnAccount(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SignUpScreen(),
          ),
        );
      },
      child: Padding(
        padding:
            const EdgeInsets.only(right: 20, top: 10, left: 20, bottom: 10),
        child: Text.rich(
          TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              fontSize: 14,
              color: appColorGrey,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  fontSize: 14,
                  // decoration: TextDecoration.underline,
                  color: appColorBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
            width: SizeConfig.blockSizeHorizontal * 30,
            height: 2.0,
            color: Colors.grey[300]),
      );

  Future<void> _signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim() + '@primocys.com',
        password: passwordController.text,
      )
          .then((currentUser) {
        if (currentUser != null) {
          print(currentUser.user.uid);
          dataEntry(currentUser.user.uid);
        } else {
          setState(() {
            isLoading = false;
          });
          Toast.show("Invalid Credentials ", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Toast.show(onError.toString(), context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      Toast.show("Invalid Credentials", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  dataEntry(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(SharedPreferencesKey.LOGGED_IN_USERRDATA, userId);

    _database.reference().child("user").child(userId).update({
      "token": _token,
      "status": "Online",
    }).then((value) {
      setState(() {
        isLoading = false;
        preferences.setString(SharedPreferencesKey.USER_VISIBILITY, 'On');
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TabbarScreen()),
      );
    });
  }
}
