import 'package:app_chat/src/data/entities/chat_contact.dart';
import 'package:app_chat/src/data/entities/message_entity.dart';
import 'package:app_chat/src/data/entities/user_entity.dart';
import 'package:app_chat/src/data/repositories/message_repo.dart';
import 'package:app_chat/src/data/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class MessageService {
  void sendMessage(String receiverId, String content, BuildContext context);

  Stream<List<ChatContact>> getChatContactsStream();

  Stream<List<MessageEntity>> getMessagesStream(String receiverId);

  void deleteContact(String receiverId);

}

class MessageServiceImpl implements MessageService {
  final MessageRepository messageRepository;
  final UserRepository userRepository;

  MessageServiceImpl(
      {required this.messageRepository, required this.userRepository});

  @override
  void sendMessage(
      String receiverId, String content, BuildContext context) async {
    try {
      DateTime timeSent = DateTime.now();
      UserEntity? receiver = await userRepository.findByUserId(receiverId);
      if (receiver == null) {
        return;
      }
      User userCurrent = FirebaseAuth.instance.currentUser!;
      UserEntity sender = UserEntity.fromUserAuth(userCurrent);
      messageRepository.saveMessageContact(sender, receiver, content, timeSent);
      final message = MessageEntity(
          content: content,
          senderId: sender.uid,
          receiveId: receiverId,
          timeSent: timeSent,
          messageId: messageRepository.getIdMessage(receiverId));
      messageRepository.sendMessage(message);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Stream<List<ChatContact>> getChatContactsStream() {
    return messageRepository.getChatContactsStream();
  }

  @override
  Stream<List<MessageEntity>> getMessagesStream(String receiverId) {
    return messageRepository.getMessagesStream(receiverId);
  }

  @override
  void deleteContact(String receiverId) {
    messageRepository.deleteContact(receiverId);
  }
}
