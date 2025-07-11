import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubble extends StatelessWidget {
  final bool isUser;
  final String text;
  final bool isFirst;
  final bool isLast;

  const MessageBubble({
    super.key,
    required this.isUser,
    required this.text,
    this.isFirst = false,
    this.isLast = false,
  });

  List<TextSpan> _buildStyledTextSpans(String text) {
    final baseColor = isUser ? const Color(0xFF888888) : const Color(0xFFCCCCCC);
    final lines = text.split('\n');

    return [
      for (int i = 0; i < lines.length; i++) ...[
        ..._styledLine(lines[i], baseColor),
        if (i != lines.length - 1) const TextSpan(text: '\n'),
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
    return Container(
      margin: EdgeInsets.only(
        top: isFirst ? 12 : 6,
        bottom: isLast ? 12 : 0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF232323) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: RichText(
          text: TextSpan(children: _buildStyledTextSpans(text)),
        ),
      ),
    );
  }
}
