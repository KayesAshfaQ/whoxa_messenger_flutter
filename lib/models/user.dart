import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String email;
  String name;
  String mobile;
  String countryCode;
  String userId;
  var img;
  String token;
  String location;
  String bio;
  String status;
  bool privacy;
  String inChat;
  String lastseen;
  String profileseen;
  String userBio;
  String passCode;
  bool passCodeStatus;

  User(
      this.email,
      this.name,
      this.mobile,
      this.countryCode,
      this.userId,
      this.img,
      this.token,
      this.location,
      this.bio,
      this.status,
      this.privacy,
      this.inChat,
      this.lastseen,
      this.profileseen,
      this.userBio,
      this.passCode,
      this.passCodeStatus);

  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        email = snapshot.value["email"],
        name = snapshot.value["name"],
        mobile = snapshot.value["mobile"],
        countryCode = snapshot.value["countryCode"],
        userId = snapshot.value["userId"],
        img = snapshot.value["img"],
        token = snapshot.value["token"],
        location = snapshot.value["location"],
        bio = snapshot.value["bio"],
        status = snapshot.value["status"],
        privacy = snapshot.value["privacy"],
        inChat = snapshot.value["inChat"],
        lastseen = snapshot.value["lastseen"],
        profileseen = snapshot.value["profileseen"],
        userBio = snapshot.value["userBio"],
        passCode = snapshot.value["passCode"],
        passCodeStatus = snapshot.value["passCodeStatus"];
  toJson() {
    return {
      "email": email,
      "name": name,
      "mobile": mobile,
      "countryCode": countryCode,
      "userId": userId,
      "img": img,
      "token": token,
      "location": location,
      "bio": bio,
      "status": status,
      "privacy": privacy,
      "inChat": inChat,
      "lastseen": lastseen,
      "profileseen": profileseen,
      "userBio": userBio,
      "passCode": passCode,
      "passCodeStatus": passCodeStatus
    };
  }
}
