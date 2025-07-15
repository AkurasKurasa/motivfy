import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motiv_fy/core/theme/app_colors.dart';
import 'package:motiv_fy/features/pomodoro/pomodoro_page.dart';
import 'package:motiv_fy/features/tasks/presentation/pages/task_creation_page.dart';
import 'package:motiv_fy/features/productivity_assistant/presentation/pages/productivity_assistant_page.dart';

class FeatureCard extends StatelessWidget {
  final String asset;
  final String label;
  final double iconSize;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.asset,
    required this.label,
    required this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final cardSize = screenWidth > 600 ? 135.0 : 125.0;
          final adjustedIconSize = screenWidth > 600 ? iconSize + 4 : iconSize;
          final textSize = screenWidth > 600 ? 13.0 : 12.0;

          return Container(
            width: cardSize,
            height: cardSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.white.withOpacity(0.1),
                        AppColors.white.withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryLightGray.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon - SVG or Material Icon
                      _buildIcon(asset, adjustedIconSize),
                      const SizedBox(height: 12),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: textSize,
                          height: 1.2,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(String asset, double size) {
    // Check if it's an SVG asset
    if (asset.endsWith('.svg')) {
      return SvgPicture.asset(
        asset,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(
          AppColors.white.withOpacity(0.8),
          BlendMode.srcIn,
        ),
      );
    } else {
      // Use Material Icons for non-SVG assets
      return Icon(
        _getIconForAsset(asset),
        size: size,
        color: AppColors.white.withOpacity(0.8),
      );
    }
  }

  IconData _getIconForAsset(String asset) {
    // Map asset names to appropriate Material icons
    switch (asset) {
      case 'timer.svg':
        return Icons.timer;
      case 'analyze.svg':
        return Icons.analytics;
      case 'block.svg':
        return Icons.block;
      case 'done.svg':
        return Icons.check_circle_outline;
      case 'procrastination_analysis':
        return Icons.psychology; // Brain/mind icon for analysis
      case 'block_list':
        return Icons.block; // Block icon for blocking distractions
      case 'done_list':
        return Icons.task_alt; // Checkmark with list for completed tasks
      default:
        return Icons.apps;
    }
  }
}
