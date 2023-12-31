import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/Screens/privacy.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AccountOptions extends StatefulWidget {
  @override
  AccountOptionsState createState() {
    return new AccountOptionsState();
  }
}

class AccountOptionsState extends State<AccountOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Account".tr,
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeVertical * 6.4,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyOptions()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(width: 15),
                          new Text(
                            'Privacy'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: appColorGrey,
                      size: 20,
                    ),
                  ),
                  Container(width: 10)
                ],
              ),
            ),
            // Container(
            //   height: 0.5,
            //   color: Colors.grey[400],
            // ),
            // Container(
            //   height: SizeConfig.blockSizeVertical * 6.4,
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: InkWell(
            //           onTap: () {},
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: <Widget>[
            //               Container(width: 15),
            //               new Text(
            //                 'Delete My account',
            //                 style: new TextStyle(
            //                     fontSize: 16,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.black),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 0),
            //         child: Icon(
            //           Icons.arrow_forward_ios,
            //           color: appColorGrey,
            //           size: 20,
            //         ),
            //       ),
            //       Container(width: 10)
            //     ],
            //   ),
            // ),
            Container(
              height: 0.5,
              color: Colors.grey[400],
            ),
            Container(
              height: 0.5,
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
