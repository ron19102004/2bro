class MessageEntity {
  final String content;
  final String senderId;
  final String receiveId;
  final DateTime timeSent;
  final String messageId;
  final String senderName;

  MessageEntity(
      {required this.content,
      required this.senderId,
      required this.receiveId,
      required this.timeSent,
      required this.messageId,
      required this.senderName});

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "senderId": senderId,
      "receiveId": receiveId,
      "messageId": messageId,
      "timeSent": timeSent.microsecondsSinceEpoch,
      "senderName": senderName
    };
  }

  factory MessageEntity.fromJson(Map<String, dynamic> data) {
    return MessageEntity(
        content: data["content"] ?? "",
        senderId: data["senderId"] ?? "",
        receiveId: data["receiveId"] ?? "",
        messageId: data["messageId"] ?? "",
        senderName: data["senderName"] ?? "",
        timeSent: DateTime.fromMicrosecondsSinceEpoch(data["timeSent"]));
  }
}
