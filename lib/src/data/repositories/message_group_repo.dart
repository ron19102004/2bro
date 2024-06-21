import 'package:app_chat/src/data/entities/message_entity.dart';
import 'package:app_chat/src/data/entities/message_group_contact.dart';
import 'package:app_chat/src/data/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class MessageGroupRepository {
  void createGroup(String nameGroup);

  Future<MessageGroupContact?> findByGroupId(String groupId);

  void sendMessage(String groupId, String content, DateTime timeSent);

  Stream<List<MessageGroupContact>> getMessageGroupsContactStream();

  Stream<List<MessageEntity>> getMessageStreamByGroupId(String groupId);

  Future<bool> addMember(String groupId, String emailMember);

  void removeMember(String groupId, String memberId);

  void changeNameGroup(String groupId, String newName);

  Stream<List<UserEntity>> getUserGroupStream(String groupId);
}

class MessageGroupRepositoryImpl implements MessageGroupRepository {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final chatGroupCollection =
      FirebaseFirestore.instance.collection("chat_groups");

  @override
  void createGroup(String nameGroup) async {
    final user = FirebaseAuth.instance.currentUser!;
    final groupId = chatGroupCollection.doc().id;
    MessageGroupContact messageGroupContact = MessageGroupContact(
        groupName: nameGroup,
        groupId: groupId,
        groupPhotoURL:
            "https://static.vecteezy.com/system/resources/thumbnails/004/320/558/small_2x/group-icon-isolated-sign-symbol-illustration-five-people-gathered-icons-black-and-white-design-free-vector.jpg",
        quantityMember: 1);
    await chatGroupCollection.doc(groupId).set(messageGroupContact.toMap());
    await chatGroupCollection
        .doc(groupId)
        .collection("members")
        .doc(user.uid)
        .set({"memberId": user.uid});
    await userCollection
        .doc(user.uid)
        .collection("chat_groups")
        .doc(groupId)
        .set({"groupId": groupId});
  }

  @override
  Stream<List<MessageGroupContact>> getMessageGroupsContactStream() {
    final user = FirebaseAuth.instance.currentUser!;
    return userCollection
        .doc(user.uid)
        .collection("chat_groups")
        .snapshots()
        .asyncMap(
      (event) async {
        List<MessageGroupContact> messGC = [];
        for (var doc in event.docs) {
          String groupId = doc.data()["groupId"];
          final MessageGroupContact? item = await findByGroupId(groupId);
          if (item != null) {
            messGC.add(item);
          }
        }
        return messGC;
      },
    );
  }

  @override
  Future<MessageGroupContact?> findByGroupId(String groupId) async {
    final data = await chatGroupCollection.doc(groupId).get();
    if (!data.exists) {
      return null;
    }
    return MessageGroupContact.fromJson(data.data()!);
  }

  @override
  Stream<List<MessageEntity>> getMessageStreamByGroupId(String groupId) {
    return chatGroupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("timeSent")
        .snapshots()
        .asyncMap(
      (event) {
        List<MessageEntity> messages = [];
        for (var doc in event.docs) {
          final mess = MessageEntity.fromJson(doc.data());
          messages.add(mess);
        }
        return messages;
      },
    );
  }

  @override
  void sendMessage(String groupId, String content, DateTime timeSent) async {
    final user = FirebaseAuth.instance.currentUser!;
    final messagesCollection =
        chatGroupCollection.doc(groupId).collection("messages");
    final idMessage = messagesCollection.doc().id;
    await messagesCollection.doc(idMessage).set(MessageEntity(
            content: content,
            senderId: user.uid,
            receiveId: "",
            timeSent: timeSent,
            messageId: idMessage,
            senderName: user.displayName!)
        .toMap());
  }

  @override
  Future<bool> addMember(String groupId, String emailMember) async {
    final group = await chatGroupCollection.doc(groupId).get();
    final userMap =
        await userCollection.where('email', isEqualTo: emailMember).get();
    if (!(group.exists && userMap.docs.isNotEmpty)) {
      return false;
    }
    final user = UserEntity.fromJson(userMap.docs.first.data());
    final MessageGroupContact messageGroupContact =
        MessageGroupContact.fromJson(group.data()!);
    messageGroupContact.incrementMember();
    await chatGroupCollection.doc(groupId).set(messageGroupContact.toMap());
    await userCollection
        .doc(user.uid)
        .collection("chat_groups")
        .doc(groupId)
        .set({"groupId": groupId});
    await chatGroupCollection
        .doc(groupId)
        .collection("members")
        .doc(user.uid)
        .set({"memberId": user.uid});
    return true;
  }

  @override
  void removeMember(String groupId, String memberId) async {
    final group = await chatGroupCollection.doc(groupId).get();
    if (!(group.exists)) {
      return;
    }
    final MessageGroupContact messageGroupContact =
        MessageGroupContact.fromJson(group.data()!);
    messageGroupContact.decrementMember();
    await chatGroupCollection.doc(groupId).set(messageGroupContact.toMap());
    await chatGroupCollection.doc(groupId).collection("members").doc(memberId).delete();
    await userCollection
        .doc(memberId)
        .collection("chat_groups")
        .doc(groupId)
        .delete();
  }

  @override
  void changeNameGroup(String groupId, String newName) async {
    final group = await chatGroupCollection.doc(groupId).get();
    if (!(group.exists)) {
      return;
    }
    final MessageGroupContact messageGroupContact =
        MessageGroupContact.fromJson(group.data()!);
    messageGroupContact.setName(newName);
    await chatGroupCollection.doc(groupId).set(messageGroupContact.toMap());
  }

  @override
  Stream<List<UserEntity>> getUserGroupStream(String groupId) {
    return chatGroupCollection
        .doc(groupId)
        .collection("members")
        .snapshots()
        .asyncMap(
      (event) async {
        List<UserEntity> users = [];
        for (var doc in event.docs) {
          var userId = doc.data()["memberId"];
          final userMap = await userCollection.doc(userId).get();
          if (userMap.exists) {
            users.add(UserEntity.fromJson(userMap.data()!));
          }
        }
        return users;
      },
    );
  }
}
