import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/Screens/bottombar/newTabber.dart';
import 'package:flutterwhatsappclone/Screens/intro.dart';
import 'package:flutterwhatsappclone/Screens/videoCall/user_provider.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';

import 'package:flutterwhatsappclone/provider/countries.dart';
import 'package:flutterwhatsappclone/provider/phone_auth.dart';
import 'package:flutterwhatsappclone/share_preference/preferencesKey.dart';
import 'package:flutterwhatsappclone/translation/localeString.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.cancel(0);
// }
class AppThemes {
  static const int Light = 0;
  static const int Dark = 1;

  static String toStr(int themeId) {
    switch (themeId) {
      case Light:
        return "Light";
      case Dark:
        return "Dark";

      default:
        return "Unknown";
    }
  }
}

class App extends StatefulWidget {
  final SharedPreferences prefs;

  App(this.prefs);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TextEditingController passController = TextEditingController();
  final passNode = FocusNode();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userVisibility =
        widget.prefs.getString(SharedPreferencesKey.USER_VISIBILITY);
    print('USER visibility : $userVisibility');
    WidgetsBinding.instance.addObserver(this);
    // checkUser();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _firebaseMessaging.configure(
        //onBackgroundMessage: _backgroundMessageHandler,
        );
  }

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (userVisibility != 'Off') {
        FirebaseAuth.instance.currentUser().then((user) {
          if (user != null) {
            print('user : ${user.uid}');
            _database.reference().child("user").child(user.uid).update({
              "status": "Online",
            });
          }
        });

        FirebaseAuth.instance.currentUser().then((user) {
          print('user uid : ${user.uid}');
          print('user mail : ${user.email}');

          Firestore.instance
              .collection('users')
              .document(user.uid)
              .updateData({"status": 'Online'});
        });
      }
    } else {
      if (userID != '') {
        FirebaseAuth.instance.currentUser().then((user) {
          if (user != null)
            // setState(() {
            //   passCodeStatus = true;
            // });
            _database.reference().child("user").child(user.uid).update({
              "status": userVisibility == 'On'
                  ? DateTime.now().millisecondsSinceEpoch.toString()
                  : 'Off',
              "inChat": "",
              // "passCodeStatus": true,
            });

          // _database.reference().child("user").child(user.uid).update({
          //   "status": DateTime.now().millisecondsSinceEpoch.toString(),

          // });
        });
      }

      FirebaseAuth.instance.currentUser().then((user) {
        Firestore.instance.collection('users').document(user.uid).updateData(
            {"status": DateTime.now().millisecondsSinceEpoch.toString()});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final themeCollection = ThemeCollection(themes: {
      AppThemes.Light: ThemeData(
        //fontFamily: 'Poppins',
        primaryColor: appColorBlue,

        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,

        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 25, fontFamily: 'Poppins-Medium'),
          bodyText1: TextStyle(
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
      ),
      AppThemes.Dark: ThemeData(
        // fontFamily: 'Poppins',
        primaryColor: appColorBlue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 25, fontFamily: 'Poppins-Medium'),
        ),
      ),
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (context) => CountryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhoneAuthDataProvider(),
        ),
      ],
      child: DynamicTheme(
          themeCollection: themeCollection,
          defaultThemeId: AppThemes.Light,
          builder: (context, theme) {
            return GetMaterialApp(
              theme: theme,
              translations: LocaleString(),
              locale: Locale('en', 'US'),
              debugShowCheckedModeBanner: false,
              home: _handleCurrentScreen(widget.prefs),
              // home: PhoneAuthGetPhone(),
            );
          }),
    );
  }

  Widget _handleCurrentScreen(SharedPreferences prefs) {
    String data = prefs.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);

    if (data == null) {
      return Intro();
    } else {
      return TabbarScreen();
    }
  }

// checkUser() async {
//   FirebaseAuth.instance.currentUser().then((user) {
//     if (user != null)
//       _database
//           .reference()
//           .child('user')
//           .child(user.uid)
//           .once()
//           .then((peerData) {
//         setState(() {
//           passCodeStatus = peerData.value['passCodeStatus'];
//         });
//       });
//   });
//   setState(() {
//     isLoading = false;
//   });
// }
}
