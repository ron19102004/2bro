import 'package:app_chat/src/data/entities/message_entity.dart';
import 'package:app_chat/src/data/entities/message_group_contact.dart';
import 'package:app_chat/src/data/entities/user_entity.dart';
import 'package:app_chat/src/data/repositories/message_group_repo.dart';

abstract class MessageGroupService {
  void createGroup(String nameGroup);

  void sendMessage(String groupId, String content);

  Stream<List<MessageGroupContact>> getMessageGroupsContactStream();

  Stream<List<MessageEntity>> getMessageStreamByGroupId(String groupId);

  Future<bool> addMember(String groupId, String emailMember);

  void removeMember(String groupId, String memberId);

  void changeNameGroup(String groupId, String newName);

  Stream<List<UserEntity>> getUserGroupStream(String groupId);
}

class MessageGroupServiceImpl implements MessageGroupService {
  final MessageGroupRepository messageGroupRepository;

  MessageGroupServiceImpl({required this.messageGroupRepository});

  @override
  void createGroup(String nameGroup) {
    messageGroupRepository.createGroup(nameGroup);
  }

  @override
  Stream<List<MessageGroupContact>> getMessageGroupsContactStream() {
    return messageGroupRepository.getMessageGroupsContactStream();
  }

  @override
  Stream<List<MessageEntity>> getMessageStreamByGroupId(String groupId) {
    return messageGroupRepository.getMessageStreamByGroupId(groupId);
  }

  @override
  void sendMessage(String groupId, String content) {
    DateTime timeSent = DateTime.now();
    messageGroupRepository.sendMessage(groupId, content, timeSent);
  }

  @override
  Future<bool> addMember(String groupId, String emailMember) async {
    return await messageGroupRepository.addMember(groupId, emailMember);
  }

  @override
  void removeMember(String groupId, String memberId) {
    messageGroupRepository.removeMember(groupId, memberId);
  }

  @override
  void changeNameGroup(String groupId, String newName) {
    messageGroupRepository.changeNameGroup(groupId, newName);
  }

  @override
  Stream<List<UserEntity>> getUserGroupStream(String groupId) {
    return messageGroupRepository.getUserGroupStream(groupId);
  }
}
