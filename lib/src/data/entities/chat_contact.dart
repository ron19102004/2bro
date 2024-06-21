class ChatContact {
  final String name;
  final String photoURL;
  final String uid;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact(
      {required this.uid,
      required this.photoURL,
      required this.name,
      required this.lastMessage,
      required this.timeSent});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "photoURL": photoURL,
      "name": name,
      "lastMessage": lastMessage,
      "timeSent": timeSent.microsecondsSinceEpoch
    };
  }

  factory ChatContact.fromJson(Map<String, dynamic> data) {
    return ChatContact(
        uid: data["uid"] ?? "",
        photoURL: data["photoURL"] ?? "",
        name: data["name"] ?? "",
        lastMessage: data["lastMessage"] ?? "",
        timeSent: DateTime.fromMicrosecondsSinceEpoch(data["timeSent"]));
  }
}
