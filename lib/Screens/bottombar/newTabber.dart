// ignore_for_file: unused_element, unused_field

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwhatsappclone/Screens/callScreen.dart';
import 'package:flutterwhatsappclone/Screens/chat.dart';
import 'package:flutterwhatsappclone/Screens/chat_list.dart';
import 'package:flutterwhatsappclone/Screens/intro.dart';

// import 'package:flutterwhatsappclone/Screens/test.dart';
import 'package:flutterwhatsappclone/Screens/videoCall/pickup_layout.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';

import 'package:flutterwhatsappclone/setting_options.dart';
import 'package:flutterwhatsappclone/share_preference/preferencesKey.dart';
import 'package:flutterwhatsappclone/story/status.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutterwhatsappclone/Screens/videoCall/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancel(0);
}

class TabbarScreen extends StatefulWidget {
  final String userID;
  TabbarScreen({this.userID});
  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController passController = TextEditingController();
  final passNode = FocusNode();
  int _currentIndex = 0;
  UserProvider userProvider;
  final FirebaseDatabase database = new FirebaseDatabase();

  List<dynamic> _handlePages = [
    ChatList(),
    Status(),
    CallHistory(),
    // SettingOptions()
    SettingsOptions()
    //ReadContacts()
  ];
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool showApp = false;
  bool isLoading = true;
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
    if (userVisibility == 'On') {
      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null)
          _database.reference().child("user").child(user.uid).update({
            "status": "Online",
          });
      });
    }
    checkUser();
    permissionAcessPhone();
    notificationInitinalize();

    super.initState();
  }

  notificationInitinalize() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(
    //         android: initializationSettingsAndroid,
    //         iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   userProvider = Provider.of<UserProvider>(context, listen: false);
    //   userProvider.refreshUser();
    // });
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {});

    _firebaseMessaging.configure(
//      onBackgroundMessage: _backgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) {
        print('onMessage');
        print(message);
        Fluttertoast.showToast(
            msg: message['notification']['title'] +
                ":" +
                message['notification']['body']);
        print(message);
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch');
        print(message);
        Fluttertoast.showToast(
            msg: message['notification']['title'] +
                ":" +
                message['notification']['body']);

        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume');
        print(message);

        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => Chat(
                      peerID: message['data']['user_id'],
                      archive: false,
                      pin: '',
                    )));

        return;
      },
    );
  }

  permissionAcessPhone() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.contacts,
      Permission.microphone,
      Permission.mediaLibrary,
    ].request();
    print(statuses[Permission.location]);
    if (await Permission.contacts.request().isGranted) {
      getContactsFromGloble().then((value) {
        getSavedContactsUserIds();
      });
    }
  }

  getSavedContactsUserIds() {
    FirebaseAuth.instance.currentUser().then((user) {
      print(user.uid);
      setState(() {
        userID = user.uid;
      });
    }).then((value) {
      database.reference().child('user').once().then((DataSnapshot snapshot) {
        snapshot.value.forEach((key, values) {
          if (mobileContacts.contains(values["mobile"]) &&
              userID != values["userId"]) {
            setState(() {
              savedContactUserId.add(values["userId"]);
              print(savedContactUserId);
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return showApp == true
        ? PickupLayout(
            scaffold: WillPopScope(
              onWillPop: () async {
                if (_currentIndex == 0) {
                  SystemNavigator.pop();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TabbarScreen()),
                  );
                }

                return false;
              },
              child: Scaffold(
                body: _handlePages[_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  unselectedFontSize: 12.5,
                  selectedFontSize: 12.5,
                  selectedItemColor: appColorBlue,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: <BottomNavigationBarItem>[
                    _currentIndex == 0
                        ? BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                "assets/images/chat.png",
                                height: 25,
                                color: appColorBlue,
                              ),
                            ),
                            label: "Chat".tr,
                          )
                        : BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                "assets/images/chat.png",
                                height: 25,
                                color: appColorGrey,
                              ),
                            ),
                            label: "Chat".tr,
                          ),
                    _currentIndex == 1
                        ? BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                "assets/images/gallery.png",
                                height: 22,
                                color: appColorBlue,
                              ),
                            ),
                            label: "Story".tr,
                          )
                        : BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                "assets/images/gallery.png",
                                height: 22,
                                color: appColorGrey,
                              ),
                            ),
                            label: "Story".tr,
                          ),
                    _currentIndex == 2
                        ? BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                "assets/images/call.png",
                                height: 22,
                                color: appColorBlue,
                              ),
                            ),
                            label: "Calls".tr,
                          )
                        : BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                "assets/images/call.png",
                                height: 22,
                                color: appColorGrey,
                              ),
                            ),
                            label: "Calls".tr,
                          ),
                    _currentIndex == 3
                        ? BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                "assets/images/gear.png",
                                height: 24,
                                color: appColorBlue,
                              ),
                            ),
                            label: "Settings".tr,
                          )
                        : BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset(
                                "assets/images/gear.png",
                                height: 24,
                                color: appColorGrey,
                              ),
                            ),
                            label: "Settings".tr,
                          ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: Container(
              width: double.infinity,
              color: Colors.white,
              child: isLoading == true
                  ? Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent),
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue)),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Oops! Something went wrong, please login again."
                                .tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences
                                      .remove(SharedPreferencesKey
                                          .LOGGED_IN_USERRDATA)
                                      .then((_) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => Intro(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: appColorBlue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.login,
                                      size: 18,
                                      color: appColorWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
          hintText: 'Enter Your password'.tr,
          prefixIcon: Icon(
            Icons.lock,
            size: 30.0,
            color: appColorBlue,
          ),
        ));
  }

  checkUser() async {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null)
        database
            .reference()
            .child('user')
            .child(user.uid)
            .once()
            .then((peerData) {
          setState(() {
            passCodeStatus = peerData.value['passCodeStatus'];

            if (peerData.value['name'] != null) {
              isLoading = false;
              showApp = true;
            } else {
              isLoading = false;
            }
          });
        });
    });
  }
}
