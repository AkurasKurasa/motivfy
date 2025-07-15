import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LiquidFilterSelector extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionChanged;
  final Map<String, Color> optionColors;
  final Map<String, Color> selectedTextColors;

  const LiquidFilterSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionChanged,
    required this.optionColors,
    required this.selectedTextColors,
  });

  @override
  State<LiquidFilterSelector> createState() => _LiquidFilterSelectorState();
}

class _LiquidFilterSelectorState extends State<LiquidFilterSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateCurrentIndex();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(LiquidFilterSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      _updateCurrentIndex();
      _animateToCurrentIndex();
    }
  }

  void _updateCurrentIndex() {
    _previousIndex = _currentIndex;
    _currentIndex = widget.options.indexOf(widget.selectedOption);
    if (_currentIndex < 0) _currentIndex = 0;
  }

  void _animateToCurrentIndex() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getSelectedColor() {
    return widget.optionColors[widget.selectedOption] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double segmentWidth =
              constraints.maxWidth / widget.options.length;

          return Stack(
            children: [
              // Animated selector background
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Calculate slide position
                  final double slidePosition =
                      (_previousIndex +
                      (_currentIndex - _previousIndex) * _animation.value);

                  return Positioned(
                    left: slidePosition * segmentWidth,
                    top: 0,
                    bottom: 0,
                    width: segmentWidth,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: _getSelectedColor().withOpacity(0.3),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: _getSelectedColor().withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border.all(
                          color: _getSelectedColor().withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Option buttons row
              Row(
                children: List.generate(
                  widget.options.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          widget.onOptionChanged(widget.options[index]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.transparent,
                              width: 0,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.options[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                widget.selectedOption == widget.options[index]
                                ? widget.selectedTextColors[widget
                                          .options[index]] ??
                                      Colors.white
                                : widget.optionColors[widget.options[index]] ??
                                      Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
  }
}
