import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String? fullName;
  final String? email;
  final String? photoURL;
  final String? phoneNumber;
  final String uid;

  UserEntity(
      {required this.email,
      required this.photoURL,
      required this.phoneNumber,
      required this.uid,
      required this.fullName});

  factory UserEntity.fromJson(Map<String, dynamic> data) {
    return UserEntity(
        email: data["email"],
        photoURL: data["photoURL"],
        phoneNumber: data["phoneNumber"],
        uid: data["uid"],
        fullName: data["fullName"]);
  }

  factory UserEntity.fromUserAuth(User user) {
    return UserEntity(
        email: user.email,
        photoURL: user.photoURL,
        phoneNumber: user.phoneNumber,
        uid: user.uid,
        fullName: user.displayName);
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "photoURL": photoURL,
      "phoneNumber": phoneNumber,
      "uid": uid,
      "fullName": fullName
    };
  }
}
