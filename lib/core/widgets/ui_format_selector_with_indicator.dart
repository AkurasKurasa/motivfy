import 'package:flutter/material.dart';

class FormatSelectorWithIndicator extends StatelessWidget {
  final int selectedFormatIndex;
  final void Function(int) onFormatSelected;
  final Color indicatorColor;
  final Color backgroundColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;

  const FormatSelectorWithIndicator({
    super.key,
    required this.selectedFormatIndex,
    required this.onFormatSelected,
    this.indicatorColor = const Color(0xFF777777), // Default to grey.shade700
    this.backgroundColor = const Color(0xFF424242), // Default to grey.shade800
    this.selectedIconColor = Colors.white,
    this.unselectedIconColor = Colors.white60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 48,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: selectedFormatIndex * 43.0 + 4.0,
            child: Container(
              width: 39,
              height: 36,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Format options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFormatOption(
                Icons.format_align_left,
                selectedFormatIndex == 0,
                onTap: () => onFormatSelected(0),
              ),
              _buildFormatOption(
                Icons.format_align_center,
                selectedFormatIndex == 1,
                onTap: () => onFormatSelected(1),
              ),
              _buildFormatOption(
                Icons.format_align_right,
                selectedFormatIndex == 2,
                onTap: () => onFormatSelected(2),
              ),
              _buildFormatOption(
                Icons.format_align_justify,
                selectedFormatIndex == 3,
                onTap: () => onFormatSelected(3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption(
    IconData icon,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected ? selectedIconColor : unselectedIconColor,
          size: 20,
        ),
      ),
    );
  }
}
