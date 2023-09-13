// ignore_for_file: unused_field

import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/Screens/accountoptions.dart';
import 'package:flutterwhatsappclone/Screens/chatbg.dart';

import 'package:flutterwhatsappclone/Screens/editProfile.dart';
import 'package:flutterwhatsappclone/Screens/intro.dart';
import 'package:get/get.dart';
import 'package:flutterwhatsappclone/Screens/staredMsg.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/share_preference/preferencesKey.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsOptions extends StatefulWidget {
  @override
  _SettingsOptionsState createState() => _SettingsOptionsState();
}

class _SettingsOptionsState extends State<SettingsOptions> {
  double _height, _width, _fixedPadding;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool visibilitySwitch = true;
  bool themeSwitch = false;
  @override
  void initState() {
    print('USER visi : $userVisibility');

    if (userVisibility == null || userVisibility == 'On') {
      setState(() {
        visibilitySwitch = true;
      });
    } else {
      setState(() {
        visibilitySwitch = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  refresh() {
    setState(() {});
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    if (Theme.of(context).brightness == Brightness.dark) {
      setState(() {
        themeSwitch = true;
      });
    } else {
      setState(() {
        themeSwitch = false;
      });
    }
    print(Theme.of(context).brightness);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings'.tr,
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // elevation: _showAppbar ? 0 : 1,

        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: _getColumnBody(),
            ),

            // loader ? Center(child: CircularProgressIndicator()) : SizedBox()
          ],
        ),
      ),
    );
  }

  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'Portuguese', 'locale': Locale('pt', 'PT')},
    {'name': 'Arabic', 'locale': Locale('ar', 'AR')},
    {'name': 'French', 'locale': Locale('fr', 'FR')},
  ];
  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose Your Language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () {
                          print(locale[index]['name']);
                          updateLanguage(locale[index]['locale']);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  Widget _getColumnBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Card(
              elevation: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(refresh: refresh)),
                          );
                        },
                        leading: globalImage.length > 0
                            ? CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(globalImage),
                                // child: Image.network(
                                //   globalImage,
                                //   fit: BoxFit.cover,
                                // ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: Text(
                                  globalName[0].toString(),
                                ),
                              ),
                        title: Text(
                          globalName,
                          style: TextStyle(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          'Edit'.tr,
                          style: TextStyle(color: appColorBlue),
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _height * 0.030,
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StarMsg()),
                  );
                },
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.star),
                ),
                title: Text('Starred Messages'.tr),
                subtitle: Text(
                  'Manage Starred Messages'.tr,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Card(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountOptions()),
                  );
                },
                leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.amber.shade800,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.person)),
                title: Text('Account'.tr),
                subtitle: Text(
                  'Manage Account'.tr,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatBg()),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ChatOptions()),
                  // );
                },
                leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: appColorBlue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.chat)),
                title: Text('Chats'.tr),
                subtitle: Text(
                  'Manage Chats'.tr,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: ListTile(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  if (visibilitySwitch != true) {
                    setState(() {
                      visibilitySwitch = true;
                      userVisibility = 'On';

                      preferences.setString(
                          SharedPreferencesKey.USER_VISIBILITY, 'On');
                      FirebaseAuth.instance.currentUser().then((user) {
                        if (user != null)
                          _database
                              .reference()
                              .child("user")
                              .child(user.uid)
                              .update({
                            "status": "Online",
                          });
                      });
                    });
                  } else {
                    setState(() {
                      visibilitySwitch = false;
                      userVisibility = 'Off';
                      preferences.setString(
                          SharedPreferencesKey.USER_VISIBILITY, 'Off');

                      FirebaseAuth.instance.currentUser().then((user) {
                        if (user != null)
                          _database
                              .reference()
                              .child("user")
                              .child(user.uid)
                              .update({
                            "status": 'Off',
                          });
                      });
                    });
                  }
                  print('USER visi status : $userVisibility');
                },
                leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color:
                            visibilitySwitch ? Colors.green : Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.circle)),
                trailing: CupertinoSwitch(
                  activeColor: visibilitySwitch
                      ? appColor
                      : Colors.grey.withOpacity(0.6),
                  onChanged: (bool value) async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    if (visibilitySwitch != true) {
                      setState(() {
                        visibilitySwitch = true;
                        userVisibility = 'On';

                        preferences.setString(
                            SharedPreferencesKey.USER_VISIBILITY, 'On');
                        FirebaseAuth.instance.currentUser().then((user) {
                          if (user != null)
                            _database
                                .reference()
                                .child("user")
                                .child(user.uid)
                                .update({
                              "status": "Online",
                            });
                        });
                      });
                    } else {
                      setState(() {
                        visibilitySwitch = false;
                        userVisibility = 'Off';
                        preferences.setString(
                            SharedPreferencesKey.USER_VISIBILITY, 'Off');

                        FirebaseAuth.instance.currentUser().then((user) {
                          if (user != null)
                            _database
                                .reference()
                                .child("user")
                                .child(user.uid)
                                .update({
                              "status": 'Off',
                            });
                        });
                      });
                    }
                    print('USER visi status : $userVisibility');
                  },
                  value: visibilitySwitch,
                ),
                title: Text('Visibility'.tr),
                subtitle: Text(
                  'Manage your Visibility status'.tr,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: ListTile(
                onTap: () async {
                  if (themeSwitch != true) {
                    setState(() {
                      themeSwitch = true;
                    });
                    setBrightness(Brightness.dark);
                    DynamicTheme.of(context).setTheme(1);
                  } else {
                    setState(() {
                      themeSwitch = false;
                    });
                    setBrightness(Brightness.light);
                    DynamicTheme.of(context).setTheme(0);
                  }
                },
                leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: themeSwitch ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: themeSwitch
                        ? Icon(Icons.dark_mode)
                        : Icon(Icons.light_mode)),
                trailing: CupertinoSwitch(
                  // activeColor: visibilitySwitch
                  //     ? appColor
                  //     : Colors.grey.withOpacity(0.6),
                  onChanged: (bool value) async {
                    if (themeSwitch != true) {
                      setState(() {
                        themeSwitch = true;
                      });
                      setBrightness(Brightness.dark);
                      DynamicTheme.of(context).setTheme(1);
                    } else {
                      setState(() {
                        themeSwitch = false;
                      });
                      setBrightness(Brightness.light);
                      DynamicTheme.of(context).setTheme(0);
                    }
                  },
                  value: themeSwitch,
                ),
                title: Text('App Theme'.tr),
                subtitle: Text(
                  'Manage your app theme'.tr,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: ListTile(
                onTap: () {
                  buildLanguageDialog(context);
                },
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.translate),
                ),
                title: Text('Languages'),
                subtitle: Text(
                  'Chanage Language',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: ListTile(
                onTap: () async {
                  Share.share(
                      "‎Let's chat on $appName! It's a fast, simple, and secure app we can use to message and call each other for free. Get it at https://play.google.com/store/apps/details?id=com.flutter.whoxaNew");
                },
                leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.chat)),
                title: Text('Tell a Friend'.tr),
                subtitle: Text(
                  'Share our app with your friends'.tr,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            SizedBox(
              height: _height * 0.5 / 10,
            ),
            Card(
              elevation: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: ListTile(
                onTap: () async {
                  Alert(
                    context: context,
                    title: "Log out".tr,
                    desc: "Are you sure you want to log out?".tr,
                    style: AlertStyle(
                        isCloseButton: false,
                        descStyle: Theme.of(context).textTheme.bodyText2,
                        titleStyle: Theme.of(context).textTheme.headline5),
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK".tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "MontserratBold"),
                        ),
                        onPressed: () async {
                          FirebaseAuth.instance.currentUser().then((user) {
                            if (user != null)
                              _database
                                  .reference()
                                  .child("user")
                                  .child(user.uid)
                                  .update({
                                "status": userVisibility == 'Off'
                                    ? 'Off'
                                    : DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                "inChat": ""
                              });
                          });
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences
                              .remove(SharedPreferencesKey.USER_VISIBILITY);

                          preferences
                              .remove(
                            SharedPreferencesKey.LOGGED_IN_USERRDATA,
                          )
                              .then((_) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => Intro(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          });
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      ),
                      DialogButton(
                        child: Text(
                          "Cancel".tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "MontserratBold"),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(116, 116, 191, 1.0),
                          Color.fromRGBO(52, 138, 199, 1.0)
                        ]),
                      ),
                    ],
                  ).show();
                },
                title: Center(
                    child: Text('Sign Out'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.red))),
              ),
            ),
          ],
        ),
      );
}
