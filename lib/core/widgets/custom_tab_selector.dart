import 'dart:ui';
import 'package:flutter/material.dart';

class CustomTabSelector extends StatefulWidget {
  final List<String> tabs;
  final int initialIndex;
  final ValueChanged<int> onTabChanged;

  final double? height;
  final double? width;
  final double borderRadius;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final TextStyle? textStyle;
  final Color underlineColor;
  final double underlineThickness;
  final Duration animationDuration;

  const CustomTabSelector({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    required this.onTabChanged,
    this.height,
    this.width,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
    this.backgroundColor = Colors.black,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.grey,
    this.textStyle,
    this.underlineColor = Colors.grey,
    this.underlineThickness = 2.0,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  @override
  State<CustomTabSelector> createState() => _CustomTabSelectorState();
}

class _CustomTabSelectorState extends State<CustomTabSelector> {
  late int selectedIndex;
  double _indicatorLeft = 0.0;
  double _indicatorWidth = 0.0;
  final List<GlobalKey> _tabKeys = [];
  final GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    selectedIndex = widget.initialIndex;
    _tabKeys.addAll(List.generate(widget.tabs.length, (_) => GlobalKey()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateIndicatorPosition(selectedIndex);
    });
    super.initState();
  }

  void _updateIndicatorPosition(int index) {
    final RenderBox stackBox =
        _stackKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox tabBox =
        _tabKeys[index].currentContext!.findRenderObject() as RenderBox;
    final Offset tabPosition = tabBox.localToGlobal(
      Offset.zero,
      ancestor: stackBox,
    );

    const double extraPadding = 12.0;

    setState(() {
      _indicatorLeft = tabPosition.dx - extraPadding / 2;
      _indicatorWidth = tabBox.size.width + extraPadding;
    });
  }

  void _onTabTap(int index) {
    if (index != selectedIndex) {
      setState(() {
        selectedIndex = index;
      });
      widget.onTabChanged(index);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateIndicatorPosition(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedWidth = widget.width ?? screenWidth * 0.5;
    final calculatedHeight = widget.height ?? 60.0;
    final paddingHorizontal = widget.padding.left + widget.padding.right;
    final effectiveWidth = calculatedWidth - paddingHorizontal;
    final tabCount = widget.tabs.length;
    final baseTabWidth = effectiveWidth / tabCount;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: calculatedWidth,
        height: calculatedHeight,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Padding(
          padding: widget.padding,
          child: Stack(
            key: _stackKey,
            clipBehavior: Clip.hardEdge,
            children: [
              // Indicator behind the text
              AnimatedPositioned(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                left: _indicatorLeft,
                top: 0,
                child: AnimatedContainer(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  width: _indicatorWidth,
                  height: calculatedHeight - widget.padding.vertical,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.015),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        color: Colors.white.withOpacity(
                          0.015,
                        ), // subtle frost layer
                      ),
                    ),
                  ),
                ),
              ),
              // Tab labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(tabCount, (index) {
                  final isSelected = index == selectedIndex;
                  return SizedBox(
                    width: baseTabWidth,
                    child: GestureDetector(
                      onTap: () => _onTabTap(index),
                      child: Center(
                        child: Container(
                          key: _tabKeys[index],
                          child: AnimatedDefaultTextStyle(
                            duration: widget.animationDuration,
                            style:
                                (widget.textStyle ??
                                        const TextStyle(fontSize: 16))
                                    .copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? widget.selectedTextColor
                                          : widget.unselectedTextColor,
                                    ),
                            child: Text(widget.tabs[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
