import 'package:app_chat/src/data/repositories/user_repo.dart';
import 'package:app_chat/src/data/services/message_group_service.dart';
import 'package:app_chat/src/presentation/screens/auth/sign_in_screen.dart';
import 'package:app_chat/src/presentation/screens/home/home_screen.dart';
import 'package:app_chat/src/presentation/screens/home/search_user_screen.dart';
import 'package:app_chat/src/presentation/screens/message/message_screen.dart';
import 'package:app_chat/src/presentation/screens/setting/setting_screen.dart';
import 'package:app_chat/src/presentation/widgets/alert_form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:toastification/toastification.dart';

import '../../../core/configs/dependencies_injection.dart';

class StartPointAppScreen extends StatefulWidget {
  const StartPointAppScreen({super.key});

  @override
  State<StartPointAppScreen> createState() => _StartPointAppScreenState();
}

class _StartPointAppScreenState extends State<StartPointAppScreen> {
  int selectedIndex = 0;
  late List<Map<dynamic, dynamic>> screens;
  final emailValueAddChatController = TextEditingController();
  final groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    screens = [
      {"screen": const HomeScreen(), "label": "Chats"},
      {"screen": const SettingScreen(), "label": "Settings"}
    ];
  }

  @override
  void dispose() {
    super.dispose();
    emailValueAddChatController.dispose();
    groupNameController.dispose();
  }

  void showAddNew(
      {required BuildContext context,
      required Function()? onPressed,
      required String title,
      required String hint,
      required String textButton,
      required TextEditingController controller}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertFormWidget(body: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: controller,
            style: const TextStyle(color: CupertinoColors.black),
            cursorColor: CupertinoColors.inactiveGray,
            decoration: InputDecoration(
              fillColor: CupertinoColors.inactiveGray,
              hintStyle: const TextStyle(color: CupertinoColors.inactiveGray),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: CupertinoColors.secondaryLabel)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: CupertinoColors.secondarySystemFill)),
              hintText: hint,
            ),
          ),
          TextButton(
              onPressed: onPressed,
              child: const Text(
                "Chat",
                style: TextStyle(
                    color: CupertinoColors.systemGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ))
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: const ToastificationConfig(alignment: Alignment.topCenter),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                floatingActionButton: selectedIndex == 0
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: CupertinoColors.quaternaryLabel),
                        child: IconButton(
                            onPressed: () {
                              showAddNew(
                                  controller: emailValueAddChatController,
                                  context: context,
                                  onPressed: () {
                                    if (emailValueAddChatController
                                        .text.isNotEmpty) {
                                      di<UserRepository>()
                                          .findByEmail(
                                              emailValueAddChatController.text
                                                  .trim())
                                          .then(
                                        (value) {
                                          if (value != null) {
                                            emailValueAddChatController.clear();
                                            Navigator.push(context,
                                                CupertinoPageRoute(
                                              builder: (context) {
                                                return MessageScreen(
                                                    receiverId: value.uid,
                                                    name: value.fullName ??
                                                        "Unknown",
                                                    photoURL:
                                                        value.photoURL ?? "");
                                              },
                                            ));
                                          } else {
                                            emailValueAddChatController.clear();
                                            toastification.show(
                                                closeButtonShowType:
                                                    CloseButtonShowType.none,
                                                type: ToastificationType.error,
                                                style: ToastificationStyle.flat,
                                                autoCloseDuration:
                                                    const Duration(seconds: 3),
                                                title: const Text(
                                                    "Email not exist!"));
                                          }
                                        },
                                      );
                                    }
                                  },
                                  title: "Add new chat",
                                  hint: "Enter email",
                                  textButton: "Chat");
                            },
                            icon: const Icon(
                              CupertinoIcons.person_add,
                              color: CupertinoColors.activeGreen,
                            )),
                      )
                    : const SizedBox(),
                appBar: AppBar(
                  actions: [
                    selectedIndex == 0
                        ? IconButton(
                            onPressed: () {
                              showAddNew(
                                  context: context,
                                  onPressed: () {
                                    if (groupNameController.text.isNotEmpty) {
                                      di<MessageGroupService>().createGroup(
                                          groupNameController.text);
                                      groupNameController.clear();
                                      Navigator.pop(context);
                                    }
                                  },
                                  title: "Add new group",
                                  hint: "Enter name group",
                                  textButton: "Create",
                                  controller: groupNameController);
                            },
                            icon: const Icon(
                              CupertinoIcons.group_solid,
                              color: CupertinoColors.extraLightBackgroundGray,
                            ))
                        : const SizedBox(),
                    // selectedIndex == 0
                    //     ? Container(
                    //         margin: const EdgeInsets.only(right: 10),
                    //         width: 40,
                    //         height: 40,
                    //         decoration: const BoxDecoration(
                    //           color: CupertinoColors.placeholderText,
                    //           shape: BoxShape.circle,
                    //         ),
                    //         child: IconButton(
                    //             onPressed: () {
                    //               Navigator.push(context, CupertinoPageRoute(
                    //                 builder: (context) {
                    //                   return const SearchUserScreen();
                    //                 },
                    //               ));
                    //             },
                    //             icon: const Icon(
                    //               CupertinoIcons.search,
                    //               color:
                    //                   CupertinoColors.extraLightBackgroundGray,
                    //             )),
                    //       )
                    //     : const SizedBox(),
                  ],
                  backgroundColor: CupertinoColors.darkBackgroundGray,
                  title: Text(
                    screens[selectedIndex]["label"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: CupertinoColors.extraLightBackgroundGray),
                  ),
                ),
                backgroundColor: CupertinoColors.darkBackgroundGray,
                bottomNavigationBar: SlidingClippedNavBar(
                  backgroundColor: CupertinoColors.darkBackgroundGray,
                  barItems: [
                    BarItem(
                      icon: CupertinoIcons.house_alt_fill,
                      title: 'Home',
                    ),
                    BarItem(
                      icon: CupertinoIcons.settings,
                      title: 'Setting',
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onButtonPressed: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  activeColor: CupertinoColors.white,
                  inactiveColor: CupertinoColors.inactiveGray,
                ),
                body: screens[selectedIndex]["screen"],
              );
            }
            return const SignInScreen();
          },
        ),
      ),
    );
  }
}
