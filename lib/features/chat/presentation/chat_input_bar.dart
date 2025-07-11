import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: const Color(0xFF181818),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text input
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40, maxHeight: 120),
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "How can I help you?",
                    hintStyle: TextStyle(color: Colors.white54),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward, color: Color(0xFF181818), size: 24),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: onSend,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
