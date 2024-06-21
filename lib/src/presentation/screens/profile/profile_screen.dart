import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? userCurrent;

  @override
  void initState() {
    super.initState();
    userCurrent = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: CupertinoColors.extraLightBackgroundGray),
          ),
          backgroundColor: CupertinoColors.darkBackgroundGray,
          leading: BackButton(
            color: CupertinoColors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: CupertinoColors.darkBackgroundGray,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    userCurrent?.photoURL ?? "",
                  ),
                ),
              ),
              Text(
                userCurrent?.displayName ?? "Unknown",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: CupertinoColors.extraLightBackgroundGray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
