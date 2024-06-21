import 'package:app_chat/core/configs/dependencies_injection.dart';
import 'package:app_chat/src/data/entities/message_group_contact.dart';
import 'package:app_chat/src/data/entities/user_entity.dart';
import 'package:app_chat/src/data/services/message_group_service.dart';
import 'package:app_chat/src/presentation/screens/message/message_screen.dart';
import 'package:app_chat/src/presentation/widgets/alert_form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class MessageGroupSettingScreen extends StatefulWidget {
  final MessageGroupContact messageGroupContact;

  const MessageGroupSettingScreen(
      {super.key, required this.messageGroupContact});

  @override
  State<MessageGroupSettingScreen> createState() =>
      _MessageGroupSettingScreenState();
}

void showDialogChange(
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

class _MessageGroupSettingScreenState extends State<MessageGroupSettingScreen> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Group setting",
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
            child: Column(
          children: [
            Align(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  width: 150,
                  height: 150,
                  widget.messageGroupContact.groupPhotoURL,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondaryLabel,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        CupertinoIcons.person_3_fill,
                        color: CupertinoColors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                widget.messageGroupContact.groupName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.extraLightBackgroundGray,
                    fontSize: 26),
              ),
            ),
            Align(
              child: IconButton(
                  onPressed: () {
                    showDialogChange(
                        context: context,
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            di<MessageGroupService>().changeNameGroup(
                                widget.messageGroupContact.groupId,
                                nameController.text);
                            toastification.show(
                                closeButtonShowType: CloseButtonShowType.none,
                                type: ToastificationType.success,
                                style: ToastificationStyle.flat,
                                autoCloseDuration: const Duration(seconds: 3),
                                title: const Text(
                                    "Change name group successfully!"));
                            Navigator.pop(context);
                          }
                        },
                        title: "Change name",
                        hint: "Enter new name",
                        textButton: "Change",
                        controller: nameController);
                  },
                  icon: const Icon(
                    CupertinoIcons.eyedropper,
                    color: CupertinoColors.inactiveGray,
                  )),
            ),
            Text(
              "Members: ${widget.messageGroupContact.quantityMember}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
            Expanded(child: memberListWidget())
          ],
        )),
      ),
    );
  }

  Widget memberListWidget() {
    return StreamBuilder<List<UserEntity>>(
        stream: di<MessageGroupService>()
            .getUserGroupStream(widget.messageGroupContact.groupId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertFormWidget(body: [
                            Text(
                              "Remove ${user.fullName} out of this group ?",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextButton(
                                onPressed: () {
                                  di<MessageGroupService>().removeMember(
                                      widget.messageGroupContact.groupId,
                                      user.uid);
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: CupertinoColors.systemGreen,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ))
                          ]);
                        },
                      );
                    },
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(
                        builder: (context) {
                          return MessageScreen(
                              receiverId: user.uid,
                              name: user.fullName!,
                              photoURL: user.photoURL!);
                        },
                      ));
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(user.photoURL!),
                    ),
                    title: Text(
                      user.fullName ?? "Unknown",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: CupertinoColors.extraLightBackgroundGray),
                    ),
                    subtitle: Text(
                      user.email ?? "Unknown",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 15, color: CupertinoColors.inactiveGray),
                    ),
                  );
                },
              ),
            );
          }
          return const Align(
            child: CircularProgressIndicator(
              color: CupertinoColors.inactiveGray,
            ),
          );
        });
  }
}
