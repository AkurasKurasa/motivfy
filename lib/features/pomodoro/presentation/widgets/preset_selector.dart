import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/services/pomodoro_service.dart';

/// Modern preset selector with glassmorphic design
class PresetSelector extends StatefulWidget {
  final PomodoroService pomodoroService;

  const PresetSelector({required this.pomodoroService, super.key});

  @override
  State<PresetSelector> createState() => _PresetSelectorState();
}

class _PresetSelectorState extends State<PresetSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPresetSelected(int index) {
    widget.pomodoroService.selectPreset(index);
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isVeryCompact = screenWidth < 350;
        final isCompact = screenWidth < 400;

        // Calculate optimal card width to fit all 4 presets
        final horizontalPadding = 24.0;
        final availableWidth = screenWidth - (horizontalPadding * 2);
        final spacing = isVeryCompact ? 6.0 : (isCompact ? 8.0 : 16.0);
        final totalSpacing = spacing * 3; // 3 gaps between 4 cards
        final optimalCardWidth = (availableWidth - totalSpacing) / 4;

        final cardWidth = isVeryCompact
            ? optimalCardWidth.clamp(70.0, 85.0)
            : isCompact
            ? optimalCardWidth.clamp(75.0, 90.0)
            : 120.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Quick Presets',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Preset chips - Responsive grid layout (no scrolling)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(widget.pomodoroService.presets.length, (
                  index,
                ) {
                  final preset = widget.pomodoroService.presets[index];
                  final isSelected =
                      widget.pomodoroService.selectedPresetIndex == index;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < widget.pomodoroService.presets.length - 1
                            ? (isVeryCompact ? 6 : 10)
                            : 0,
                      ),
                      child: _buildPresetChip(
                        preset: preset,
                        isSelected: isSelected,
                        onTap: () => _onPresetSelected(index),
                        cardWidth: cardWidth,
                        isVeryCompact: isVeryCompact,
                        isCompact: isCompact,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Reset All Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildResetButton(isCompact),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPresetChip({
    required PomodoroPreset preset,
    required bool isSelected,
    required VoidCallback onTap,
    required double cardWidth,
    required bool isVeryCompact,
    required bool isCompact,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = isSelected
            ? 1.0 + (_animationController.value * 0.05)
            : 1.0;

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isVeryCompact ? 16 : 20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isVeryCompact
                      ? 65 // Much smaller for tiny screens to prevent overflow
                      : (isCompact
                            ? 70 // Compact height for phones
                            : 75), // Moderate height for larger screens
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isSelected
                          ? [
                              Colors.white.withOpacity(
                                0.5,
                              ), // Even more opaque for better contrast
                              Colors.white.withOpacity(0.35),
                            ]
                          : [
                              Colors.white.withOpacity(
                                0.35,
                              ), // More opaque for unselected
                              Colors.white.withOpacity(0.25),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(
                      isVeryCompact ? 16 : 20,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withOpacity(0.8) // Stronger border
                          : Colors.white.withOpacity(0.5),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 0,
                            ),
                          ]
                        : [],
                  ),
                  padding: EdgeInsets.all(
                    isVeryCompact ? 3 : (isCompact ? 4 : 6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emoji icon
                      Text(
                        preset.icon,
                        style: TextStyle(
                          fontSize: isVeryCompact
                              ? 14
                              : (isCompact ? 16 : 18), // A bit larger emoji
                        ),
                      ),

                      SizedBox(height: 1),

                      // Preset name - MINIMAL DESIGN
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isVeryCompact ? 1 : 2,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          preset.name,
                          style: TextStyle(
                            fontSize: isVeryCompact
                                ? 8
                                : (isCompact ? 9 : 10), // A bit larger
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: 1),

                      // Duration info - MINIMAL DESIGN
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 1,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.85)
                              : Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${preset.workDuration.inMinutes}m / ${preset.breakDuration.inMinutes}m',
                          style: TextStyle(
                            fontSize: isVeryCompact
                                ? 7
                                : (isCompact ? 8 : 9), // A bit larger
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResetButton(bool isCompact) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.pomodoroService.resetAll();

        // Show confirmation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('Sessions and timer reset'),
                ],
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.black.withOpacity(0.8),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: isCompact ? 45 : 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.withOpacity(0.2),
                  Colors.red.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.red.shade300,
                    size: isCompact ? 18 : 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Reset All Sessions',
                    style: TextStyle(
                      fontSize: isCompact ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
