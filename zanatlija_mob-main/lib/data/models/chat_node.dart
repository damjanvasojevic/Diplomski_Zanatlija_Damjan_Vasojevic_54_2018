class ChatNode {
  final String id;
  final String userId;
  final String message;
  final String senderUsername;
  final int timeStampInMillis;
  const ChatNode({
    required this.id,
    required this.userId,
    required this.message,
    required this.timeStampInMillis,
    required this.senderUsername,
  });
  factory ChatNode.fromJson(Map<String, dynamic> json) => ChatNode(
        id: json['id'],
        userId: json['userId'],
        message: json['message'],
        senderUsername: json['senderUsername'],
        timeStampInMillis: json['timeStampInMillis'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'message': message,
        'senderUsername': senderUsername,
        'timeStampInMillis': timeStampInMillis,
      };
}
