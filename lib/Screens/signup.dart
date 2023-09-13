// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutterwhatsappclone/constatnt/global.dart';
import 'package:flutterwhatsappclone/helper/sizeconfig.dart';
import 'dart:io';
import 'package:flutterwhatsappclone/models/user.dart';
import 'package:flutterwhatsappclone/share_preference/preferencesKey.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  File imageFile;
  bool isLoading = false;
  File _image;
  String _token = '';
  String code = "+91";

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final mobFocusNode = FocusNode();
  final passFocusNode = FocusNode();

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  _getToken() {
    FirebaseMessaging().getToken().then((token) {
      setState(() {
        _token = token;
      });
    });
  }

  Future getImage() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    if (imageFile != null) {
      setState(() {
        if (imageFile != null) {
          _image = File(imageFile.path);
        } else {
          print('No image selected.');
        }
      });
    }
  }

  String userId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 120,
                        ),
                        _image == null
                            ? RawMaterialButton(
                                onPressed: () {
                                  getImage();
                                },
                                elevation: 2.0,
                                fillColor: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      size: 100.0,
                                      color: Colors.grey[700],
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              )
                            : InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: CircleAvatar(
                                  backgroundImage: FileImage(_image),
                                  radius: 60,
                                ),
                              ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 5,
                        ),
                        _nameTextfield(context),
                        // _emailTextfield(context),

                        _mobTextfield(context),
                        _passwordTextfield(context),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 5,
                        ),
                        Text(
                          'NOTE : You can enter any number you want',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        //  _mobTextfield(context),
                        _loginButton(context),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                _dontHaveAnAccount(context),
              ],
            ),
            isLoading == true ? Center(child: loader()) : Container(),
          ],
        ));
  }

  Widget _nameTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          maxLines: 1,
          focusNode: nameFocusNode,
          textInputAction: TextInputAction.next,
          controller: nameController,
          hintText: 'Enter Username',
          prefixIcon: Icon(
            Icons.person,
            size: 25.0,
            color: appColorBlue,
          ),
        ));
  }

  Widget _passwordTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          textInputAction: TextInputAction.next,
          controller: passwordController,
          hintText: 'Enter Password',
          focusNode: passFocusNode,
          prefixIcon: Icon(
            Icons.lock,
            size: 25.0,
            color: appColorBlue,
          ),
        ));
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: CustomtextField(
        maxLines: 1,
        textInputAction: TextInputAction.next,
        controller: emailController,
        hintText: 'Enter Email',
        focusNode: emailFocusNode,
        prefixIcon: Icon(
          Icons.email,
          size: 25.0,
          color: appColorBlue,
        ),
      ),
    );
  }

  Widget _mobTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: CustomtextField(
        maxLines: 1,
        focusNode: mobFocusNode,
        textInputAction: TextInputAction.next,
        controller: mobController,
        keyboardType: TextInputType.number,
        hintText: 'Enter Mobile Number',
        prefixIcon: Container(
          width: 40,
          child: CountryCodePicker(
            dialogBackgroundColor: Colors.white,
            backgroundColor: Colors.black,
            onChanged: (value) {
              _onCountryChange(value);
            },
            initialSelection: "+91",
            textStyle: TextStyle(color: Colors.black),
            dialogTextStyle: TextStyle(color: Colors.black),
            searchStyle: TextStyle(color: Colors.white),
            hideSearch: true,
            // searchDecoration: InputDecoration(
            //   fillColor: Colors.black,
            //   filled: true,
            // ),
            padding: const EdgeInsets.all(0),
            showCountryOnly: true,
            showFlag: false,
            showOnlyCountryWhenClosed: false,
          ),
        ),
      ),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      code = countryCode.toString();
      nameFocusNode.unfocus();
      emailFocusNode.unfocus();
      mobFocusNode.unfocus();
      passFocusNode.unfocus();

      nameFocusNode.canRequestFocus = false;
      emailFocusNode.canRequestFocus = false;
      mobFocusNode.canRequestFocus = false;
      passFocusNode.canRequestFocus = false;
    });
    print("New Country selected: " + countryCode.toString());
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 0, left: 20),
        child: SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.screenWidth,
          child: CustomButtom(
            title: 'Sign Up',
            color: appColorBlue,
            onPressed: () {
              setState(() {
                nameFocusNode.unfocus();
                emailFocusNode.unfocus();
                mobFocusNode.unfocus();
                passFocusNode.unfocus();

                nameFocusNode.canRequestFocus = false;
                emailFocusNode.canRequestFocus = false;
                mobFocusNode.canRequestFocus = false;
                passFocusNode.canRequestFocus = false;
              });
              // Pattern pattern =
              //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              // RegExp regex = new RegExp(pattern);
              if (passwordController.text != '' &&
                  nameController.text != '' &&
                  // mobileController.text != '' &&

                  passwordController.text.length > 5) {
                _register();
              } else {
                Toast.show(
                    "Fields is empty or password length should be between 6-8 characters.",
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _dontHaveAnAccount(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding:
            const EdgeInsets.only(right: 20, top: 10, left: 20, bottom: 10),
        child: Text.rich(
          TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
              fontSize: 14,
              color: appColorGrey,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Sign In',
                style: TextStyle(
                  fontSize: 14,
                  // decoration: TextDecoration.underline,
                  color: appColorBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        // email: emailController.text.trim(),
        email: nameController.text.trim() + '@primocys.com',
        password: passwordController.text,
      )
          .then((currentuser) {
        if (currentuser != null) {
          print(currentuser.user.uid);
          dataEntry(currentuser.user.uid);
        } else {
          setState(() {
            isLoading = false;
          });
          Toast.show("Something went wrong please try again", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Toast.show(onError.toString(), context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Toast.show(e.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  dataEntry(String userId) async {
    if (_image != null) {
      setState(() {
        isLoading = true;
      });
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        _image.absolute.path,
        targetPath,
        quality: 20,
      ).then((value) async {
        print("Compressed");
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        StorageReference reference =
            FirebaseStorage.instance.ref().child("ProfilePic").child(fileName);

        StorageUploadTask uploadTask = reference.putFile(value);
        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) async {
          User admin = new User(
              nameController.text.trim() + '@lifetime.com',
              nameController.text,
              mobController.text,
              code,
              userId,
              downloadUrl,
              _token,
              "",
              "",
              "",
              false,
              '',
              'everyone',
              'everyone',
              '',
              passwordController.text.trim().toString(),
              false);
          _database
              .reference()
              .child("user")
              .child(userId)
              .set(admin.toJson())
              .then((value) {
            Firestore.instance.collection('users').document(userId).setData({
              'uid': userId,
              'name': nameController.text.toString(),
              'email': nameController.text.trim() + '@lifetime.com',
              'username': nameController.text.toString(),
              'status': "",
              'state': 1,
              'profile_photo': downloadUrl,
              'token': _token,
              'mobile': mobController.text,
              'passCode': passwordController.text.trim().toString()
            }, merge: true).then((value) {
              setState(() {
                userID = userId;
                isLoading = false;
              });
              Toast.show("Login to continue.", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              Navigator.pop(context);
            });
          });
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString(
              SharedPreferencesKey.LOGGED_IN_USERRDATA, userId);
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
        });
      });
    } else {
      setState(() {
        isLoading = true;
      });
      User admin = new User(
          nameController.text.trim() + '@lifetime.com',
          nameController.text,
          mobController.text,
          code,
          userId,
          "",
          _token,
          "",
          "",
          "",
          false,
          '',
          'everyone',
          'everyone',
          '',
          passwordController.text.trim().toString(),
          false);
      _database
          .reference()
          .child("user")
          .child(userId)
          .set(admin.toJson())
          .then((value) {
        Firestore.instance.collection('users').document(userId).setData({
          'uid': userId,
          'name': nameController.text.toString(),
          'email': nameController.text.trim() + '@lifetime.com',
          'username': nameController.text.toString(),
          'status': "",
          'state': 1,
          'profile_photo': '',
          'token': _token,
          'mobile': mobController.text,
          'passCode': passwordController.text.trim().toString()
        }, merge: true).then((value) {
          setState(() {
            isLoading = false;
            userID = userId;
          });
          Toast.show("Login to continue.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.pop(context);
        });
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(SharedPreferencesKey.LOGGED_IN_USERRDATA, userId);
    }
  }
}
