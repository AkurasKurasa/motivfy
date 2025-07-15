import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';

class TaskDetailPopup extends StatefulWidget {
  final Task task;

  const TaskDetailPopup({super.key, required this.task});

  @override
  State<TaskDetailPopup> createState() => _TaskDetailPopupState();
}

class _TaskDetailPopupState extends State<TaskDetailPopup> {
  late Task currentTask;
  late final TaskService _taskService;

  @override
  void initState() {
    super.initState();
    currentTask = widget.task;
    _taskService = TaskService(); // Get the singleton instance
    // Listen to task service changes to update the current task
    _taskService.addListener(_updateCurrentTask);
  }

  @override
  void dispose() {
    _taskService.removeListener(_updateCurrentTask);
    super.dispose();
  }

  void _updateCurrentTask() {
    // Find the updated task from the service
    final updatedTask = _taskService.getAllTasks().firstWhere(
      (task) => task.id == widget.task.id,
      orElse: () => widget.task,
    );

    if (mounted) {
      setState(() {
        currentTask = updatedTask;
      });
    }
  }

  void _toggleSubtask(String subtaskId, bool isCompleted) {
    print('🔄 Toggle called: $subtaskId -> $isCompleted');
    HapticFeedback.selectionClick(); // Add haptic feedback
    _taskService.updateSubtaskCompletion(
      currentTask.id,
      subtaskId,
      isCompleted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxDialogHeight = screenSize.height * 0.8;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: maxDialogHeight),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: currentTask.color.withOpacity(0.7),
                    width: 2,
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with deadline
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    currentTask.deadline != null
                                        ? 'Due: ${_formatDateTime(currentTask.deadline!)}' +
                                              (currentTask.deadlineTime != null
                                                  ? ' at ${_formatTimeToAmPm(currentTask.deadlineTime!)}'
                                                  : '')
                                        : 'No Set Deadlines',
                                    style: TextStyle(
                                      color: currentTask.deadline != null
                                          ? _getDeadlineColor(
                                              currentTask.deadline!,
                                            )
                                          : Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Full View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Main task details
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: currentTask.color.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildTaskIcon(),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                currentTask.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Date and Time
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    currentTask.date.toString().split(' ')[0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _formatTimeToAmPm(currentTask.time),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Description
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              currentTask.description != null &&
                                      currentTask.description!.isNotEmpty
                                  ? currentTask.description!
                                  : 'No description provided',
                              style: TextStyle(
                                color:
                                    currentTask.description != null &&
                                        currentTask.description!.isNotEmpty
                                    ? Colors.white
                                    : Colors.white70,
                                fontSize: 14,
                                fontStyle:
                                    currentTask.description != null &&
                                        currentTask.description!.isNotEmpty
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Subtasks section
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pin_drop,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  ' SUBTASKS ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.pin_drop,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildSubtasksList(),
                          ],
                        ),
                      ),

                      // Link section (if applicable)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Links & Resources',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildLinkContent(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskIcon() {
    if (currentTask.isAnimatedEmoji) {
      return SizedBox(
        width: 40,
        height: 40,
        child: Lottie.asset(currentTask.icon, repeat: true, animate: true),
      );
    } else {
      // For regular emoji (String)
      return Text(currentTask.icon, style: const TextStyle(fontSize: 30));
    }
  }

  Widget _buildSubtasksList() {
    if (currentTask.subtasks.isEmpty) {
      return Center(
        child: Text(
          'No subtasks for this task',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: currentTask.subtasks.length > 4 ? 200 : double.infinity,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: currentTask.subtasks.length > 4
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemCount: currentTask.subtasks.length,
        itemBuilder: (context, index) {
          final subtask = currentTask.subtasks[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              leading: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: subtask.isCompleted,
                  onChanged: (bool? value) {
                    print('📱 Checkbox changed: ${subtask.id} -> $value');
                    if (value != null) {
                      _toggleSubtask(subtask.id, value);
                    }
                  },
                  side: const BorderSide(color: Colors.white54, width: 2),
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.green;
                    }
                    return Colors.transparent;
                  }),
                ),
              ),
              title: Text(
                subtask.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  decoration: subtask.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  decorationColor: Colors.white54,
                ),
              ),
              onTap: () {
                print('📱 ListTile tapped: ${subtask.id}');
                _toggleSubtask(subtask.id, !subtask.isCompleted);
              },
            ),
          );
        },
      ),
    );
  }

  // Helper method to format DateTime for display
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    // Format date based on whether it's today, tomorrow, or another day
    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow';
    } else {
      // For other dates, use a full date format
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]}';
    }
  }

  // Helper method to check if a date is likely a default/placeholder value
  bool _isDefaultDate(DateTime date) {
    // Get the current date and time
    final now = DateTime.now();

    // Only consider the date a valid deadline if it's in the future or today
    // This assumes that deadlines are meaningful only if they're not in the past
    if (date.isAfter(now) || _isSameDay(date, now)) {
      return false; // This is a valid deadline
    }

    // Check for dates with non-zero hours/minutes which would indicate an intentionally set time
    if (date.hour != 0 || date.minute != 0) {
      return false; // This has a specific time set, likely intentional
    }

    // If we reach here, it's either a past date or a date with 00:00 time
    // which is likely a default
    return true;
  }

  // Helper to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Helper method to build link content
  Widget _buildLinkContent() {
    if (currentTask.links != null && currentTask.links!.isNotEmpty) {
      // Display the actual link with a clickable button
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              currentTask.links!,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.blue, size: 20),
            onPressed: () {
              // Handle opening the link
              // In a real app, you would use url_launcher package
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      );
    } else {
      // No link available
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: const Text(
              'No links and resources provided',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      );
    }
  }

  // Helper method to get appropriate color for the deadline text
  Color _getDeadlineColor(DateTime date) {
    if (_isDefaultDate(date)) {
      return Colors.white; // No deadline
    }

    final now = DateTime.now();

    // If deadline is today
    if (_isSameDay(date, now)) {
      // If it's within the next 3 hours
      if (date.difference(now).inHours < 3 && date.isAfter(now)) {
        return Colors.red; // Urgent - very soon
      }
      return Colors.orange; // Due today
    }

    // If deadline is tomorrow
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (_isSameDay(date, tomorrow)) {
      return Colors.yellow; // Due tomorrow
    }

    // If deadline is within the next 3 days
    if (date.difference(now).inDays < 3) {
      return Colors.green; // Coming up soon
    }

    // Future deadline
    return Colors.cyan; // Plenty of time
  }

  // Helper method to convert time from 24-hour to 12-hour format with AM/PM
  String _formatTimeToAmPm(String time24) {
    // Parse the time string (assuming format is "HH:MM" or "H:MM")
    final parts = time24.split(':');
    if (parts.length != 2)
      return time24; // Return original if not in expected format

    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];

    // Determine period
    final period = hour >= 12 ? 'PM' : 'AM';

    // Convert hour to 12-hour format
    hour = hour % 12;
    if (hour == 0) hour = 12; // Convert 0 to 12 for midnight

    return '$hour:$minute $period';
  }
}

// Helper function to show the dialog
void showTaskDetailPopup(BuildContext context, Task task) {
  HapticFeedback.lightImpact();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Task Details',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) =>
        TaskDetailPopup(task: task),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      );
    },
  );
}
