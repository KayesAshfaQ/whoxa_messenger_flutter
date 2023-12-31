import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';

import 'login.dart';

class ForgetPass2 extends StatefulWidget {
  @override
  _ForgetPass2State createState() => _ForgetPass2State();
}

class _ForgetPass2State extends State<ForgetPass2> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 100),
                      //   child: Center(child: _appIcon()),
                      // ),
                      Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Image.network(
                            appLogo,
                            height: 100,
                          )),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      Text(
                        'Check Your Email',
                        style: TextStyle(
                          color: appColorGrey,
                          fontSize: SizeConfig.safeBlockHorizontal * 6,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      Text(
                        'We have send you a password recovery \n instruction to your email',
                        style: TextStyle(
                          color: appColorGrey,
                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      _loginButton(context),
                      // _dontHaveAnAccount(context),
                    ],
                  ),
                )),
          );
        }));
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 10, left: 20),
        child: SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.screenWidth,
          child: CustomButtom(
            title: 'Ok',
            color: appColorBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
