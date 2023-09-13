import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/Screens/chat.dart';

import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';
import 'package:flutterwhatsappclone/models/user.dart';

import 'package:url_launcher/url_launcher.dart';

class SearchByUserName extends StatefulWidget {
  @override
  SearchByUserNameState createState() {
    return new SearchByUserNameState();
  }
}

class SearchByUserNameState extends State<SearchByUserName> {
  List<User> userlist;
  TextEditingController controller = new TextEditingController();
  Query query;
  String userId;
  StreamSubscription<Event> _onOrderAddedSubscription;
  StreamSubscription<Event> _onOrderChangedSubscription;
  FirebaseDatabase database = new FirebaseDatabase();
  var userNames = [];

  @override
  void initState() {
    super.initState();

    // getContactsFromGloble().then((value) {
    // refreshContacts();
    // FirebaseAuth.instance.currentUser().then((user) {
    print(userID);
    setState(() {
      userId = userID;
      // ignore: deprecated_member_use
      userlist = new List();
      query = database.reference().child("user").orderByChild("userId");
      _onOrderAddedSubscription = query.onChildAdded.listen(onEntryAdded1);
      _onOrderChangedSubscription =
          query.onChildChanged.listen(onEntryChanged1);
      contactsWidget();
    });
    // });
    // });
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
      userlist[userlist.indexOf(oldEntry)] = User.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded1(Event event) {
    setState(() {
      userlist.add(User.fromSnapshot(event.snapshot));
      for (var i = 0; i < userlist.length; i++) {
        userNames.add(userlist[i].name);
      }
      print('added users : $userNames');
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Search',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        // elevation: _showAppbar ? 0 : 1,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Material(
            elevation: 0,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  // height: SizeConfig.blockSizeVertical * 15,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: new BoxDecoration(
                                      //color: Colors.green,
                                      borderRadius: new BorderRadius.all(
                                    Radius.circular(15.0),
                                  )),
                                  height: 40,
                                  child: Center(
                                    child: TextField(
                                      controller: controller,
                                      // onChanged: onSearchTextChanged,
                                      style: TextStyle(color: Colors.grey),
                                      decoration: new InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.grey[200]),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(15.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.grey[200]),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(15.0),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.grey[200]),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(15.0),
                                          ),
                                        ),
                                        filled: true,
                                        hintStyle: new TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14),
                                        hintText: "Enter username",
                                        contentPadding:
                                            EdgeInsets.only(top: 10.0),
                                        fillColor: Colors.grey[200],
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.grey[600],
                                          size: 25.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: TextButton(
                                    onPressed: () => onSearchTextChanged(),
                                    child: Text('Search')),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                _searchResult.length != 0
                    ? Container(
                        height: SizeConfig.safeBlockVertical * 7,
                        color: Colors.black,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                'Result',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 4,
                                    fontFamily: "MontserratBold",
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).cardColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                contactsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contactsWidget() {
    return userlist != null && userlist.length > 0
        ? _searchResult.length != 0 ||
                controller.text.trim().toLowerCase().isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: _searchResult.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return userId != userlist[index].userId
                      ? Column(
                          children: <Widget>[
                            new Divider(
                              height: 1,
                            ),
                            new ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chat(
                                            peerID: _searchResult[index].userId,
                                          )),
                                );
                              },
                              leading: new Stack(
                                children: <Widget>[
                                  (_searchResult[index].img != null &&
                                          _searchResult[index].img.length > 0)
                                      ? CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: new NetworkImage(
                                              _searchResult[index].img),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.grey[300],
                                          child: Image.asset(
                                            "assets/images/user.png",
                                            height: 25,
                                            color: Colors.white,
                                          )),
                                ],
                              ),
                              title: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    _searchResult[index].name ?? "",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchResult
                                          .remove(_searchResult[index]);
                                    });
                                  },
                                  icon: Icon(Icons.clear)),
                              // subtitle: new Container(
                              //   padding: const EdgeInsets.only(top: 5.0),
                              //   child: new Row(
                              //     children: [
                              //       Text(
                              //         _searchResult[index].mobile ?? "",
                              //         style: TextStyle(fontSize: 13),
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ),
                          ],
                        )
                      : Container();
                },
              )
            // : ListView.builder(
            //     padding: const EdgeInsets.all(0),
            //     itemCount: userlist.length,
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     itemBuilder: (BuildContext context, int index) {
            //       // print(userlist[index].mobile);
            //       return userId != userlist[index].userId &&
            //               userlist[index].name.length > 0
            //           ? Column(
            //               children: <Widget>[
            //                 new Divider(
            //                   height: 1,
            //                 ),
            //                 new ListTile(
            //                   onTap: () {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => Chat(
            //                                 peerID: userlist[index].userId,
            //                               )),
            //                     );
            //                   },
            //                   leading: new Stack(
            //                     children: <Widget>[
            //                       (userlist[index].img != null &&
            //                               userlist[index].img.length > 0)
            //                           ? CircleAvatar(
            //                               backgroundColor: Colors.grey,
            //                               backgroundImage: new NetworkImage(
            //                                   userlist[index].img),
            //                             )
            //                           : CircleAvatar(
            //                               backgroundColor: Colors.grey[300],
            //                               child: Image.asset(
            //                                 "assets/images/user.png",
            //                                 height: 25,
            //                                 color: Colors.white,
            //                               )),
            //                     ],
            //                   ),
            //                   title: Text(
            //                     userlist[index].name,
            //                     style:
            //                         new TextStyle(fontWeight: FontWeight.bold),
            //                   ),
            //                   // title: savedContactUserId
            //                   //             .contains(userlist[index].userId) &&
            //                   //         allcontacts != null &&
            //                   //         userlist[index].mobile.length > 0
            //                   //     ? Row(
            //                   //         mainAxisAlignment:
            //                   //             MainAxisAlignment.start,
            //                   //         children: <Widget>[
            //                   //           for (var i = 0;
            //                   //               i < allcontacts.length;
            //                   //               i++)
            //                   //             Text(
            //                   //               allcontacts[i]
            //                   //                       .phones
            //                   //                       .map((e) => e.value)
            //                   //                       .toString()
            //                   //                       .replaceAll(
            //                   //                           new RegExp(
            //                   //                               r"\s+\b|\b\s"),
            //                   //                           "")
            //                   //                       .contains(userlist[index]
            //                   //                           .mobile)
            //                   //                   ? allcontacts[i].displayName
            //                   //                   : "",
            //                   //               style: new TextStyle(
            //                   //                 fontWeight: FontWeight.bold,
            //                   //                 color: appColorBlack,
            //                   //                 fontSize: 16.0,
            //                   //               ),
            //                   //             )
            //                   //         ],
            //                   //       )
            //                   //     : Text(
            //                   //         userlist[index].mobile,
            //                   //         style: TextStyle(
            //                   //             fontSize: 16.0,
            //                   //             fontWeight: FontWeight.bold,
            //                   //             color: Colors.black),
            //                   //       ),
            //                   // ListView.builder(
            //                   //   padding: const EdgeInsets.all(0),
            //                   //   itemCount: 1,
            //                   //   physics: NeverScrollableScrollPhysics(),
            //                   //   shrinkWrap: true,
            //                   //   itemBuilder: (context, int i) {
            //                   //     return Text(
            //                   //       allcontacts[i]
            //                   //               .phones
            //                   //               .map((e) => e.value)
            //                   //               .toString()
            //                   //               .replaceAll(
            //                   //                   new RegExp(r"\s+\b|\b\s"), "")
            //                   //               .contains(userlist[index].mobile)
            //                   //           ? allcontacts[i].displayName
            //                   //           : userlist[index].name,
            //                   //       style: new TextStyle(
            //                   //           fontWeight: FontWeight.bold),
            //                   //     );
            //                   //   },
            //                   // ),
            //                   subtitle: new Container(
            //                     padding: const EdgeInsets.only(top: 5.0),
            //                     child: new Row(
            //                       children: [
            //                         Text(
            //                           // newCheck[index],
            //                           userlist[index].mobile ?? "",
            //                           style: TextStyle(fontSize: 13),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             )
            //           : Container();
            //     },
            //   )
            : Center(
                child: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/Empty-amico.png',
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text('Enter username to find user'),
                      ],
                    ),
                  ),
                ),
              )
        : Center(child: CircularProgressIndicator());
  }

  // Widget inviteFriend() {
  //   return ListView.builder(
  //     padding: const EdgeInsets.all(0),
  //     itemCount: _contacts.length,
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemBuilder: (BuildContext context, int index) {
  //       return _contacts != null
  //           ? userNames.contains(
  //                   _contacts[index].phones.map((e) => e.value).toString())
  //               ? Container()
  //               : Column(
  //                   children: <Widget>[
  //                     new Divider(
  //                       height: 1,
  //                     ),
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: new ListTile(
  //                             onTap: () {},
  //                             leading: new Stack(
  //                               children: <Widget>[
  //                                 CircleAvatar(
  //                                     backgroundColor: Colors.grey[300],
  //                                     child: Text(
  //                                       _contacts[index].displayName != null
  //                                           ? _contacts[index].displayName[0]
  //                                           : "?",
  //                                       style: TextStyle(
  //                                           color: appColorBlue,
  //                                           fontSize: 20,
  //                                           fontFamily: "MontserratBold",
  //                                           fontWeight: FontWeight.bold),
  //                                     )),
  //                               ],
  //                             ),
  //                             title: new Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: <Widget>[
  //                                 new Text(
  //                                   _contacts[index].displayName ?? "",
  //                                   style: new TextStyle(
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ],
  //                             ),
  //                             subtitle: new Container(
  //                               padding: const EdgeInsets.only(top: 5.0),
  //                               child: new Row(
  //                                 children: [
  //                                   Text(
  //                                     _contacts[index]
  //                                         .phones
  //                                         .map((e) => e.value)
  //                                         .toString()
  //                                         .replaceAll("(", "")
  //                                         .replaceAll(")", ""),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             inviteMe(_contacts[index]
  //                                 .phones
  //                                 .map((e) => e.value)
  //                                 .toString());
  //                           },
  //                           child: CustomText(
  //                             text: "Invite",
  //                             color: appColorBlue,
  //                             fontSize: 15,
  //                             alignment: Alignment.center,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Container(
  //                           width: 15,
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 )
  //           : Container;
  //     },
  //   );
  // }

  onSearchTextChanged() async {
    _searchResult.clear();
    if (controller.text.toString().isEmpty) {
      setState(() {});
      return;
    } else {
      userlist.forEach((userDetail) {
        if (userDetail.name != null && userDetail.name == controller.text)
        // for (int i = 0; i < chatList.length; i++) {
        if (userDetail.name
                    .toLowerCase()
                    .contains(controller.text.toString().toLowerCase()) ||
                userDetail.mobile
                    .toLowerCase()
                    .contains(controller.text.toString().toLowerCase())
            // ||chatList[i]['name'].toLowerCase().contains(text.toLowerCase())
            ) _searchResult.add(userDetail);
        // }
      });
    }

    setState(() {});
  }

  inviteMe(phone) async {
    // Android
    String uri =
        'sms:$phone?body=${"‎Let's chat on Whoxa! It's a fast, simple, and secure app we can use to message and call each other for free. Get it at https://play.google.com/store/apps/details?id=com.whoxa.primocys"}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      String uri =
          'sms:$phone?body=${"‎Let's chat on Whoxa! It's a fast, simple, and secure app we can use to message and call each other for free. Get it at https://play.google.com/store/apps/details?id=com.whoxa.primocys"}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}

List _searchResult = [];
