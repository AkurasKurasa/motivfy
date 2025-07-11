import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'message_bubble.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, String>> messages;
  final ScrollController scrollController;

  const ChatList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isUser = msg['role'] == 'user';

        return MessageBubble(
          isUser: isUser,
          text: msg['text'] ?? '',
          isFirst: index == 0,
          isLast: index == messages.length - 1,
        );
      },
    );
  }
}
