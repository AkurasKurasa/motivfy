import 'dart:async';
import 'package:flutter/material.dart';
import 'presentation/chat_header.dart';
import 'presentation/chat_list.dart';
import 'presentation/stop_generating_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/chat_input_bar.dart';
import 'presentation/chat_drawer.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      endDrawer: const ChatDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (context) => ChatHeader(
                onMenuPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
            Expanded(
              child: ChatList(
                messages: _messages,
                scrollController: _scrollController,
              ),
            ),
            if (_isLoading) StopGeneratingButton(onStop: _handleStop),
            ChatInputBar(
              controller: _controller,
              isLoading: _isLoading,
              onSend: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
