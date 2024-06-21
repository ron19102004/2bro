class MessageGroupContact {
  String groupName;
  final String groupId;
  final String groupPhotoURL;
  int quantityMember;

  MessageGroupContact({
    required this.groupName,
    required this.groupId,
    required this.groupPhotoURL,
    required this.quantityMember,
  });

  Map<String, dynamic> toMap() {
    return {
      "groupName": groupName,
      "groupId": groupId,
      "groupPhotoURL": groupPhotoURL,
      "quantityMember": quantityMember,
    };
  }

  factory MessageGroupContact.fromJson(Map<String, dynamic> data) {
    return MessageGroupContact(
      groupName: data["groupName"] ?? "",
      groupId: data["groupId"] ?? "",
      groupPhotoURL: data["groupPhotoURL"] ?? "",
      quantityMember: data["quantityMember"] ?? "",
    );
  }

  void incrementMember() {
    quantityMember++;
  }

  void decrementMember() {
    quantityMember--;
  }

  void setName(String name) {
    groupName = name;
  }
}
