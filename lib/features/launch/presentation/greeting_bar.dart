import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:motiv_fy/core/theme/app_colors.dart';
import 'package:motiv_fy/core/services/universal_navigation_service.dart';

class GreetingBar extends StatelessWidget {
  const GreetingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final horizontalPadding = screenWidth > 600 ? 40.0 : 24.0;
        final fontSize = screenWidth > 600 ? 18.0 : 16.0;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryLightGray.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left-aligned greeting text
                    Expanded(
                      child: Text(
                        "Hello, John!",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                    // Close button
                    GestureDetector(
                      onTap: () =>
                          UniversalNavigationService.navigateToHome(context),
                      child: Icon(
                        Icons.close,
                        color: AppColors.white.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
