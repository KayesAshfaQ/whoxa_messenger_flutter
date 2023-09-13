import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/Screens/contactinfo.dart';

import 'package:flutterwhatsappclone/Screens/videoCall/call_utilities.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';
import 'package:flutterwhatsappclone/models/callModal.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutterwhatsappclone/Screens/videoCall/user.dart' as videoCall;

class CallHistory extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<CallHistory> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<CallModal> userlist;
  Query query;
  String userId;
  StreamSubscription<Event> _onOrderAddedSubscription;
  StreamSubscription<Event> _onOrderChangedSubscription;
  FirebaseDatabase database = new FirebaseDatabase();
  videoCall.User sender = videoCall.User();
  videoCall.User receiver = videoCall.User();
  bool editButton = false;
  TextEditingController controller = new TextEditingController();
  @override
  void initState() {
    super.initState();

    sender.uid = userID;
    sender.name = globalName;
    sender.profilePhoto = globalImage;

    FirebaseAuth.instance.currentUser().then((user) {
      print(user.uid);
      setState(() {
        userId = user.uid;
      });
      // ignore: deprecated_member_use
      userlist = new List();
      query = database
          .reference()
          .child("call_history")
          .orderByChild("mainId")
          .equalTo(userId);
      _onOrderAddedSubscription = query.onChildAdded.listen(onEntryAdded1);
      _onOrderChangedSubscription =
          query.onChildChanged.listen(onEntryChanged1);
    });
  }

  @override
  void dispose() {
    _onOrderAddedSubscription.cancel();
    _onOrderChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged1(Event event) {
    var oldEntry = userlist.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      userlist[userlist.indexOf(oldEntry)] =
          CallModal.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded1(Event event) {
    setState(() {
      userlist.add(CallModal.fromSnapshot(event.snapshot));
      userlist.sort((a, b) => b.time.compareTo(a.time));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title:
                Text('Calls'.tr, style: Theme.of(context).textTheme.headline6),
            centerTitle: false,
            elevation: 0,
            // elevation: _showAppbar ? 0 : 1,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: SizeConfig.blockSizeHorizontal * 46.4,
                        height: SizeConfig.blockSizeVertical * 5,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Color(0xFFA4AAB2)),
                        child: Center(
                          child: TabBar(
                            labelColor: Colors.black,

                            // indicatorSize: TabBarIndicatorSize.label,
                            // isScrollable: false,
                            labelStyle: TextStyle(
                                fontSize: 15.0, fontFamily: 'Montserrat'),
                            // indicator: UnderlineTabIndicator(
                            //   borderSide: BorderSide(
                            //       color: Colors.black, width: 3.0),
                            //   // insets:
                            //   //     EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                            // ),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.grey[300]),

                            tabs: <Widget>[
                              Tab(
                                text: 'All'.tr,
                              ),
                              Tab(
                                text: 'Missed'.tr,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: SizeConfig.blockSizeVertical * 18,
                  //   width: SizeConfig.screenWidth,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[200],
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(20),
                  //         bottomLeft: Radius.circular(20)),
                  //   ),
                  //   child: Stack(
                  //     children: <Widget>[
                  //       Padding(
                  //         padding: const EdgeInsets.all(0.0),
                  //         child: Align(
                  //           alignment: Alignment.center,
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(top: 25),
                  //             child: Container(
                  //               width: SizeConfig.blockSizeHorizontal * 46.4,
                  //               height: SizeConfig.blockSizeVertical * 5,
                  //               decoration: new BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(40),
                  //                   color: Color(0xFFA4AAB2)),
                  //               child: Center(
                  //                 child: TabBar(
                  //                   labelColor: Colors.black,

                  //                   // indicatorSize: TabBarIndicatorSize.label,
                  //                   // isScrollable: false,
                  //                   labelStyle: TextStyle(
                  //                       fontSize: 15.0,
                  //                       fontFamily: 'Montserrat'),
                  //                   // indicator: UnderlineTabIndicator(
                  //                   //   borderSide: BorderSide(
                  //                   //       color: Colors.black, width: 3.0),
                  //                   //   // insets:
                  //                   //   //     EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                  //                   // ),
                  //                   indicator: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(40),
                  //                       color: Colors.grey[300]),

                  //                   tabs: <Widget>[
                  //                     Tab(
                  //                       text: 'All',
                  //                     ),
                  //                     Tab(
                  //                       text: 'Missed',
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       editButton == true
                  //           ? Align(
                  //               alignment: Alignment.topLeft,
                  //               child: InkWell(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     editButton = false;
                  //                   });
                  //                 },
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(
                  //                       top: 50, left: 20),
                  //                   child: Text(
                  //                     "Done",
                  //                     style: TextStyle(
                  //                         color: Colors.green,
                  //                         fontSize:
                  //                             SizeConfig.blockSizeHorizontal *
                  //                                 4,
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                 ),
                  //               ),
                  //             )
                  //           : Align(
                  //               alignment: Alignment.topLeft,
                  //               child: InkWell(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     editButton = true;
                  //                   });
                  //                 },
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(
                  //                       top: 50, left: 20),
                  //                   child: Text(
                  //                     "Edit",
                  //                     style: TextStyle(
                  //                         color: Colors.green,
                  //                         fontSize:
                  //                             SizeConfig.blockSizeHorizontal *
                  //                                 4,
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //       editButton == true
                  //           ? Align(
                  //               alignment: Alignment.topRight,
                  //               child: Padding(
                  //                   padding: const EdgeInsets.only(
                  //                       top: 50, right: 20),
                  //                   child: InkWell(
                  //                     onTap: () {
                  //                       clearAllMenu(context);
                  //                     },
                  //                     child: Text(
                  //                       "Clear",
                  //                       style: TextStyle(
                  //                           color: appColorGreen,
                  //                           fontWeight: FontWeight.bold,
                  //                           fontSize: 16),
                  //                     ),
                  //                   )),
                  //             )
                  //           : Align(
                  //               alignment: Alignment.topRight,
                  //               child: Padding(
                  //                   padding: const EdgeInsets.only(
                  //                       top: 30, right: 20),
                  //                   child: IconButton(
                  //                     onPressed: () {
                  //                       Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(
                  //                             builder: (context) => NewCall()),
                  //                       );
                  //                     },
                  //                     icon: Icon(
                  //                       Icons.add_call,
                  //                       color: Colors.green,
                  //                     ),
                  //                   )),
                  //             ),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //     padding:
                  //         const EdgeInsets.only(top: 10, right: 20, left: 20),
                  //     child: Container(
                  //       decoration: new BoxDecoration(
                  //           color: Colors.green,
                  //           borderRadius: new BorderRadius.all(
                  //             Radius.circular(40.0),
                  //           )),
                  //       height: 40,
                  //       child: Center(
                  //         child: TextField(
                  //           controller: controller,
                  //           onChanged: onSearchTextChanged,
                  //           style: TextStyle(color: Colors.grey),
                  //           decoration: new InputDecoration(
                  //             border: new OutlineInputBorder(
                  //               borderSide:
                  //                   new BorderSide(color: Colors.grey[300]),
                  //               borderRadius: const BorderRadius.all(
                  //                 const Radius.circular(40.0),
                  //               ),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide:
                  //                   new BorderSide(color: Colors.grey[300]),
                  //               borderRadius: const BorderRadius.all(
                  //                 const Radius.circular(40.0),
                  //               ),
                  //             ),
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide:
                  //                   new BorderSide(color: Colors.grey[300]),
                  //               borderRadius: const BorderRadius.all(
                  //                 const Radius.circular(40.0),
                  //               ),
                  //             ),
                  //             filled: true,
                  //             hintStyle: new TextStyle(color: Colors.grey),
                  //             hintText: "Search",
                  //             contentPadding: EdgeInsets.only(top: 10.0),
                  //             fillColor: Colors.grey[200],
                  //             prefixIcon: Icon(
                  //               Icons.search,
                  //               color: Colors.green,
                  //               size: 30.0,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     )),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[allCalls(), missedCalls()],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget allCalls() {
    return userlist != null && userlist.length > 0
        ? _searchResult.length != 0 ||
                controller.text.trim().toLowerCase().isNotEmpty
            ? ListView.builder(
                itemCount: _searchResult.length,
                itemBuilder: (context, int index) {
                  return callWidget(_searchResult, index);
                },
              )
            : ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: userlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return userlist[index].name == null
                      ? Container()
                      : callWidget(userlist, index);
                },
              )
        : Container();
  }

  Widget callWidget(userlist, index) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child('user')
          .child(userlist[index].recId != userID
              ? userlist[index].recId
              : userlist[index].callerId)
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Row(
                children: [
                  // editButton == true
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(left: 10),
                  //         child: Container(
                  //           height: 25,
                  //           width: 25,
                  //           decoration: BoxDecoration(
                  //               color: Colors.red, shape: BoxShape.circle),
                  //           child: IconButton(
                  //               padding: const EdgeInsets.all(0),
                  //               icon: Icon(
                  //                 Icons.remove,
                  //                 color: appColorWhite,
                  //               ),
                  //               onPressed: () {
                  //                 deleteOrder(userlist[index].key, index);
                  //               }),
                  //         ),
                  //       )
                  //     : Container(),
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        if (editButton == false)
                          database
                              .reference()
                              .child('user')
                              .child(userlist[index].recId != userID
                                  ? userlist[index].recId
                                  : userlist[index].callerId)
                              .once()
                              .then((peerData) {
                            receiver.uid = peerData.value['userId'];
                            receiver.name = peerData.value['name'];
                            receiver.profilePhoto = peerData.value['img'];
                            sendCallNotification(peerData.value['token'],
                                "Wootsapp ${userlist[index].callType} Calling....");
                            CallUtils.dial(
                                from: sender,
                                to: receiver,
                                context: context,
                                status: "${userlist[index].callType}call");
                          });
                      },
                      leading: Container(
                          height: 45,
                          width: 45,
                          child: snapshot.data.snapshot.value["img"].length > 0
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: new NetworkImage(
                                      snapshot.data.snapshot.value["img"]),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(Icons.person))),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            snapshot.data.snapshot.value["name"],
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: new Container(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            userlist[index].callType == "voice"
                                ? Image.asset(
                                    "assets/images/call_blue.png",
                                    color:
                                        userlist[index].callStatus == "Missed"
                                            ? Colors.red
                                            : userlist[index].callStatus ==
                                                    "Incoming"
                                                ? Colors.green
                                                : userlist[index].callStatus ==
                                                        "Outgoing"
                                                    ? appColorBlue
                                                    : Colors.grey,
                                    height: 17,
                                  )
                                : Image.asset(
                                    "assets/images/Video_Call.png",
                                    color:
                                        userlist[index].callStatus == "Missed"
                                            ? Colors.red
                                            : userlist[index].callStatus ==
                                                    "Incoming"
                                                ? Colors.green
                                                : userlist[index].callStatus ==
                                                        "Outgoing"
                                                    ? appColorBlue
                                                    : Colors.grey,
                                    height: 12,
                                  ),
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 1,
                            ),
                            new Text(
                              userlist[index].callStatus,
                              style: new TextStyle(
                                  color: userlist[index].callStatus == "Missed"
                                      ? Colors.red
                                      : userlist[index].callStatus == "Incoming"
                                          ? Colors.green
                                          : userlist[index].callStatus ==
                                                  "Outgoing"
                                              ? appColorBlue
                                              : Colors.grey,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 3.2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Text(
                        DateTime.now()
                                    .difference(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(userlist[index].time)))
                                    .inDays ==
                                0
                            ? DateFormat('hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(int.parse(
                                  userlist[index].time,
                                )),
                              )
                            : DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                    userlist[index].time,
                                  )),
                                ) +
                                " " +
                                DateFormat('dd/MM/yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                    userlist[index].time,
                                  )),
                                ),
                        style:
                            new TextStyle(color: Colors.grey, fontSize: 14.0),
                      ),
                    ],
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: appColorGreen,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactInfo(
                                  id: userlist[index].recId != userID
                                      ? userlist[index].recId
                                      : userlist[index].callerId,
                                  imageMedia: [],
                                  videoMedia: [],
                                  docsMedia: [],
                                  imageMediaTime: [],
                                  blocksId: [])),
                        );
                      }),
                ],
              ),
              Divider(
                thickness: 1,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget missedCalls() {
    return userlist != null && userlist.length > 0
        ? ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: userlist.length,
            itemBuilder: (BuildContext context, int index) {
              return userlist[index].name == null
                  ? Container()
                  : userlist[index].callStatus != "Missed"
                      ? Container()
                      : Column(
                          children: <Widget>[
                            Row(
                              children: [
                                // editButton == true
                                //     ? Padding(
                                //         padding:
                                //             const EdgeInsets.only(left: 10),
                                //         child: Container(
                                //           height: 25,
                                //           width: 25,
                                //           decoration: BoxDecoration(
                                //               color: Colors.red,
                                //               shape: BoxShape.circle),
                                //           child: IconButton(
                                //               padding: const EdgeInsets.all(0),
                                //               icon: Icon(
                                //                 Icons.remove,
                                //                 color: appColorWhite,
                                //               ),
                                //               onPressed: () {
                                //                 deleteOrder(
                                //                     userlist[index].key, index);
                                //               }),
                                //         ),
                                //       )
                                //     : Container(),
                                Expanded(
                                  child: ListTile(
                                    onTap: () {
                                      if (editButton == false)
                                        database
                                            .reference()
                                            .child('user')
                                            .child(
                                                userlist[index].recId != userID
                                                    ? userlist[index].recId
                                                    : userlist[index].callerId)
                                            .once()
                                            .then((peerData) {
                                          receiver.uid =
                                              peerData.value['userId'];
                                          receiver.name =
                                              peerData.value['name'];
                                          receiver.profilePhoto =
                                              peerData.value['img'];
                                          sendCallNotification(
                                              peerData.value['token'],
                                              "Wootsapp ${userlist[index].callType} Calling....");
                                          CallUtils.dial(
                                              from: sender,
                                              to: receiver,
                                              context: context,
                                              status:
                                                  "${userlist[index].callType}call");
                                        });
                                    },
                                    leading: Container(
                                      height: 45,
                                      width: 45,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage: new NetworkImage(
                                            userlist[index].image.length > 0
                                                ? userlist[index].image
                                                : noImage),
                                      ),
                                    ),
                                    title: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Text(
                                          userlist[index].name,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    subtitle: new Container(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          userlist[index].callType == "voice"
                                              ? Image.asset(
                                                  "assets/images/call_blue.png",
                                                  color: Colors.red,
                                                  height: 17,
                                                )
                                              : Image.asset(
                                                  "assets/images/Video_Call.png",
                                                  color: Colors.red,
                                                  height: 12,
                                                ),
                                          SizedBox(
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    1,
                                          ),
                                          new Text(
                                            userlist[index].callStatus,
                                            style: new TextStyle(
                                                color: Colors.red,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    3.2,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    new Text(
                                      DateTime.now()
                                                  .difference(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          int.parse(
                                                              userlist[index]
                                                                  .time)))
                                                  .inDays ==
                                              0
                                          ? DateFormat('hh:mm a').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      int.parse(
                                                userlist[index].time,
                                              )),
                                            )
                                          : DateFormat('hh:mm a').format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        int.parse(
                                                  userlist[index].time,
                                                )),
                                              ) +
                                              " " +
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        int.parse(
                                                  userlist[index].time,
                                                )),
                                              ),
                                      style: new TextStyle(
                                          color: Colors.grey, fontSize: 14.0),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: appColorGreen,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ContactInfo(
                                                id: userlist[index].recId !=
                                                        userID
                                                    ? userlist[index].recId
                                                    : userlist[index].callerId,
                                                imageMedia: [],
                                                videoMedia: [],
                                                docsMedia: [],
                                                imageMediaTime: [],
                                                blocksId: [])),
                                      );
                                    }),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                          ],
                        );
            },
          )
        : Container();
  }

  Future<http.Response> sendCallNotification(
      String peerToken, String content) async {
    final response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            "key=AAAA-4XGo4Y:APA91bHGPYL1PJp024uUhnsd4oS9KEJYNk3LArCpz4LxL5uJRUyN55x9wYNCgKtLcMAsI-EIRf2iUPCLqn6pLav1VHUWM6x9NTF1aNitY6Vb12S0TgHSdhfaGeBMD0i0htnLrRNZo68w"
      },
      body: jsonEncode({
        "to": peerToken,
        "priority": "high",
        "data": {
          "type": "100",
          "user_id": userID,
          "title": content,
          "user_pic": globalImage,
          "message": globalName,
          "time": DateTime.now().millisecondsSinceEpoch,
          "sound": "custom.mp3",
          "vibrate": "300",
        },
        "notification": {
          "vibrate": "300",
          "priority": "high",
          "body": content,
          "title": globalName,
          "sound": "custom.mp3",
        }
      }),
    );
    return response;
  }

  clearAllMenu(BuildContext context) {
    containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Clear All".tr,
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              clearAllFunction();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "Cancel".tr,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ),
      ),
    );
  }

  clearAllFunction() {
    for (var i = 0; i < userlist.length; i++) {
      database
          .reference()
          .child("call_history")
          .child(userlist[i].key)
          .remove();
    }
    setState(() {
      userlist = [];
    });
  }

  deleteOrder(String orderId, int index) {
    database
        .reference()
        .child("call_history")
        .child(orderId)
        .remove()
        .then((_) {
      setState(() {
        userlist.removeAt(index);
      });
    });
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {});
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    userlist.forEach((userDetail) {
      if (userDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List _searchResult = [];
