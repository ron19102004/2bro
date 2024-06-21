import 'package:app_chat/src/data/entities/chat_contact.dart';
import 'package:app_chat/src/data/entities/message_entity.dart';
import 'package:app_chat/src/data/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class MessageRepository {
  void saveMessageContact(UserEntity sender, UserEntity receiver,
      String content, DateTime timeSent);

  void sendMessage(MessageEntity message);

  Stream<List<ChatContact>> getChatContactsStream();

  Stream<List<MessageEntity>> getMessagesStream(String receiverId);

  String getIdMessage(String receiverId);

  Query getQueryMessage(String receiverId);

  void deleteContact(String receiverId);
}

class MessageRepositoryImpl implements MessageRepository {
  final userCollection = FirebaseFirestore.instance.collection("users");

  @override
  void saveMessageContact(UserEntity sender, UserEntity receiver,
      String content, DateTime timeSent) async {
    //save contact for sender
    final contactSender = ChatContact(
        uid: receiver.uid,
        photoURL: receiver.photoURL ?? "",
        name: receiver.fullName ?? "Unknown",
        lastMessage: content,
        timeSent: timeSent);
    await userCollection
        .doc(sender.uid)
        .collection("chats")
        .doc(receiver.uid)
        .set(contactSender.toMap());
    //save contact for receiver
    final contactReceiver = ChatContact(
        uid: sender.uid,
        photoURL: sender.photoURL ?? "",
        name: sender.fullName ?? "Unknown",
        lastMessage: content,
        timeSent: timeSent);
    await userCollection
        .doc(receiver.uid)
        .collection("chats")
        .doc(sender.uid)
        .set(contactReceiver.toMap());
  }

  @override
  void sendMessage(MessageEntity message) async {
    //save message for sender
    await userCollection
        .doc(message.senderId)
        .collection("chats")
        .doc(message.receiveId)
        .collection("messages")
        .doc(message.messageId)
        .set(message.toMap());
    //save message for receiver
    await userCollection
        .doc(message.receiveId)
        .collection("chats")
        .doc(message.senderId)
        .collection("messages")
        .doc(message.messageId)
        .set(message.toMap());
  }

  @override
  Stream<List<ChatContact>> getChatContactsStream() {
    User user = FirebaseAuth.instance.currentUser!;
    return userCollection
        .doc(user.uid)
        .collection("chats")
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContact> chatContacts = [];
        for (var document in event.docs) {
          var chatContact = ChatContact.fromJson(document.data());
          var userMap = await userCollection.doc(chatContact.uid).get();
          var user = UserEntity.fromJson(userMap.data()!);
          chatContacts.add(ChatContact(
              uid: user.uid,
              photoURL: user.photoURL ?? chatContact.photoURL,
              name: user.fullName ?? chatContact.name,
              lastMessage: chatContact.lastMessage,
              timeSent: chatContact.timeSent));
        }
        return chatContacts;
      },
    );
  }

  @override
  Stream<List<MessageEntity>> getMessagesStream(String receiverId) {
    User user = FirebaseAuth.instance.currentUser!;
    return userCollection
        .doc(user.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy('timeSent', descending: false)
        .snapshots()
        .asyncMap(
      (event) async {
        List<MessageEntity> messages = [];
        for (var document in event.docs) {
          var mess = MessageEntity.fromJson(document.data());
          messages.add(mess);
        }
        return messages;
      },
    );
  }

  @override
  String getIdMessage(String receiverId) {
    User user = FirebaseAuth.instance.currentUser!;
    return userCollection
        .doc(user.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc()
        .id;
  }

  @override
  Query getQueryMessage(String receiverId) {
    User user = FirebaseAuth.instance.currentUser!;
    return userCollection
        .doc(user.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy('timeSent', descending: false)
        .limit(20);
  }

  @override
  void deleteContact(String receiverId) async {
    User user = FirebaseAuth.instance.currentUser!;
    await userCollection
        .doc(user.uid)
        .collection("chats")
        .doc(receiverId)
        .delete();
  }
}
