// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwhatsappclone/Screens/bottombar/newTabber.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PinPass extends StatefulWidget {
  @override
  _PinPassState createState() => _PinPassState();
}

class _PinPassState extends State<PinPass> {
  bool isLoading = false;
  TextEditingController passController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final passNode = FocusNode();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
                          // alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _appIcon(),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 5,
                                ),
                                Text(
                                  'Enter your password to continue',
                                  style: TextStyle(
                                    color: appColorGrey,
                                    fontFamily: 'Poppins-Medium',
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 3.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                _emailTextfield(context),
                                _loginButton(context),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          );
        }));
  }

  Widget _appIcon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
        child: Image.network(
          appLogo,
          height: SizeConfig.safeBlockVertical * 8,
        ),
      ),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          focusNode: passNode,
          controller: passController,
          hintText: 'Enter Your password',
          prefixIcon: Icon(
            Icons.person,
            size: 30.0,
            color: appColorBlue,
          ),
        ));
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
            title: 'Next',
            color: appColorBlue,
            onPressed: () {
              if (passController.text.trim() != "") {
                FirebaseAuth.instance.currentUser().then((user) {
                  if (user != null)
                    _database
                        .reference()
                        .child('user')
                        .child(user.uid)
                        .once()
                        .then((peerData) {
                      setState(() {
                        if (peerData.value['passCode'] ==
                            passController.text.trim()) {
                          _database
                              .reference()
                              .child("user")
                              .child(user.uid)
                              .update({"passCodeStatus": false});
                          passCodeStatus = false;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TabbarScreen()),
                          );
                        } else {
                          Fluttertoast.showToast(msg: 'Incorrect Password');
                        }
                      });
                    });
                });
              } else {
                Fluttertoast.showToast(msg: 'Please enter password.');
              }
            },
          ),
        ),
      ),
    );
  }
}
