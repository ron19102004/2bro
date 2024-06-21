import 'package:app_chat/src/data/repositories/user_repo.dart';
import 'package:app_chat/src/presentation/screens/message/message_screen.dart';
import 'package:app_chat/src/presentation/screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/configs/dependencies_injection.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late User? userCurrent;

  @override
  void initState() {
    super.initState();
    userCurrent = FirebaseAuth.instance.currentUser;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        profileContainer(),
        CupertinoButton(
          child: const Text(
            "Log out",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: CupertinoColors.inactiveGray),
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            toastification.show(
                closeButtonShowType: CloseButtonShowType.none,
                type: ToastificationType.success,
                style: ToastificationStyle.flat,
                autoCloseDuration: const Duration(seconds: 3),
                title: const Text("Logout successfully!"));
          },
        ),
        // CupertinoButton(
        //   child: const Text(
        //     "Contact via facebook",
        //     style: TextStyle(
        //         fontWeight: FontWeight.w500,
        //         color: CupertinoColors.inactiveGray),
        //   ),
        //   onPressed: () {
        //     _launchURL("https://www.facebook.com/ron292004/");
        //   },
        // ),
        CupertinoButton(
          child: const Text(
            "Contact admin via 2bro",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: CupertinoColors.inactiveGray),
          ),
          onPressed: () {
            di<UserRepository>().findByEmail("ron19102004@gmail.com").then(
              (value) {
                if (value != null) {
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) {
                      return MessageScreen(
                          receiverId: value.uid,
                          name: value.fullName ?? "Unknown",
                          photoURL: value.photoURL ?? "");
                    },
                  ));
                }
              },
            );
          },
        )
      ],
    ));
  }

  ListTile profileContainer() {
    return ListTile(
      tileColor: CupertinoColors.quaternaryLabel,
      contentPadding: const EdgeInsets.all(10),
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(
          builder: (context) {
            return const ProfileScreen();
          },
        ));
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          fit: BoxFit.cover,
          userCurrent?.photoURL ?? "",
          errorBuilder: (context, error, stackTrace) {
            return Container();
          },
        ),
      ),
      title: Text(
        userCurrent?.displayName ?? "Unknown",
        style: const TextStyle(
            color: CupertinoColors.extraLightBackgroundGray,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }
}
