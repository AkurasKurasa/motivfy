import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isWork;

  const DotIndicator({required this.isWork, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final isActive = (isWork && index == 0) || (!isWork && index == 1);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 14 : 8,
          height: isActive ? 14 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white30,
          ),
        );
      }),
    );
  }
}
