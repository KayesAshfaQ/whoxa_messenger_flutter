import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/Screens/block.dart';
import 'package:flutterwhatsappclone/Screens/dpPrivacy.dart';
import 'package:flutterwhatsappclone/Screens/lastseen.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';

class PrivacyOptions extends StatefulWidget {
  @override
  PrivacyOptionsState createState() {
    return new PrivacyOptionsState();
  }
}

class PrivacyOptionsState extends State<PrivacyOptions> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Privacy",
          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: appColorBlue,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LastSeen()),
                  );
                },
                child: Container(
                  height: SizeConfig.blockSizeVertical * 6,
                  child: Center(
                    child: ListTile(
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              'Last Seen',
                              style: new TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3.7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 0.5, color: Colors.grey),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePicture()),
                  );
                },
                child: Container(
                  height: SizeConfig.blockSizeVertical * 6,
                  child: Center(
                    child: ListTile(
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              'Profile Picture',
                              style: new TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3.7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 0.5, color: Colors.grey),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlockContacts()),
                  );
                },
                child: Container(
                  height: SizeConfig.blockSizeVertical * 6,
                  child: Center(
                    child: ListTile(
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              'Blocked',
                              style: new TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3.7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 0.5, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
