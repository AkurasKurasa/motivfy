import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Contains utility methods and constants for the TaskForm
class TaskFormUtils {
  /// Task Priority options
  static const List<String> priorityOptions = ['Normal', 'Important', 'Urgent'];

  /// Task Repeat options
  static const List<String> repeatOptions = [
    'Never',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  /// List of emoji options
  static const List<String> emojiOptions = [
    '📍',
    '📝',
    '😊',
    '⚡',
    '💡',
    '🧠',
    '⏳',
    '🚀',
    '😂',
    '🎉',
    '❤️',
    '👍',
    '👀',
    '💪',
    '🌟',
    '✨',
    '🔥',
    '💼',
    '📚',
    '🎯',
  ];

  /// List of animated emoji options
  static const List<String> animatedEmojiOptions = [
    'assets/AnimatedEmojis/Book Reading.json',
    'assets/AnimatedEmojis/LaptopWork.json',
    'assets/AnimatedEmojis/Play.json',
    'assets/AnimatedEmojis/Light Bulb.json',
    'assets/AnimatedEmojis/Happy.json',
    'assets/AnimatedEmojis/FlyMoney.json',
    'assets/AnimatedEmojis/Celebrate.json',
    'assets/AnimatedEmojis/Commute.json',
    'assets/AnimatedEmojis/Drive.json',
    'assets/AnimatedEmojis/Fire.json',
    'assets/AnimatedEmojis/Laugh.json',
    'assets/AnimatedEmojis/NervousAndShy.json',
    'assets/AnimatedEmojis/Raised Eyebrow Emoji.json',
    'assets/AnimatedEmojis/SunglassEmoji.json',
    'assets/AnimatedEmojis/Trophy.json',
  ];

  /// Format a DateTime to string
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format a TimeOfDay to string
  static String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Get color for priority
  static Color getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'important':
        return Colors.orange;
      case 'normal':
      default:
        return Color(0xFF717171);
    }
  }

  /// Show error message
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Widget for labeled form fields
class LabeledFormField extends StatelessWidget {
  final String label;
  final Widget child;
  final bool optional;

  const LabeledFormField({
    super.key,
    required this.label,
    required this.child,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (optional ? ' (Optional)' : ''),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Styled text field widget
class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;
  final double? height;
  final int? maxLines;
  final bool expands;

  const StyledTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.height,
    this.maxLines = 1,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        expands: expands,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

/// Date/Time picker field widget
class DateTimePickerField extends StatelessWidget {
  final String label;
  final String? displayText;
  final String hintText;
  final IconData icon;
  final VoidCallback onTap;

  const DateTimePickerField({
    super.key,
    required this.label,
    this.displayText,
    required this.hintText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(icon, color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    displayText ?? hintText,
                    style: TextStyle(
                      color: displayText != null
                          ? Colors.white
                          : Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Helper class for emoji-related widgets
class EmojiHelper {
  /// Build selected emoji display
  static Widget buildSelectedEmojiDisplay(
    bool showAnimatedEmojis,
    int selectedEmojiIndex,
    int selectedAnimatedEmojiIndex,
  ) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Center(
        child: showAnimatedEmojis
            ? Lottie.asset(
                TaskFormUtils.animatedEmojiOptions[selectedAnimatedEmojiIndex],
                width: 40,
                height: 40,
                repeat: true,
              )
            : Text(
                TaskFormUtils.emojiOptions[selectedEmojiIndex],
                style: const TextStyle(fontSize: 24),
              ),
      ),
    );
  }

  /// Build emoji type chip
  static Widget buildEmojiTypeChip(
    String label,
    bool isSelected,
    Function(bool) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade400,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Build emoji grid
  static Widget buildEmojiGrid(
    int selectedIndex,
    Function(int) onEmojiSelected,
  ) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 8,
      ),
      itemCount: TaskFormUtils.emojiOptions.length,
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onEmojiSelected(index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                TaskFormUtils.emojiOptions[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build animated emoji grid
  static Widget buildAnimatedEmojiGrid(
    int selectedIndex,
    Function(int) onEmojiSelected,
  ) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 8,
      ),
      itemCount: TaskFormUtils.animatedEmojiOptions.length,
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onEmojiSelected(index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Lottie.asset(
                TaskFormUtils.animatedEmojiOptions[index],
                width: 40,
                height: 40,
                repeat: true,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Debug print for troubleshooting
                  print(
                    'Failed to load animated emoji: ${TaskFormUtils.animatedEmojiOptions[index]}',
                  );
                  print('Error: $error');
                  // Fallback to a simple emoji
                  return const Text('📋', style: TextStyle(fontSize: 24));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
