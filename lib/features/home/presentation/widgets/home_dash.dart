import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/custom_widget.dart';
import 'package:motiv_fy/core/widgets/custom_task_progress.dart';
import 'package:motiv_fy/features/home/presentation/widgets/analytics_weekly_focus.dart';
import 'package:motiv_fy/core/widgets/animated_entry.dart';
import 'package:motiv_fy/features/home/presentation/widgets/circular_progress_widget.dart';
import 'package:motiv_fy/DummyData.dart';
import 'package:motiv_fy/features/home/presentation/widgets/saved_time_badge.dart';
import 'package:motiv_fy/core/widgets/date_button.dart';
import 'package:motiv_fy/core/widgets/view_all_button.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';
import 'package:motiv_fy/core/widgets/task_list.dart';
import 'package:motiv_fy/core/widgets/floating_arrow.dart';

/// Represents the dashboard view of the application.
class HomeDash extends StatefulWidget {
  const HomeDash({super.key});

  @override
  State<HomeDash> createState() => _HomeDashState();
}

class _HomeDashState extends State<HomeDash> with TickerProviderStateMixin {
  late AnimationController _arrowAnimationController;
  late Animation<double> _arrowAnimation;

  // Initialize with current date
  late String _selectedDate;
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();

    // Initialize arrow animation
    _arrowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _arrowAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _arrowAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the repeating animation
    _arrowAnimationController.repeat(reverse: true);

    // Register to listen for changes
    _taskService.addListener(_onTasksChanged);

    // Get current date formatted
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final month = months[now.month - 1];
    final day = now.day.toString().padLeft(2, '0');
    final year = now.year.toString();
    _selectedDate = '$month $day $year';
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    // Unregister listener when widget is disposed
    _taskService.removeListener(_onTasksChanged);
    super.dispose();
  }

  void _onTasksChanged() {
    // Trigger rebuild when tasks change to update arrow visibility
    if (mounted) {
      setState(() {
        print('HomeDash: Tasks changed, rebuilding to update arrow visibility');
      });
    }
  }

  void _onDateChanged(String newDate) {
    setState(() {
      _selectedDate = newDate;
      print('HomeDash date changed to: $newDate');
    });
  }

  // Parse date string in format "Month DD YYYY" to DateTime
  DateTime _parseSelectedDate(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length == 3) {
        final month = _getMonthNumber(parts[0]);
        final day = int.tryParse(parts[1]) ?? 1;
        final year = int.tryParse(parts[2]) ?? DateTime.now().year;
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return DateTime.now();
  }

  // Get month number from name
  int _getMonthNumber(String monthName) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return months[monthName] ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 12.0),
          child: Column(
            children: [
              AnimatedEntry(
                delay: 400,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final int savedHours = DummySavedTimeData.getSavedHours();
                    final availableWidth = constraints.maxWidth;
                    const spacing = 8.0;
                    const totalFlex = 9;
                    const leftFlex = 4;
                    const rightFlex = 5;

                    final leftBoxWidth =
                        (availableWidth - spacing) * leftFlex / totalFlex;
                    final rightBoxWidth =
                        (availableWidth - spacing) * rightFlex / totalFlex;
                    final rightBoxHeight = rightBoxWidth + 20;
                    final topLeftHeight = rightBoxHeight * 0.65;
                    final bottomLeftHeight =
                        rightBoxHeight - topLeftHeight - spacing;

                    final minDimension = [
                      leftBoxWidth,
                      topLeftHeight,
                    ].reduce((a, b) => a < b ? a : b);
                    final progressSize = minDimension > 50
                        ? minDimension * 0.7
                        : 50.0;

                    // ✅ Scale factor for large screens
                    final scaleFactor = constraints.maxWidth > 600 ? 0.85 : 1.0;

                    final leftBoxWidthScaled = leftBoxWidth * scaleFactor;
                    final rightBoxWidthScaled = rightBoxWidth * scaleFactor;
                    final topLeftHeightScaled = topLeftHeight * scaleFactor;
                    final bottomLeftHeightScaled =
                        bottomLeftHeight * scaleFactor;
                    final progressSizeScaled = progressSize * scaleFactor;

                    // ✅ Responsive height with clamping
                    final calculatedHeight = rightBoxWidthScaled * 1.1;
                    final rightBoxHeightScaled = calculatedHeight.clamp(
                      180.0,
                      screenHeight * 0.4,
                    );

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: leftBoxWidthScaled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomWidget(
                                width: leftBoxWidthScaled,
                                height: topLeftHeightScaled,
                                borderRadius: BorderRadius.circular(16),
                                borderColor: const Color(0xFF636363),
                                backgroundColor: Colors.black54,
                                foreground: Positioned.fill(
                                  child: Center(
                                    child: CircularProgressWidget(
                                      progress: 73,
                                      size: progressSizeScaled,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomWidget(
                                width: leftBoxWidthScaled,
                                height: bottomLeftHeightScaled,
                                borderRadius: BorderRadius.circular(16),
                                borderColor: const Color(0xFF636363),
                                backgroundColor: Colors.black54,
                                foreground: Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SavedTimeBadge(
                                      hoursSaved: savedHours,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: spacing),
                        SizedBox(
                          width: rightBoxWidthScaled,
                          height: rightBoxHeightScaled,
                          child: CustomWidget(
                            childWidget: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ), // Adjust as needed
                                child: AnalyticsWidget(
                                  barData: DummyAnalyticsData.getBarData(),
                                  days: DummyAnalyticsData.getDays(),
                                  legendItems:
                                      DummyAnalyticsData.getLegendItems(),
                                  timeLabel: DummyAnalyticsData.getTimeLabel(),
                                  streak: DummyAnalyticsData.getStreak(),
                                ),
                              ),
                            ),

                            width: rightBoxWidthScaled,
                            height: rightBoxHeightScaled,
                            borderRadius: BorderRadius.circular(16),
                            borderColor: const Color(0xFF636363),
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              AnimatedEntry(
                delay: 600,
                child: CustomTaskProgress(
                  completedTasks: 3,
                  totalTasks: 4,
                  width: double.infinity,
                  height: 45,
                  borderColor: const Color(0xFF636363),
                  borderWidth: 1.5,
                  borderRadius: 16,
                  padding: const EdgeInsets.all(10),
                  progressColor: const Color(0xFFCDFF3F),
                  progressBackgroundColor: Colors.grey,
                  textColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors
                        .white, // Explicitly add color to ensure it overrides any inherited styles
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedEntry(
                delay: 800,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const double taskItemHeight = 50.0;
                    const double taskItemSpacing = 8.0;
                    const int displayTaskCount = 5;
                    const double topRowHeight = 32.0;
                    const double topRowSpacing = 16.0;
                    const double verticalPadding = 16.0 * 2;

                    const double overflowAdjustment =
                        12.0; // Persistent overflow fix

                    final double calculatedHeight =
                        (taskItemHeight * displayTaskCount) +
                        (taskItemSpacing *
                            (displayTaskCount > 1 ? displayTaskCount - 1 : 0)) +
                        topRowHeight +
                        topRowSpacing +
                        verticalPadding +
                        overflowAdjustment;

                    return CustomWidget(
                      width: double.infinity,
                      height: calculatedHeight,
                      borderRadius: BorderRadius.circular(16),
                      borderWidth: 2,
                      borderOpacity: 1.0,
                      borderColor: const Color(0xFF636363),
                      backgroundColor: Colors.black54,
                      padding: const EdgeInsets.all(16.0),
                      foreground: Builder(
                        builder: (context) {
                          final taskCount = _taskService.getAllTasks().length;
                          print(
                            'Current task count: $taskCount',
                          ); // Debug print

                          return taskCount >= 7
                              ? Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: AnimatedBuilder(
                                    animation: _arrowAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                          0,
                                          _arrowAnimation.value,
                                        ),
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      childWidget: Column(
                        children: [
                          Row(
                            children: [
                              DateButton(
                                selectedDate: _selectedDate,
                                onDateChanged: _onDateChanged,
                              ),
                              const Spacer(),
                              ViewAllButton(selectedDate: _selectedDate),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Create TaskList directly without Builder to prevent unnecessary rebuilds
                          TaskList(
                            key: const ValueKey('home_task_list'),
                            taskCount: displayTaskCount,
                            selectedDate: _parseSelectedDate(_selectedDate),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}
