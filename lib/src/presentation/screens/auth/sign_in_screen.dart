import 'dart:ui';

import 'package:app_chat/core/constants/icons.dart';
import 'package:app_chat/src/data/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/configs/dependencies_injection.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService authService = di();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SizedBox(
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(3, -0.3),
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                    color: CupertinoColors.activeGreen, shape: BoxShape.circle),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-3, -0.3),
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                    color: CupertinoColors.activeGreen, shape: BoxShape.circle),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 1.2),
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                    color: CupertinoColors.darkBackgroundGray,
                    shape: BoxShape.rectangle),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Stack(
                        children: [
                          Align(
                            child: Image.asset(
                              fit: BoxFit.cover,
                              IconsImageConstant.appIconRemoveBg.path,
                              height: 300,
                              width: 300,
                            ),
                          ),
                          const Align(
                            alignment: AlignmentDirectional(0, 1.5),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Welcome to\n2Bro",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "This official app is free. Log in and experience it.",
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade300),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    loginButtonWidget(
                        onPressed: () async {
                          bool status = await authService.signInWithGoogle();
                          if (status) {
                            toastification.show(
                                closeButtonShowType: CloseButtonShowType.none,
                                type: ToastificationType.success,
                                style: ToastificationStyle.flat,
                                autoCloseDuration: const Duration(seconds: 3),
                                title: const Text(
                                    "Login with Google account successfully!"));
                          } else {
                            toastification.show(
                                closeButtonShowType: CloseButtonShowType.none,
                                type: ToastificationType.error,
                                style: ToastificationStyle.flat,
                                autoCloseDuration: const Duration(seconds: 3),
                                title: const Text(
                                    "Login with Google account failed!"));
                          }
                        },
                        iconImagePath: IconsImageConstant.googleIcon.path,
                        label: "Continue with Google",
                        iconSize: 50),
                    const SizedBox(
                      height: 10,
                    ),
                    loginButtonWidget(
                        onPressed: () {},
                        iconImagePath: IconsImageConstant.facebookIcon.path,
                        label: "Continue with Facebook",
                        iconSize: 50),
                  ],
                ))
          ],
        ),
      )),
    );
  }

  Widget loginButtonWidget(
      {required Function()? onPressed,
      required String iconImagePath,
      required label,
      required double iconSize}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CupertinoColors.placeholderText),
        child: Row(
          children: [
            Image.asset(
              fit: BoxFit.cover,
              iconImagePath,
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
