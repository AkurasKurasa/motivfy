import 'package:flutter/material.dart';

class TabSelector extends StatefulWidget {
  final List<TabItem> tabs;
  final Function(int) onTabChanged;
  final int initialIndex;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color selectedTabColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const TabSelector({
    super.key,
    required this.tabs,
    required this.onTabChanged,
    this.initialIndex = 0,
    this.width = 220,
    this.height = 36,
    this.backgroundColor = const Color(0xFF333333),
    this.selectedTabColor = const Color(0xFF505050),
    this.borderColor = Colors.white10,
    this.borderWidth = 1.0,
    this.borderRadius = 20,
  });

  @override
  State<TabSelector> createState() => _TabSelectorState();
}

class _TabSelectorState extends State<TabSelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(() {
      widget.onTabChanged(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: widget.selectedTabColor,
              borderRadius: BorderRadius.circular(widget.borderRadius - 4),
            ),
            indicatorPadding: const EdgeInsets.symmetric(vertical: 4.0),
            dividerColor: Colors.transparent,
            tabs: widget.tabs.map((tab) => tab.buildTab()).toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            labelPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final Color selectedColor;
  final Color unselectedColor;
  final double iconSize;
  final double fontSize;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;
  final double height;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.white70,
    this.iconSize = 16,
    this.fontSize = 14,
    this.selectedFontWeight = FontWeight.w500,
    this.unselectedFontWeight = FontWeight.normal,
    this.height = 36,
  }) : assert(
         icon != null || customIcon != null,
         'Either icon or customIcon must be provided',
       );

  Widget buildTab() {
    return Tab(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, color: unselectedColor, size: iconSize)
            else if (customIcon != null)
              customIcon!,
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: unselectedColor, fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }
}
