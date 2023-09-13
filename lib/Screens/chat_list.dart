// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutterwhatsappclone/Screens/groupChat/groupChat.dart';
import 'package:flutterwhatsappclone/Screens/newchat.dart';
import 'package:flutterwhatsappclone/Screens/videoCall/user_provider.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String currentusername;
  String currentuserimage;
  String currentuserMob;
  String userId;
  final FirebaseDatabase database = new FirebaseDatabase();
  var array = [];
  TextEditingController controller = new TextEditingController();
  bool selectAll = false;
  var selectPeerId = [];

  var groupUsersId = [];
  var groupUsersNames = [];
  var groupUsersImages = [];
  bool callfunction = true;
  UserProvider userProvider;
  //APP BAR SCROLL
  bool _showAppbar = true;
  ScrollController _scrollBottomBarController = new ScrollController();
  bool isScrollingDown = false;
  bool isLoading = true;
  @override
  void initState() {
    getContactsFromGloble().then((value) {
      isLoading = false;
    });
    print(mobileContacts);
    getSavedContactsUserIds();
    getLocalImages();
    check();
    _getToken();
    myScroll();

    // database
    //     .reference()
    //     .child('user')
    //     .orderByChild("status")
    //     .equalTo("Online")
    //     .onValue
    //     .listen((event) {
    //   var snapshot = event.snapshot;
    //   snapshot.value.forEach((key, values) {
    //     array.add(values["userId"]);
    //     // print(array);
    //     //     setState(() {

    //     //   friendListToMessage(userId);
    //     // });
    //   });
    // });

    // array.clear();
    // getOnlineStatus();
    FirebaseAuth.instance.currentUser().then((user) {
      print(user.uid);
      setState(() {
        userID = user.uid;
        userId = user.uid;

        getUser();
      });
    });

    super.initState();
  }

  getSavedContactsUserIds() {
    FirebaseAuth.instance.currentUser().then((user) {
      userID = user.uid;
    }).then((value) {
      database.reference().child('user').once().then((DataSnapshot snapshot) {
        snapshot.value.forEach((key, values) {
          if (mounted)
            setState(() {
              if (mobileContacts.contains(values["mobile"]) &&
                  userID != values["userId"]) {
                savedContactUserId.add(values["userId"]);
              }
            });
        });
      });
    });
  }

  getLocalImages() async {
    localImage.clear();
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    if (preferences1.containsKey("localImage")) {
      setState(() {
        localImage = preferences1.getStringList('localImage');
      });
    }
  }

  var data = '';

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  void showBottomBar() {
    setState(() {});
  }

  void hideBottomBar() {
    setState(() {});
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          showBottomBar();
        }
      }
    });
  }

  _getToken() {
    FirebaseMessaging().getToken().then((token) {
      setState(() {
        print(token);
        // _token = token;
      });
    });
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
      return true;
    } else {
      print("NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
    }
    return false;
  }

  List chatList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Chat'.tr,
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: false,
        elevation: 0,
        // elevation: _showAppbar ? 0 : 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,

        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(0),
            icon: Icon(
              CupertinoIcons.add_circled,
              color: appColorBlue,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewChat()),
              );
            },
          ),
          Container(width: 15),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollBottomBarController,
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10),
                  //   child: CustomText(
                  //     text: "Chats",
                  //     alignment: Alignment.centerLeft,
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.bold,
                  //     fontFamily: "MontserratBold",
                  //     color: appColorBlack,
                  //   ),
                  // ),
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 15, left: 15),
                      child: Container(
                        decoration: new BoxDecoration(
                            // color: Colors.green,
                            borderRadius: new BorderRadius.all(
                          Radius.circular(15.0),
                        )),
                        height: 40,
                        child: Center(
                          child: TextField(
                            controller: controller,
                            onChanged: onSearchTextChanged,
                            style: TextStyle(color: Colors.grey),
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(15.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(15.0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(15.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                              hintText: "Search",
                              contentPadding: EdgeInsets.only(top: 10.0),
                              fillColor: Colors.grey.withOpacity(0.2),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[600],
                                size: 25.0,
                              ),
                            ),
                          ),
                        ),
                      )),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // selectAll == false
                        //     ? InkWell(
                        //         onTap: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => EBroadcast()),
                        //           );
                        //         },
                        //         child: CustomText(
                        //           text: "Brodcast List",
                        //           alignment: Alignment.centerLeft,
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.bold,
                        //           color: appColorBlue,
                        //         ),
                        //       )
                        //     : CustomText(
                        //         text: "Brodcast List",
                        //         alignment: Alignment.centerLeft,
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //         color: appColorGrey,
                        //       ),
                        // selectAll == false
                        //     ? InkWell(
                        //         onTap: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) =>
                        //                     ArchiveChatList()),
                        //           );
                        //         },
                        //         child: CustomText(
                        //           text: "Archived",
                        //           alignment: Alignment.centerLeft,
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.bold,
                        //           color: appColorBlue,
                        //         ),
                        //       )
                        //     : CustomText(
                        //         text: "Archived",
                        //         alignment: Alignment.centerLeft,
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //         color: appColorGrey,
                        //       ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40)),
                        ),
                        child: friendListToMessage(userId)),
                  ),
                ],
              ),
            ),
          ),
          selectAll == true
              ? Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 3, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectAll = false;
                            });

                            for (var i = 0; i <= selectPeerId.length; i++) {
                              Firestore.instance
                                  .collection("chatList")
                                  .document(userId)
                                  .collection(userId)
                                  .document(selectPeerId[i])
                                  .updateData({'archive': true});
                            }
                          },
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 25,
                            height: SizeConfig.blockSizeVertical * 4,
                            child: Center(
                                child: Text(
                              'Archive'.tr,
                              style: TextStyle(
                                  color: appColorBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectAll = false;
                            });

                            for (var i = 0; i <= selectPeerId.length; i++) {
                              Firestore.instance
                                  .collection("chatList")
                                  .document(userId)
                                  .collection(userId)
                                  .document(selectPeerId[i])
                                  .updateData({'badge': '0'});
                            }
                          },
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 25,
                            height: SizeConfig.blockSizeVertical * 4,
                            child: Center(
                                child: Text(
                              'Read All'.tr,
                              style: TextStyle(
                                  color: appColorBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectAll = false;
                            });

                            for (var i = 0; i <= selectPeerId.length; i++) {
                              Firestore.instance
                                  .collection("chatList")
                                  .document(userId)
                                  .collection(userId)
                                  .document(selectPeerId[i])
                                  .delete();
                            }
                          },
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 25,
                            height: SizeConfig.blockSizeVertical * 4,
                            child: Center(
                                child: Text(
                              'Delete'.tr,
                              style: TextStyle(
                                  color: appColorBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget friendListToMessage(String userData) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("chatList")
          .document(userData)
          .collection(userData)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: snapshot.data.documents.length > 0
                ? _searchResult.length != 0 ||
                        controller.text.trim().toLowerCase().isNotEmpty
                    ? ListView.builder(
                        itemCount: _searchResult.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          chatList = snapshot.data.documents;
                          return chatList[index]['archive'] != null &&
                                  chatList[index]['archive'] == false
                              ? buildItem(_searchResult, index)
                              : Container();
                        },
                      )
                    : ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          chatList = snapshot.data.documents;
                          // print(chatList);
                          return chatList[index]['archive'] != null &&
                                  chatList[index]['archive'] == false
                              ? buildItem(chatList, index)
                              : Container();
                        },
                      )
                : Container(
                    height: SizeConfig.blockSizeVertical * 50,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/Sent Message-rafiki.png",
                            width: 300,
                          ),
                          Text("Currently you don't have any messages".tr),
                        ],
                      ),
                    ),
                  ),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height - 250,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CupertinoActivityIndicator(),
              ]),
        );
      },
    );
  }

  Widget buildItem(List chatList, int index) {
    return Column(
      children: <Widget>[
        new Divider(
          height: 10.0,
        ),
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Row(
            children: [
              selectAll == true
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: selectPeerId.contains(chatList[index]['id'])
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  selectPeerId.remove(chatList[index]['id']);
                                });
                              },
                              child: Icon(
                                Icons.check_circle,
                                color: appColorBlue,
                              ))
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  selectPeerId.add(chatList[index]['id']);
                                });
                              },
                              child: Icon(
                                Icons.radio_button_unchecked,
                                color: appColorGrey,
                              )),
                    )
                  : Container(),
              Expanded(
                child: new ListTile(
                  onTap: () {
                    // print("userId:" + userId);
                    // print("currentusername:" + currentusername);
                    // print("currentuserimage:" + currentuserimage);
                    // print("id:" + chatList[index]['id']);
                    // print("profileImage:" + chatList[index]['profileImage']);
                    // print("name:" + chatList[index]['name']);

                    if (chatList[index]['chatType'] != null &&
                        chatList[index]['chatType'] == "group") {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => GroupChat(
                                    currentuser: userId,
                                    currentusername: currentusername,
                                    currentuserimage: currentuserimage,
                                    peerID: chatList[index]['id'],
                                    peerUrl:
                                        chatList[index]['profileImage'].length >
                                                0
                                            ? chatList[index]['profileImage']
                                            : "",
                                    peerName: chatList[index]['name'],
                                    archive: chatList[index]['archive'] != null
                                        ? chatList[index]['archive']
                                        : false,
                                    pin: chatList[index]['pin'] != null &&
                                            chatList[index]['pin'].length > 0
                                        ? '2549518301000'
                                        : '',
                                    mute: chatList[index]['mute'] != null
                                        ? chatList[index]['mute']
                                        : false,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Chat(
                                  peerID: chatList[index]['id'],
                                  archive: chatList[index]['archive'] != null
                                      ? chatList[index]['archive']
                                      : false,
                                  pin: chatList[index]['pin'] != null &&
                                          chatList[index]['pin'].length > 0
                                      ? '2549518301000'
                                      : '',
                                  chatListTime: chatList[index]['timestamp'])));
                    }
                  },
                  onLongPress: () {
                    getIds(chatList[index]['id']);

                    _settingModalBottomSheet(
                        context,
                        userId,
                        chatList[index]['id'],
                        chatList[index]['archive'] != null
                            ? chatList[index]['archive']
                            : false,
                        chatList[index]['timestamp'],
                        chatList[index]['pin'] != null
                            ? chatList[index]['pin']
                            : '',
                        chatList[index]['mute'] != null
                            ? chatList[index]['mute']
                            : false,
                        chatList[index]['badge'],
                        chatList[index]['chatType'] != null &&
                                chatList[index]['chatType'] == "group"
                            ? "group"
                            : "normal");
                  },
                  leading: new Stack(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            // database
                            //     .reference()
                            //     .child('user')
                            //     .child(chatList[index]['id'])
                            //     .once()
                            //     .then((peerData) {
                            //   String name = peerData.value['name'];
                            //   String image = peerData.value['img'];
                            //   String phone = peerData.value['mobile'];

                            //   showDialog(
                            //     context,
                            //     name,
                            //     image,
                            //     phone,
                            //     chatList[index]['id'],
                            //   );
                            // });
                          },
                          child: Stack(
                            children: [
                              imageWidget(
                                  chatList[index]['profileImage'],
                                  chatList[index]['chatType'],
                                  chatList[index]['id']),
                              Positioned.fill(
                                top: 0,
                                left: 0,
                                bottom: 10,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: chatList[index]["status"] == "Online"
                                      ? Icon(Icons.circle,
                                          color: Colors.green, size: 17)
                                      : Container(),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  title: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        chatList[index]['name'],
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: new Container(
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chatList[index]['type'] == 1
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  Text(
                                    "  Photo".tr,
                                    maxLines: 2,
                                    style: new TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              )
                            : chatList[index]['type'] == 4
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.video_call,
                                        color: Colors.grey,
                                        size: 17,
                                      ),
                                      Text(
                                        "  Video".tr,
                                        maxLines: 2,
                                        style: new TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  )
                                : chatList[index]['type'] == 5
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.note,
                                            color: Colors.grey,
                                            size: 17,
                                          ),
                                          Text(
                                            "  File".tr,
                                            maxLines: 2,
                                            style: new TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      )
                                    : chatList[index]['type'] == 6
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.audiotrack,
                                                color: Colors.grey,
                                                size: 17,
                                              ),
                                              Text(
                                                "  Audio".tr,
                                                maxLines: 2,
                                                style: new TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            chatList[index]['content'],
                                            maxLines: 2,
                                            style: new TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: new Text(
                        DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(
                            chatList[index]['timestamp'],
                          )),
                        ),
                        style: new TextStyle(
                            color: int.parse(chatList[index]['badge']) > 0
                                ? appColorBlue
                                : Colors.grey,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    Row(
                      children: [
                        int.parse(chatList[index]['badge']) > 0
                            ? Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: appColorBlue,
                                    ),
                                    alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    child: Text(
                                      chatList[index]['badge'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    width: 05,
                                  )
                                ],
                              )
                            : Container(child: Text("")),
                        chatList[index]['pin'] != null &&
                                chatList[index]['pin'].length > 0
                            ? Icon(Icons.push_pin, color: Colors.grey, size: 16)
                            : Container(),
                        chatList[index]['mute'] == true
                            ? Icon(Icons.volume_off,
                                color: Colors.grey, size: 17)
                            : Container()
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          secondaryActions: <Widget>[
            // IconSlideAction(
            //   caption: 'Mute',
            //   color: Colors.blue,
            //   foregroundColor: Colors.white,
            //   icon: Icons.volume_off,
            //   onTap: () {
            //     Firestore.instance
            //         .collection("chatList")
            //         .document(userId)
            //         .collection(userId)
            //         .document(
            //           chatList[index]['id'],
            //         )
            //         .updateData({'mute': false});
            //   },
            // ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              onTap: () {
                Firestore.instance
                    .collection("chatList")
                    .document(userId)
                    .collection(userId)
                    .document(
                      chatList[index]['id'],
                    )
                    .delete();
              },
            ),
            IconSlideAction(
              caption: 'More',
              color: Colors.grey[400],
              foregroundColor: Colors.white,
              icon: Icons.more_horiz,
              onTap: () {
                _settingModalBottomSheet(
                    context,
                    userId,
                    chatList[index]['id'],
                    chatList[index]['archive'] != null
                        ? chatList[index]['archive']
                        : false,
                    chatList[index]['timestamp'],
                    chatList[index]['pin'] != null
                        ? chatList[index]['pin']
                        : '',
                    chatList[index]['mute'] != null
                        ? chatList[index]['mute']
                        : false,
                    chatList[index]['badge'],
                    chatList[index]['chatType'] != null &&
                            chatList[index]['chatType'] == "group"
                        ? "group"
                        : "normal");
              },
            ),
            // IconSlideAction(
            //   caption: 'Archive',
            //   foregroundColor: Colors.black,
            //   color: Colors.green,
            //   icon: Icons.archive,
            //   //  onTap: () => _showSnackBar('Delete'),
            // ),
          ],
        )
      ],
    );
  }

  Widget imageWidget(image, chattype, id) {
    if (callfunction == true) {
      if (chattype == null) {
        database.reference().child('user').child(id).once().then((peerData) {
          setState(() {
            data = peerData.value['profileseen'];
          });
        });
      } else {
        data = '';
      }
    } else {
      setState(() {
        callfunction = false;
      });
    }

    return image != null && image.length > 0 && data != "nobody"
        ? Container(
            height: 50,
            width: 50,
            child: CircleAvatar(
              //radius: 60,
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(image),
            ),
          )
        : Container(
            height: 50,
            width: 50,
            decoration:
                BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: chattype != null
                  ? Image.asset(
                      "assets/images/groupuser.png",
                      height: 10,
                      color: Colors.white,
                    )
                  : Image.asset(
                      "assets/images/user.png",
                      height: 10,
                      color: Colors.white,
                    ),
            ));
  }

  void _settingModalBottomSheet(
      context, userId, peerId, arch, timestamp, pin, mute, badge, chatType) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                selectAll == false
                    ? ListTile(
                        title: Center(child: new Text('Select'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectAll = true;
                          });
                        })
                    : ListTile(
                        title: Center(child: new Text('Unselect'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectAll = false;
                          });
                        }),
                timestamp == '2549518301000'
                    ? ListTile(
                        title: Center(child: new Text('Unpin'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .updateData({'pin': '', 'timestamp': pin});
                        })
                    : ListTile(
                        title: Center(child: new Text('Pin'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .updateData({
                            'pin': timestamp,
                            'timestamp': '2549518301000'
                          });
                        }),
                badge == "0"
                    ? ListTile(
                        title: Center(child: new Text('Mark as Unread'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .updateData({'badge': '1'});
                        })
                    : ListTile(
                        title: Center(child: new Text('Mark as read'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .updateData({'badge': '0'});
                        },
                      ),
                mute == true
                    ? ListTile(
                        title: Center(child: new Text('Unmute'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .updateData({'mute': false});
                        },
                      )
                    : ListTile(
                        title: Center(child: new Text('Mute'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .updateData({'mute': true});
                        },
                      ),
                arch == true
                    ? ListTile(
                        title: Center(child: new Text('Unarchive'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .updateData({'archive': false});
                        },
                      )
                    : ListTile(
                        title: Center(child: new Text('Archive'.tr)),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .updateData({'archive': true});
                        },
                      ),
                // new ListTile(
                //   title: Center(child: new Text('View Contact')),
                //   onTap: () {
                //     Navigator.pop(context);

                //     if (chatType == "group") {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => GroupInfo(
                //                 names: groupUsersNames,
                //                 images: groupUsersImages,
                //                 ids: groupUsersId)),
                //       );
                //     } else {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ContactInfo(id: peerId)),
                //       );
                //     }
                //   },
                // ),
                chatType == "group"
                    ? ListTile(
                        title: Center(
                          child: new Text(
                            'Exit Group'.tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          final FirebaseDatabase database =
                              new FirebaseDatabase();

                          database
                              .reference()
                              .child('group')
                              .child(peerId)
                              .once()
                              .then((peerData) {
                            var ids = [];
                            ids.addAll(peerData.value['userId']);
                            ids.remove(userId);
                            DatabaseReference _userRef =
                                database.reference().child('group');

                            _userRef.child(peerId).update({
                              "userId": ids,
                            }).then((_) {
                              Firestore.instance
                                  .collection("chatList")
                                  .document(userId)
                                  .collection(userId)
                                  .document(peerId)
                                  .delete();
                            });
                          });
                        },
                      )
                    : ListTile(
                        title: Center(
                          child: new Text(
                            'Delete'.tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Firestore.instance
                              .collection("chatList")
                              .document(userId)
                              .collection(userId)
                              .document(peerId)
                              .delete();
                        },
                      ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: new RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 2.0,
                      fillColor: Colors.grey[300],
                      child: Icon(
                        Icons.close,
                        size: 20.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // void showDialog(BuildContext context, name, image, phone, id) {
  //   showGeneralDialog(
  //     barrierDismissible: true,
  //     barrierLabel: "Barrier",
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: Duration(milliseconds: 700),
  //     context: context,
  //     pageBuilder: (_, __, ___) {
  //       return Align(
  //         alignment: Alignment.center,
  //         child: Container(
  //           height: SizeConfig.safeBlockVertical * 100,
  //           width: SizeConfig.screenWidth,
  //           child: Column(
  //             children: <Widget>[
  //               Container(
  //                   decoration: new BoxDecoration(
  //                       color: Colors.grey[300],
  //                       borderRadius: new BorderRadius.only(
  //                         topLeft: const Radius.circular(30.0),
  //                         topRight: const Radius.circular(30.0),
  //                       )),
  //                   height: SizeConfig.safeBlockVertical * 30,
  //                   width: SizeConfig.screenWidth,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.only(
  //                         topRight: Radius.circular(30.0),
  //                         topLeft: Radius.circular(30.0)),
  //                     child: image.length > 0
  //                         ? Image.network(
  //                             image,
  //                             fit: BoxFit.cover,
  //                           )
  //                         : Icon(
  //                             Icons.person,
  //                             color: Colors.black,
  //                             size: 50,
  //                           ),
  //                   )),
  //               Material(
  //                 borderRadius: BorderRadius.only(
  //                     bottomRight: Radius.circular(30.0),
  //                     bottomLeft: Radius.circular(30.0)),
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(
  //                         bottomRight: Radius.circular(30.0),
  //                         bottomLeft: Radius.circular(30.0)),
  //                   ),
  //                   height: SizeConfig.blockSizeVertical * 12,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 20, top: 8),
  //                         child: Text(
  //                           name,
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: SizeConfig.blockSizeVertical * 2.5,
  //                               fontFamily: 'Montserrat'),
  //                         ),
  //                       ),
  //                       Row(
  //                         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Expanded(
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(
  //                                 left: 20,
  //                               ),
  //                               child: Text(
  //                                 phone,
  //                                 style: TextStyle(
  //                                     fontSize:
  //                                         SizeConfig.blockSizeVertical * 2,
  //                                     color: Colors.grey,
  //                                     fontFamily: 'Montserrat'),
  //                               ),
  //                             ),
  //                           ),
  //                           RawMaterialButton(
  //                             onPressed: () {
  //                               Navigator.of(context, rootNavigator: true)
  //                                   .pop();

  //                               Navigator.push(
  //                                   context,
  //                                   CupertinoPageRoute(
  //                                       builder: (context) => Chat(
  //                                           currentuser: userId,
  //                                           currentusername: currentusername,
  //                                           currentuserimage: currentuserimage,
  //                                           peerID: id,
  //                                           peerUrl: image,
  //                                           peerName: name)));
  //                             },
  //                             elevation: 1,
  //                             fillColor: Colors.white,
  //                             child: Image.asset(
  //                               "assets/images/chat.png",
  //                               height: 27,
  //                               color: appColorBlue,
  //                             ),
  //                             shape: CircleBorder(),
  //                           ),
  //                           RawMaterialButton(
  //                             onPressed: () {
  //                               Navigator.of(context, rootNavigator: true)
  //                                   .pop();
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         ContactInfo(id: id)),
  //                               );
  //                             },
  //                             elevation: 1,
  //                             fillColor: Colors.white,
  //                             child: Icon(
  //                               Icons.info,
  //                               size: 25.0,
  //                               color: appColorBlue,
  //                             ),
  //                             shape: CircleBorder(),
  //                           )
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //           margin: EdgeInsets.only(bottom: 45, left: 18, right: 18, top: 200),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (_, anim, __, child) {
  //       return SlideTransition(
  //         position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  Widget friendName(AsyncSnapshot friendListSnapshot, int index) {
    return Container(
      width: 200,
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text:
                "${friendListSnapshot.data["firstname"]} ${friendListSnapshot.data["lastname"]}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          )
        ]),
      ),
    );
  }

  Widget messageButton(AsyncSnapshot friendListSnapshot, int index) {
    // ignore: deprecated_member_use
    return RaisedButton(
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Text(
        "Message".tr,
        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
      ),
      onPressed: () {},
    );
  }

  getOnlineStatus() {
    database
        .reference()
        .child('user')
        .orderByChild("status")
        .equalTo("Online")
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      snapshot.value.forEach((key, values) {
        setState(() {
          array.add(values["userId"]);
          friendListToMessage(userId);
        });
      });
    });
  }

  getUser() async {
    database.reference().child('user').child(userId).once().then((peerData) {
      setState(() {
        userID = userId;
        globalName = peerData.value['name'];
        globalImage = peerData.value['img'];
        currentusername = peerData.value['name'];
        currentuserimage = peerData.value['img'];
        currentuserMob =
            peerData.value['countryCode'] + peerData.value['mobile'];
        fullMob = currentuserMob;
        mobNo = peerData.value['mobile'];
        print("Mob: " + fullMob);
      });
    });

    setState(() {
      friendListToMessage(userId);
    });
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    chatList.forEach((userDetail) {
      // for (int i = 0; i < chatList.length; i++) {
      if (userDetail['name'].toLowerCase().contains(text.toLowerCase())
          // ||chatList[i]['name'].toLowerCase().contains(text.toLowerCase())
          ) _searchResult.add(userDetail);
      // }
    });

    setState(() {});
  }

  getIds(id) async {
    final FirebaseDatabase database = new FirebaseDatabase();

    database
        .reference()
        .child('group')
        .child(id)
        .orderByChild("userId")
        .once()
        .then((peerData) {
      groupUsersId = peerData.value['userId'];
      groupUsersNames = peerData.value['name'];
      groupUsersImages = peerData.value['img'];
      print("groupUsersId>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    });
  }

  String peerChatIn = '';

  // Widget peerOnline(id) {
  //   return StreamBuilder(
  //     stream:
  //         FirebaseDatabase.instance.reference().child('user').child(id).onValue,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         //  chatInCall();
  //         peerChatIn = snapshot.data.snapshot.value['inChat'];
  //         return snapshot.data.snapshot.value["status"].length > 0 &&
  //                 snapshot.data.snapshot.value["profileseen"] != "nobody"
  //             ? snapshot.data.snapshot.value["status"] == "typing" &&
  //                     snapshot.data.snapshot.value["inChat"] == userID
  //                 ? Container()
  //                 : snapshot.data.snapshot.value["status"] == "typing" ||
  //                         snapshot.data.snapshot.value["status"] == "Online"
  //                     ? Icon(Icons.circle, color: Colors.green, size: 17)
  //                     : CustomText(
  //                         text: "Last Seen at " +
  //                             readTimestamp(int.parse(
  //                               snapshot.data.snapshot.value["status"],
  //                             )),
  //                         alignment: Alignment.centerLeft,
  //                         fontSize: 10,
  //                         color: appColorGrey,
  //                       )
  //             : Text(
  //                 '',
  //                 style: TextStyle(color: Colors.green),
  //               );
  //       }
  //       return Container();
  //     },
  //   );
  // }
}

List _searchResult = [];
