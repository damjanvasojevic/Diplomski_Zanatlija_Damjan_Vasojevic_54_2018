import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MessagesScreen extends StatelessWidget {
  final String userId;

  const MessagesScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: Center(
        child: Text("Chat with user: $userId"),
      ),
    );
  }
}
