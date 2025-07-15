import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:motiv_fy/features/home/presentation/pages/home_page.dart';
import 'package:motiv_fy/features/launch/launch_page.dart';
import 'package:motiv_fy/features/chat/chat_page.dart';
import 'package:motiv_fy/features/notification/notification_page.dart';

class NavigationMenu extends StatefulWidget {
  final int initialActiveIndex;

  const NavigationMenu({super.key, this.initialActiveIndex = 0});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  late int activeIndex;

  @override
  void initState() {
    super.initState();
    activeIndex = widget.initialActiveIndex;
  }

  void onIconTap(int index) {
    setState(() {
      activeIndex = index;
    });

    // Navigate to different pages based on index
    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
        break;
      case 1: // Launch
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LaunchPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
        break;
      case 2: // Chat
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ChatPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
        break;
      case 3: // Notifications
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const NotificationPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double navHeight = screenHeight.clamp(95.0, 110.0);
    final double borderRadiusValue = screenWidth * 0.50;
    final double borderWidth = screenWidth * 0.006;
    final double iconSize = screenWidth * 0.06;
    final double fontSize = screenWidth * 0.03;

    List<IconData> icons = [
      Icons.home,
      Icons.rocket_launch,
      Icons.chat_bubble,
      Icons.notifications,
    ];

    List<String> labels = ['Home', 'Launch', 'Ai Chat', 'Notifications'];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.04,
        screenHeight * 0.015,
        screenWidth * 0.04,
        screenHeight * 0.03,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 33, sigmaY: 33),
          child: Container(
            height: navHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF1c1c1c).withOpacity(0.77),
              border: Border.all(
                color: const Color(0xFF636363),
                width: borderWidth,
              ),
              borderRadius: BorderRadius.circular(borderRadiusValue),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / icons.length;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(icons.length, (index) {
                    final isActive = index == activeIndex;

                    // Gradient to be reused
                    final gradient = const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFB32B), Color(0xFFFE9932)],
                    );

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onIconTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          height:
                              navHeight -
                              1, // Ensure fixed height with some padding
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Use min size to prevent overflow
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon with background and gradient when active
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 525),
                                    curve: Curves.fastEaseInToSlowEaseOut,
                                    width: isActive ? iconSize * 1.8 : 0,
                                    height: isActive ? iconSize * 1.8 : 0,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  isActive
                                      ? ShaderMask(
                                          shaderCallback: (bounds) =>
                                              gradient.createShader(bounds),
                                          blendMode: BlendMode.srcIn,
                                          child: Icon(
                                            icons[index],
                                            size: iconSize,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(
                                          icons[index],
                                          size: iconSize,
                                          color: Colors.grey,
                                        ),
                                ],
                              ),
                              SizedBox(height: 4), // Reduced spacing
                              isActive
                                  ? ShaderMask(
                                      shaderCallback: (bounds) =>
                                          gradient.createShader(
                                            Rect.fromLTWH(
                                              0,
                                              0,
                                              itemWidth,
                                              fontSize * 1.2,
                                            ),
                                          ),
                                      blendMode: BlendMode.srcIn,
                                      child: Text(
                                        labels[index],
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      labels[index],
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
