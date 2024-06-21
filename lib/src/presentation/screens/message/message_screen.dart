import 'package:app_chat/src/data/entities/message_entity.dart';
import 'package:app_chat/src/data/services/message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/configs/dependencies_injection.dart';

class MessageScreen extends StatefulWidget {
  final String receiverId;
  final String photoURL;
  final String name;

  const MessageScreen(
      {super.key,
      required this.receiverId,
      required this.name,
      required this.photoURL});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final userCurrent = FirebaseAuth.instance.currentUser!;
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  widget.photoURL,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.name,
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
                  stream:
                      di<MessageService>().getMessagesStream(widget.receiverId),
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
                  di<MessageService>().sendMessage(
                      widget.receiverId, messageController.text, context);
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
