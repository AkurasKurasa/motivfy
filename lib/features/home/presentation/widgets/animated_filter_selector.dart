import 'package:flutter/material.dart';

/// Represents a widget for selecting filters with animations.
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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateCurrentIndex();
  }

  @override
  void didUpdateWidget(AnimatedFilterSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      _updateCurrentIndex();
    }
  }

  void _updateCurrentIndex() {
    _currentIndex = widget.options.indexOf(widget.selectedOption);
    if (_currentIndex < 0) _currentIndex = 0;
  }

  Color _getSelectedColor() {
    return widget.optionColors[widget.selectedOption] ?? Colors.white;
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
                    duration: const Duration(
                      milliseconds: 200,
                    ), // Reduced from 300ms
                    curve: Curves.easeOutCubic,
                    left: indicatorLeft,
                    top: indicatorPadding - 0.5,
                    height: indicatorHeight,
                    width: indicatorWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getSelectedColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(
                          indicatorHeight / 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getSelectedColor().withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: _getSelectedColor().withOpacity(0.35),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),

                  // Option buttons
                  Row(
                    children: List.generate(
                      widget.options.length,
                      (index) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.onOptionChanged(widget.options[index]);
                          },
                          child: Container(
                            height: containerHeight,
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                _getDisplayText(
                                  widget.options[index],
                                  isVeryNarrow,
                                  isNarrow,
                                ),
                                style: TextStyle(
                                  color:
                                      widget.selectedOption ==
                                          widget.options[index]
                                      ? _getSelectedColor()
                                      : widget
                                                .optionColors[widget
                                                    .options[index]]
                                                ?.withOpacity(0.5) ??
                                            Colors.white.withOpacity(0.5),
                                  fontWeight:
                                      widget.selectedOption ==
                                          widget.options[index]
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  fontSize: isVeryNarrow
                                      ? 8
                                      : (isNarrow ? 10 : 13),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _getDisplayText(
    String originalText,
    bool isVeryNarrow,
    bool isNarrow,
  ) {
    if (isVeryNarrow) {
      switch (originalText) {
        case 'All Tasks':
          return 'All';
        case 'Important':
          return 'Imp.';
        default:
          return originalText;
      }
    } else if (isNarrow) {
      switch (originalText) {
        case 'All Tasks':
          return 'All';
        case 'Important':
          return 'Imp.';
        default:
          return originalText;
      }
    }
    return originalText;
  }
}
