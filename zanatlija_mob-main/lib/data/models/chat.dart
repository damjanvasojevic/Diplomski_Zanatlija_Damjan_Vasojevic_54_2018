import 'package:zanatlija_app/data/models/chat_node.dart';
import 'package:zanatlija_app/data/models/chat_participant.dart';

class Chat {
  final List<ChatNode> chatNodes;
  final List<ChatParticipant> participants;
  final List<String> participantsIds;
  String id;

  Chat({
    required this.chatNodes,
    required this.participants,
    required this.participantsIds,
    this.id = '',
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chatNodes: (json['chatNodes'] as List<dynamic>)
            .map((e) => ChatNode.fromJson(e))
            .toList(),
        participants: (json['participants'] as List<dynamic>)
            .map((e) => ChatParticipant.fromJson(e))
            .toList(),
        participantsIds: (json['participantsIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'chatNodes': chatNodes.map((e) => e.toJson()),
        'participants': participants.map((e) => e.toJson()),
        'participantsIds': participantsIds.toList(),
        'id': id,
      };
}
