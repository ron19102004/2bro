import 'package:app_chat/src/data/entities/chat_contact.dart';
import 'package:app_chat/src/data/entities/message_group_contact.dart';
import 'package:app_chat/src/data/services/message_group_service.dart';
import 'package:app_chat/src/data/services/message_service.dart';
import 'package:app_chat/src/presentation/screens/message/message_group_screen.dart';
import 'package:app_chat/src/presentation/screens/message/message_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/configs/dependencies_injection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        appBar: AppBar(
          backgroundColor: CupertinoColors.darkBackgroundGray,
          title: const TabBar(
              indicatorColor: CupertinoColors.activeGreen,
              dividerColor: CupertinoColors.quaternaryLabel,
              labelColor: CupertinoColors.activeGreen,
              tabs: [
                Tab(
                  child: Text(
                    "Contacts",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "Groups",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ]),
        ),
        body: TabBarView(children: [contactsWidget(), groupsWidget()]),
      ),
    );
  }

  Widget groupsWidget() {
    return SafeArea(
      child: StreamBuilder<List<MessageGroupContact>>(
          stream: di<MessageGroupService>().getMessageGroupsContactStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final groups = snapshot.data!;
              return ListView.builder(
                controller: scrollController,
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) {
                            return MessageGroupScreen(messageGroupContact: group);
                          },
                        ));
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          group.groupPhotoURL,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              padding: const EdgeInsets.all(15),
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
                      title: Text(
                        group.groupName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: CupertinoColors.extraLightBackgroundGray),
                      ),
                      trailing: Text(
                        "${group.quantityMember} members",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 13, color: CupertinoColors.inactiveGray),
                      ),
                    ),
                  );
                },
              );
            }
            return const Align(
              child: CircularProgressIndicator(
                color: CupertinoColors.inactiveGray,
              ),
            );
          }),
    );
  }

  Widget contactsWidget() {
    return SafeArea(
      child: StreamBuilder<List<ChatContact>>(
          stream: di<MessageService>().getChatContactsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final chatContacts = snapshot.data!;
              return ListView.builder(
                controller: scrollController,
                itemCount: chatContacts.length,
                itemBuilder: (context, index) {
                  final chatContactItem = chatContacts[index];
                  return ListTile(
                    onLongPress: () {
                      showMenu(context, chatContactItem.uid);
                    },
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(
                        builder: (context) {
                          return MessageScreen(
                              receiverId: chatContactItem.uid,
                              name: chatContactItem.name,
                              photoURL: chatContactItem.photoURL);
                        },
                      ));
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(chatContactItem.photoURL),
                    ),
                    title: Text(
                      chatContactItem.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: CupertinoColors.extraLightBackgroundGray),
                    ),
                    subtitle: Text(
                      chatContactItem.lastMessage,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 15, color: CupertinoColors.inactiveGray),
                    ),
                    trailing: Text(
                      DateFormat().add_Hm().format(chatContactItem.timeSent),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 13, color: CupertinoColors.inactiveGray),
                    ),
                  );
                },
              );
            }
            return const Align(
              child: CircularProgressIndicator(
                color: CupertinoColors.inactiveGray,
              ),
            );
          }),
    );
  }

  void showMenu(BuildContext context, String receiverId) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: CupertinoColors.extraLightBackgroundGray,
          content: Container(
            decoration: BoxDecoration(
                color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Actions",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CupertinoButton(
                    color: CupertinoColors.activeGreen,
                    child: const Text(
                      "Delete contact",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    onPressed: () {
                      di<MessageService>().deleteContact(receiverId);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
