class Message {
  final String senderId;
  final String receiverId;
  final String content;
  final String messageID;
  final DateTime sentTime;
  final MessageType messageType;
  final bool isLiked;
  final bool unread;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.messageID,
    required this.sentTime,
    required this.content,
    required this.messageType,
    required this.isLiked,
    required this.unread,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        messageID: json['messageId'],
        sentTime: json['sentTime'].toDate(),
        content: json['content'],
        messageType: MessageType.fromJson(json['messageType']),
        isLiked: json['isLiked'],
        unread: json['unread'],
      );

  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'senderId': senderId,
        'messageId': messageID,
        'sentTime': sentTime,
        'content': content,
        'messageType': messageType.toJson(),
        'isLiked': false,
        'unread': true,
      };
}

enum MessageType {
  text,
  image;

  String toJson() => name;

  factory MessageType.fromJson(String json) => values.byName(json);
}
