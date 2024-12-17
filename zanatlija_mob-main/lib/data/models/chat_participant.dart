class ChatParticipant {
  final String username;
  final String userId;
  const ChatParticipant({
    required this.username,
    required this.userId,
  });
  factory ChatParticipant.fromJson(Map<String, dynamic> json) =>
      ChatParticipant(
        username: json['username'],
        userId: json['userId'],
      );
  Map<String, dynamic> toJson() => {
        'username': username,
        'userId': userId,
      };
}
