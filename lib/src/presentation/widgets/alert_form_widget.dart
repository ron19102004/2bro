import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertFormWidget extends StatelessWidget {
  final List<Widget> body;

  const AlertFormWidget({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      content: Container(
        decoration: BoxDecoration(
            color: CupertinoColors.extraLightBackgroundGray,
            borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            children: body,
          ),
        ),
      ),
    );
  }
}
