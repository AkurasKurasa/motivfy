import 'dart:ui';
import 'package:flutter/material.dart';
import 'glassmorphic_container.dart';
import '../core/chat_theme.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ChatTheme.drawerBackgroundGradient,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: ChatTheme.glassmorphicBackground,
              border: Border(
                left: BorderSide(color: ChatTheme.glassmorphicBorder, width: 1),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: GlassmorphicContainer(
                      padding: const EdgeInsets.all(20),
                      borderRadius: BorderRadius.circular(20),
                      opacity: 0.15,
                      blur: 15,
                      borderColor: ChatTheme.glassmorphicBorderSecondary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration:
                                    ChatTheme.getPrimaryAccentDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Color(0xFFB8B8FF),
                                          ],
                                        ).createShader(bounds),
                                    child: const Text(
                                      'Hi, John!',
                                      style: TextStyle(
                                        color: ChatTheme.primaryText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Ready to chat?',
                                    style: TextStyle(
                                      color: ChatTheme.secondaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Recent Chats Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: ChatTheme.secondaryText,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Chats',
                          style: TextStyle(
                            color: ChatTheme.secondaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Recent Chats List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 6,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GlassmorphicContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(16),
                          opacity: 0.1,
                          blur: 10,
                          borderColor: ChatTheme.glassmorphicBorder,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: ChatTheme.getChatBubbleDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Chat ${index + 1}',
                                        style: const TextStyle(
                                          color: ChatTheme.primaryText,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Last message preview...',
                                        style: TextStyle(
                                          color: ChatTheme.tertiaryText,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // New Chat Button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GlassmorphicContainer(
                      borderRadius: BorderRadius.circular(20),
                      opacity: 0.2,
                      blur: 15,
                      borderColor: ChatTheme.glassmorphicBorderSecondary,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  ChatTheme.primaryAccentGradient[0]
                                      .withOpacity(0.3),
                                  ChatTheme.primaryAccentGradient[1]
                                      .withOpacity(0.3),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ChatTheme.primaryText,
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: ChatTheme.primaryAccentGradient[1],
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'New Chat',
                                  style: TextStyle(
                                    color: ChatTheme.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
