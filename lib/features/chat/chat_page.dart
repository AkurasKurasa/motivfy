import 'dart:async';
import 'package:flutter/material.dart';
import 'presentation/chat_header.dart';
import 'presentation/chat_list.dart';
import 'presentation/stop_generating_button.dart';
import 'presentation/chat_input_bar.dart';
import 'presentation/chat_drawer.dart';
import 'presentation/glassmorphic_background.dart';
import 'data/api_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      endDrawer: const ChatDrawer(),
      body: SafeArea(
        child: GlassmorphicBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Increased top spacer for more breathing room
              const SizedBox(height: 28),
              Builder(
                builder: (context) => ChatHeader(
                  onMenuPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ChatList(
                  messages: _messages,
                  scrollController: _scrollController,
                ),
              ),
              if (_isLoading) ...[
                StopGeneratingButton(onStop: _handleStop),
                const SizedBox(height: 8),
              ],
              // Input bar with extra bottom padding for home indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChatInputBar(
                  controller: _controller,
                  isLoading: _isLoading,
                  onSend: _handleSend,
                  autoFocus: _messages.isEmpty, // Auto focus when no messages
                ),
              ),
              const SizedBox(height: 32), // More space for nav/home indicator
            ],
          ),
        ),
      ),
    );
  }
}
