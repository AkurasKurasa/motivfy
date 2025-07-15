// ignore_for_file: unused_field

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- NEW import for HapticFeedback
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG support
import 'package:motiv_fy/core/constants/app_icons.dart';
// Import for navigation
import 'package:motiv_fy/features/tasks/presentation/pages/task_creation_page.dart';
import 'package:motiv_fy/features/settings/presentation/pages/settings_page.dart';
import 'package:motiv_fy/features/profile/presentation/pages/profile_page.dart';
import 'package:motiv_fy/features/pomodoro/pomodoro_page.dart';
import 'package:motiv_fy/features/productivity_assistant/presentation/pages/productivity_assistant_page.dart';

class SlideMenuButton extends StatefulWidget {
  final List<String> menuIcons;
  final Function(int index)? onSelect;
  final Function(String)? onIconSelected; // <-- NEW callback for icon selection
  final double idleSize;
  final double expandedSize;
  final double menuWidth;
  final double menuHeight;

  const SlideMenuButton({
    super.key,
    required this.menuIcons,
    this.onSelect,
    this.onIconSelected, // <-- NEW parameter
    this.idleSize = 75,
    this.expandedSize = 100,
    this.menuWidth = 60,
    this.menuHeight = 292,
  });

  @override
  State<SlideMenuButton> createState() => _SlideMenuButtonState();
}

class _SlideMenuButtonState extends State<SlideMenuButton>
    with SingleTickerProviderStateMixin {
  bool showMenu = false;
  int selectedIndex = -1;
  int _currentIconIndex = -1;
  Offset dragOffset = Offset.zero;

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  List<String> get fullIconList {
    if (widget.menuIcons.isEmpty) {
      return [AppIcons.noteFlow];
    }
    return widget.menuIcons;
  }

  double _calculateMenuHeight() {
    final int iconCount = fullIconList.length;
    const double baseIconSize = 45;
    const double expandedDelta = 13;
    const double spacing = 8;

    return iconCount * baseIconSize +
        (iconCount - 1) * spacing +
        expandedDelta +
        20;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF313131),
      end: const Color(0xFF313131),
    ).animate(curved);
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      showMenu = true;
      dragOffset = details.localPosition;
    });
    _controller.forward();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    dragOffset = details.localPosition;
    final itemHeight = 60.0;
    final newIndex = (dragOffset.dy ~/ itemHeight).clamp(
      0,
      fullIconList.length - 1,
    );

    if (newIndex != selectedIndex) {
      HapticFeedback.selectionClick(); // <-- NEW: Vibrate when sliding to new item
      setState(() {
        selectedIndex = newIndex;
      });
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (selectedIndex != -1) {
      _currentIconIndex = selectedIndex;
      if (widget.onSelect != null) {
        widget.onSelect!(selectedIndex);
      }
      if (widget.onIconSelected != null) {
        // <-- NEW: Trigger onIconSelected callback
        widget.onIconSelected!(fullIconList[selectedIndex]);
      }
    }

    setState(() {
      showMenu = false;
      selectedIndex = -1;
    });
    _controller.reverse();
  }

  void _showPopUp(BuildContext context, String iconPath) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );
        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          iconPath,
                          width: 60,
                          height: 60,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onLongPressStart: _onLongPressStart,
          onLongPressMoveUpdate: _onLongPressMoveUpdate,
          onLongPressEnd: _onLongPressEnd,
          onTap: () {
            final selectedIcon = _currentIconIndex == -1
                ? AppIcons.noteFlow
                : fullIconList[_currentIconIndex];

            if (selectedIcon == AppIcons.noteFlow) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskCreationPage(),
                ),
              );
            } else if (selectedIcon == AppIcons.settings) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            } else if (selectedIcon == AppIcons.profile) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else if (selectedIcon == AppIcons.pomodoroTimer) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PomodoroPage()),
              );
            } else if (selectedIcon == AppIcons.productivityAssistant) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductivityAssistantPage(),
                ),
              );
            } else {
              _showPopUp(context, selectedIcon);
            }
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final size = showMenu ? widget.expandedSize : widget.idleSize;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 5,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.white.withOpacity(0.015),
                      child: SvgPicture.asset(
                        showMenu && selectedIndex != -1
                            ? fullIconList[selectedIndex]
                            : _currentIconIndex != -1
                            ? fullIconList[_currentIconIndex]
                            : AppIcons.noteFlow,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (showMenu)
          Positioned(
            top: -(_calculateMenuHeight() + 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: widget.menuWidth,
                height: _calculateMenuHeight(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF313131),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(fullIconList.length * 2 - 1, (index) {
                    if (index.isOdd) return const SizedBox(height: 8);

                    final iconIndex = index ~/ 2;
                    final isSelected = iconIndex == selectedIndex;

                    final double bgSize = isSelected ? 58 : 45;
                    final double iconSize = isSelected ? 28 : 24;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      width: bgSize,
                      height: bgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[700]?.withOpacity(0.4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isSelected)
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: 1.0,
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    width: bgSize,
                                    height: bgSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.18),
                                        width: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.all(6.0),
                            child: SvgPicture.asset(
                              fullIconList[iconIndex],
                              width: iconSize,
                              height: iconSize,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
