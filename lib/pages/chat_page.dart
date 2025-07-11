import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motivfy/services/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _stopRequested = false;
  bool _userIsAtBottom = true;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      const threshold = 100;
      setState(() {
        _userIsAtBottom = (maxScroll - current) < threshold;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _handleSend() async {
    final input = _controller.text.trim();
    if (input.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({"role": "user", "text": input});
      _messages.add({"role": "ai", "text": ""}); // Placeholder
      _isLoading = true;
      _stopRequested = false;
    });

    _controller.clear();

    try {
      final response = await ChatService.sendMessage(input);
      int index = _messages.lastIndexWhere((msg) => msg['role'] == 'ai');
      String animatedText = "";
      int charIndex = 0;

      _typingTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
        if (_stopRequested || charIndex >= response.length) {
          timer.cancel();
          setState(() => _isLoading = false);
          return;
        }

        setState(() {
          animatedText += response[charIndex];
          _messages[index]['text'] = animatedText;
        });

        if (_userIsAtBottom) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
        }

        charIndex++;
      });
    } catch (e) {
      setState(() {
        _messages.add({"role": "ai", "text": "⚠️ Error: ${e.toString()}"});
        _isLoading = false;
      });
    }
  }

  void _handleStop() {
    _stopRequested = true;
    _typingTimer?.cancel();
    setState(() {
      _isLoading = false;
    });
  }

  List<TextSpan> _buildStyledTextSpans(String text, bool isUser) {
  final baseColor = isUser ? const Color(0xFF888888) : const Color(0xFFCCCCCC);
  final lines = text.split('\n');

  return [
    for (int i = 0; i < lines.length; i++) ...[
      ..._styledLine(lines[i], baseColor),
      if (i != lines.length - 1) const TextSpan(text: '\n'), // only between lines
    ]
  ];
}

  List<TextSpan> _styledLine(String line, Color baseColor) {
    TextStyle style = GoogleFonts.quicksand(
      color: baseColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    if (line.startsWith('#### ')) {
      style = style.copyWith(fontSize: 18, fontWeight: FontWeight.bold);
      line = line.replaceFirst('#### ', '');
    } else if (line.startsWith('### ')) {
      style = style.copyWith(fontSize: 20, fontWeight: FontWeight.bold);
      line = line.replaceFirst('### ', '');
    } else if (line.startsWith('## ')) {
      style = style.copyWith(fontSize: 22, fontWeight: FontWeight.bold);
      line = line.replaceFirst('## ', '');
    } else if (line.startsWith('# ')) {
      style = style.copyWith(fontSize: 24, fontWeight: FontWeight.bold);
      line = line.replaceFirst('# ', '');
    }

    final parts = line.split('**');
    return [
      for (int i = 0; i < parts.length; i++)
        TextSpan(
          text: parts[i],
          style: i % 2 == 1
              ? style.copyWith(fontWeight: FontWeight.bold)
              : style,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFF181818),
          endDrawer: Drawer(
            backgroundColor: const Color(0xFF222222),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(
                      'Hi, John!',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Recent Chats',
                      style: GoogleFonts.inter(
                        color: Colors.white60,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Divider(color: Colors.white24, thickness: 1),

                  // CHAT LIST
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.chat_bubble_outline, color: Colors.white70),
                          title: Text(
                            'Chat ${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // Optional: Load selected chat
                          },
                        );
                      },
                    ),
                  ),

                  const Divider(color: Colors.white24, thickness: 1),

                  // NEW CHAT BUTTON
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A3A3A),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: Text(
                        'New Chat',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Optional: Clear current messages or navigate
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Chat One",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Builder(
                        builder: (innerContext) {
                          return IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Scaffold.of(innerContext).openEndDrawer();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // CHAT AREA
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['role'] == 'user';

                      return Container(
                        margin: EdgeInsets.only(
                          top: index == 0 ? 12 : 6,
                          bottom: index == _messages.length - 1 ? 12 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.9,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF232323)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: _buildStyledTextSpans(msg['text'] ?? '', isUser),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // "Stop Generating" Button
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Center(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: _handleStop,
                        icon: const Icon(Icons.stop),
                        label: const Text("Stop Generating"),
                      ),
                    ),
                  ),

                // INPUT BAR
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  color: const Color(0xFF181818), // Page background
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text input area
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 40, maxHeight: 120),
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "How can I help you?",
                                hintStyle: const TextStyle(color: Colors.white54),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Send button
                        _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Container(
                                margin: const EdgeInsets.only(bottom: 4), // align with text bottom
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white, // green accent, adjust as needed
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_upward, color: Color(0xFF181818), size: 24),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  onPressed: _handleSend,
                                ),
                              ),
                      ],
                    ),
                  ),
                )


              ],
            ),
          ),
        );
      },
    );
  }
}
