import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/constatnt/Constant.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';
import 'package:flutterwhatsappclone/models/appSettingModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  bool isLoading = false;
  AnimationController animationController;
  Animation<double> animation;
  AppSettingModel appSettingModel;
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  // void navigationPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => Intro()),
  //   );
  // }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(APP_SCREEN);
  }

  @override
  void initState() {
    super.initState();
    getUser();
    permissionAcessPhone();
    // _generalSetting();
    startTime();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 4));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });

    // new Timer(new Duration(milliseconds: 3000), () {
    //   checkFirstSeen();
    // });
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      if (preferences.containsKey('name')) {
        globalName = preferences.getString('name');
        globalImage = preferences.getString('image');
      }
    });
  }

  permissionAcessPhone() async {
    await [
      Permission.contacts,
      Permission.notification,
      Permission.camera,
    ].request();

    if (await Permission.contacts.request().isGranted) {
      getContactsFromGloble();
      // startTime();
    }
  }

  _generalSetting() async {
    setState(() {
      isLoading = true;
    });
    var uri =
        Uri.parse('http://primocysapp.com/whoxa-admin/api/get-app-settings');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    appSettingModel = AppSettingModel.fromJson(userData);
    print("+++++++++");
    print(responseData);
    print("+++++++++");
    if (appSettingModel.responseCode == "1") {
      setState(() {
        appName = appSettingModel.property[0].sValue;
        appColorBlue = Color(int.parse(appSettingModel.property[1].sValue));
        appLogo = appSettingModel.property[2].sValue;
      });
      startTime();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Center(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        imageLogo(),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Welcome to $appName Secure Messenger.\nThe No1 privacy and secure communication system for users that’s value their privacy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        globalName.length > 0
                            ? Container(height: 80)
                            : Container(),
                        globalName.length > 0 ? textWidget() : Container(),
                      ],
                    ),
                  ),
                ),
                bottomWidget()
              ],
            ),
    );
  }

  Widget imageLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80,
          width: 80,
          child: Image.network(
            appLogo,
            fit: BoxFit.cover,
          ),
        ),
        globalImage.length > 0 ? Container(width: 50, height: 0) : Container(),
        globalImage.length > 0
            ? Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: appColorBlue, width: 4)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: customImage(globalImage),
                ))
            : Container(),
      ],
    );
  }

  Widget textWidget() {
    return Column(
      children: [
        Text(
          "Logged in as ",
          style: TextStyle(
              color: Colors.black45, fontSize: 12, fontFamily: boldFamily),
        ),
        Container(height: 10),
        Text(
          globalName,
          style: TextStyle(
              color: Colors.black45, fontSize: 22, fontFamily: boldFamily),
        ),
      ],
    );
  }

  Widget bottomWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "from",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black45, fontSize: 14, fontFamily: boldFamily),
            ),
          ],
        ),
        Container(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$appName".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: appColorBlue, fontSize: 20, fontFamily: boldFamily),
            ),
          ],
        ),
        Container(height: 40),
      ],
    );
  }
}
