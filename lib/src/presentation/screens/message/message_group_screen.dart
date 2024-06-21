import 'package:app_chat/src/data/entities/message_entity.dart';
import 'package:app_chat/src/data/entities/message_group_contact.dart';
import 'package:app_chat/src/data/services/message_group_service.dart';
import 'package:app_chat/src/presentation/screens/message/message_group_setting_screen.dart';
import 'package:app_chat/src/presentation/widgets/alert_form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/configs/dependencies_injection.dart';

class MessageGroupScreen extends StatefulWidget {
  final MessageGroupContact messageGroupContact;

  const MessageGroupScreen({super.key, required this.messageGroupContact});

  @override
  State<MessageGroupScreen> createState() => _MessageGroupScreenState();
}

class _MessageGroupScreenState extends State<MessageGroupScreen> {
  final userCurrent = FirebaseAuth.instance.currentUser!;
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    messageController.dispose();
    emailController.dispose();
  }

  String getNameGroup() {
    String name = widget.messageGroupContact.groupName;
    if (name.length > 10) {
      return "${name.substring(0, 10)}...";
    }
    return name;
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showAddNew(
                      context: context,
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          di<MessageGroupService>()
                              .addMember(widget.messageGroupContact.groupId,
                                  emailController.text)
                              .then(
                            (value) {
                              if (value) {
                                toastification.show(
                                    closeButtonShowType:
                                        CloseButtonShowType.none,
                                    type: ToastificationType.success,
                                    style: ToastificationStyle.flat,
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    title: Text(
                                        "Add ${emailController.text} successfully!"));
                              } else {
                                toastification.show(
                                    closeButtonShowType:
                                        CloseButtonShowType.none,
                                    type: ToastificationType.error,
                                    style: ToastificationStyle.flat,
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    title: const Text("Add a member failed!"));
                              }
                            },
                          );
                        }
                      },
                      title: "Add a member",
                      hint: "Enter email",
                      textButton: "Add",
                      controller: emailController);
                },
                icon: const Icon(
                  CupertinoIcons.person_add,
                  color: CupertinoColors.inactiveGray,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) {
                      return MessageGroupSettingScreen(
                          messageGroupContact: widget.messageGroupContact);
                    },
                  ));
                },
                icon: const Icon(
                  CupertinoIcons.arrow_right_circle,
                  color: CupertinoColors.inactiveGray,
                ))
          ],
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  width: 40,
                  height: 40,
                  widget.messageGroupContact.groupPhotoURL,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondaryLabel,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        CupertinoIcons.person_3_fill,
                        color: CupertinoColors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                getNameGroup(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: CupertinoColors.extraLightBackgroundGray),
              ),
            ],
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
            Expanded(
              child: StreamBuilder<List<MessageEntity>>(
                  stream: di<MessageGroupService>().getMessageStreamByGroupId(
                      widget.messageGroupContact.groupId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Align(
                        child: CircularProgressIndicator(
                          color: CupertinoColors.inactiveGray,
                        ),
                      );
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent);
                      }
                    });
                    final messages = snapshot.data!;
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final time =
                            DateFormat().add_Hm().format(message.timeSent);
                        return Padding(
                          padding: message.senderId == userCurrent.uid
                              ? const EdgeInsets.only(right: 10, left: 60)
                              : const EdgeInsets.only(left: 10, right: 60),
                          child: Column(
                            children: [
                              message.senderId != userCurrent.uid
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        message.senderName,
                                        style: const TextStyle(
                                            color:
                                                CupertinoColors.inactiveGray),
                                      ),
                                    )
                                  : const SizedBox(),
                              Align(
                                alignment: message.senderId == userCurrent.uid
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: message.senderId ==
                                              userCurrent.uid
                                          ? const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10))
                                          : const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                      color: message.senderId == userCurrent.uid
                                          ? CupertinoColors.secondarySystemFill
                                          : CupertinoColors.activeGreen),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      message.content,
                                      style: const TextStyle(
                                          color: CupertinoColors
                                              .extraLightBackgroundGray),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: message.senderId == userCurrent.uid
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  time,
                                  style: const TextStyle(
                                      color: CupertinoColors.inactiveGray),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
            boxMessage()
          ],
        )),
      ),
    );
  }

  Widget boxMessage() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: messageController,
        style: const TextStyle(color: CupertinoColors.white),
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
            hintText: "Chat something...",
            suffixIcon: IconButton(
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  di<MessageGroupService>().sendMessage(
                      widget.messageGroupContact.groupId,
                      messageController.text);
                  messageController.clear();
                }
              },
              icon: const Icon(
                CupertinoIcons.arrowshape_turn_up_right_fill,
                color: CupertinoColors.inactiveGray,
              ),
            )),
      ),
    );
  }
}
