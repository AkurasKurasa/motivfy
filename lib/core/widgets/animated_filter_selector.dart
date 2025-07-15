import 'package:flutter/material.dart';

/// Animated filter selector for task filtering
class AnimatedFilterSelector extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionChanged;
  final Map<String, Color> optionColors;

  const AnimatedFilterSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionChanged,
    required this.optionColors,
  });

  @override
  State<AnimatedFilterSelector> createState() => _AnimatedFilterSelectorState();
}

class _AnimatedFilterSelectorState extends State<AnimatedFilterSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateCurrentIndex();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(AnimatedFilterSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      _updateCurrentIndex();
      _animateToCurrentIndex();
    }
  }

  void _updateCurrentIndex() {
    _previousIndex = _currentIndex;
    _currentIndex = widget.options.indexOf(widget.selectedOption);
  }

  void _animateToCurrentIndex() {
    if (_previousIndex == _currentIndex) return;
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isNarrow = screenWidth < 280;
        final isVeryNarrow = screenWidth < 240;

        // Adjust container height based on screen width
        final containerHeight = isVeryNarrow ? 42.0 : 48.0;

        return Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(containerHeight / 2),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          clipBehavior: Clip.antiAlias,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final optionWidth = maxWidth / widget.options.length;
              final selectedIndex = widget.options.indexOf(
                widget.selectedOption,
              );

              // Calculate proper positioning for centered indicator
              final indicatorPadding = isVeryNarrow ? 1.5 : 2.0;
              final indicatorHeight = containerHeight - (indicatorPadding * 2);
              final indicatorWidth = optionWidth - (indicatorPadding * 2);
              final indicatorLeft =
                  (selectedIndex * optionWidth) + indicatorPadding;

              return Stack(
                children: [
                  // Animated highlight indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    left: indicatorLeft,
                    top: indicatorPadding - 0.5,
                    height: indicatorHeight,
                    width: indicatorWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(
                          indicatorHeight / 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: _getFilterColor(
                            widget.options[selectedIndex],
                          ).withOpacity(0.20),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),

                  // Filter options
                  Row(
                    children: List.generate(widget.options.length, (index) {
                      final isSelected =
                          widget.selectedOption == widget.options[index];
                      final optionText = widget.options[index];

                      // Use shorter text for very narrow screens only
                      String displayText = optionText;
                      if (isVeryNarrow) {
                        switch (optionText) {
                          case 'All Tasks':
                            displayText = 'All';
                            break;
                          case 'Important':
                            displayText = 'Imp.';
                            break;
                          // 'Urgent' stays as is since it's short
                        }
                      } else if (isNarrow) {
                        switch (optionText) {
                          case 'All Tasks':
                            displayText = 'All';
                            break;
                          case 'Important':
                            displayText = 'Imp.';
                            break;
                        }
                      }

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.onOptionChanged(widget.options[index]);
                          },
                          child: Container(
                            height: containerHeight,
                            color: Colors.transparent,
                            child: Center(
                              child: _buildOptionContent(
                                optionText,
                                displayText,
                                isSelected,
                                isVeryNarrow,
                                isNarrow,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOptionContent(
    String originalText,
    String displayText,
    bool isSelected,
    bool isVeryNarrow,
    bool isNarrow,
  ) {
    // Determine layout based on screen width
    if (isVeryNarrow) {
      // Very narrow: Icon only or very short text
      if (displayText.length <= 4) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getFilterIcon(originalText),
              size: 12,
              color: isSelected
                  ? _getFilterColor(originalText)
                  : Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 1),
            Text(
              displayText,
              style: TextStyle(
                color: isSelected
                    ? _getFilterColor(originalText)
                    : Colors.white.withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 8,
              ),
            ),
          ],
        );
      } else {
        return Icon(
          _getFilterIcon(originalText),
          size: 16,
          color: isSelected
              ? _getFilterColor(originalText)
              : Colors.white.withOpacity(0.5),
        );
      }
    } else if (isNarrow) {
      // Narrow: smaller icon and text, but still horizontal layout
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getFilterIcon(originalText),
            size: 14,
            color: isSelected
                ? _getFilterColor(originalText)
                : Colors.white.withOpacity(0.5),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              displayText,
              style: TextStyle(
                color: isSelected
                    ? _getFilterColor(originalText)
                    : Colors.white.withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    } else {
      // Normal layout with icon and text side by side
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getFilterIcon(originalText),
            size: 16,
            color: isSelected
                ? _getFilterColor(originalText)
                : Colors.white.withOpacity(0.5),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              displayText,
              style: TextStyle(
                color: isSelected
                    ? _getFilterColor(originalText)
                    : Colors.white.withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    }
  }

  /// Get appropriate icon for each filter
  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'All Tasks':
        return Icons.all_inbox;
      case 'Urgent':
        return Icons.priority_high;
      case 'Important':
        return Icons.star;
      default:
        return Icons.list;
    }
  }

  /// Get color for each filter
  Color _getFilterColor(String filter) {
    return widget.optionColors[filter] ?? Colors.white;
  }
}
