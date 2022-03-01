class MessageModel {
  String? senderId;
  String? sendBy;
  String? receiver;
  String? receiverId;
  String? dateTime;
  String? text;

  MessageModel({
    this.senderId,
    this.sendBy,
    this.receiver,
    this.receiverId,
    this.dateTime,
    this.text,
  });
  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    sendBy = json['sendBy'];
    receiver = json['receiver'];
    receiver = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'sendBy': sendBy,
      'received': receiver,
      'receivedId': receiverId,
      'dateTime': dateTime,
      'text': text,
    };
  }
}
