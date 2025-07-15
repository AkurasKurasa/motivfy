import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';
import 'package:motiv_fy/features/tasks/presentation/pages/task_details_page.dart';

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
    _taskService = TaskService();
    _taskService.addListener(_updateCurrentTask);
  }

  @override
  void dispose() {
    _taskService.removeListener(_updateCurrentTask);
    super.dispose();
  }

  void _updateCurrentTask() {
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
    HapticFeedback.selectionClick();
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
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            final isNarrowScreen = availableWidth < 350;
                            final isVeryNarrowScreen = availableWidth < 280;

                            // Calculate responsive font size
                            double deadlineFontSize = 14;
                            double buttonFontSize = 14;

                            if (isVeryNarrowScreen) {
                              deadlineFontSize = 11;
                              buttonFontSize = 12;
                            } else if (isNarrowScreen) {
                              deadlineFontSize = 12;
                              buttonFontSize = 13;
                            }

                            if (isNarrowScreen) {
                              // Row layout for narrow screens with responsive containers
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Deadline container - flexible width
                                  Flexible(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            availableWidth *
                                            0.6, // 60% max width for deadline
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isVeryNarrowScreen ? 8 : 12,
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
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.white,
                                            size: isVeryNarrowScreen ? 12 : 14,
                                          ),
                                          SizedBox(
                                            width: isVeryNarrowScreen ? 4 : 6,
                                          ),
                                          Flexible(
                                            child: Text(
                                              currentTask.deadline != null
                                                  ? 'Due: ${_formatDateTime(currentTask.deadline!)}' +
                                                        (currentTask.deadlineTime !=
                                                                null
                                                            ? ' at ${_formatTimeToAmPm(currentTask.deadlineTime!)}'
                                                            : '')
                                                  : 'No Set Deadlines',
                                              style: TextStyle(
                                                color:
                                                    currentTask.deadline != null
                                                    ? _getDeadlineColor(
                                                        currentTask.deadline!,
                                                      )
                                                    : Colors.white70,
                                                fontSize: deadlineFontSize,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isVeryNarrowScreen ? 8 : 12),
                                  // View Full button
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(); // Close current dialog
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => TaskDetailsPage(
                                            task: currentTask,
                                          ),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black.withOpacity(
                                        0.4,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isVeryNarrowScreen ? 8 : 12,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'View Full',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: buttonFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            // Row layout for wider screens
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
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
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            currentTask.deadline != null
                                                ? 'Due: ${_formatDateTime(currentTask.deadline!)}' +
                                                      (currentTask.deadlineTime !=
                                                              null
                                                          ? ' at ${_formatTimeToAmPm(currentTask.deadlineTime!)}'
                                                          : '')
                                                : 'No Set Deadlines',
                                            style: TextStyle(
                                              color:
                                                  currentTask.deadline != null
                                                  ? _getDeadlineColor(
                                                      currentTask.deadline!,
                                                    )
                                                  : Colors.white70,
                                              fontSize: deadlineFontSize,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close current dialog
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TaskDetailsPage(task: currentTask),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black.withOpacity(
                                      0.4,
                                    ),
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
                                  child: Text(
                                    'View Full',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
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
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                const Icon(
                                  Icons.checklist,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'SUBTASKS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.checklist,
                                  color: Colors.blue,
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
      return const Center(
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
                _toggleSubtask(subtask.id, !subtask.isCompleted);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLinkContent() {
    if (currentTask.links == null || currentTask.links!.isEmpty) {
      return const Text(
        'No links provided',
        style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
      );
    }

    return Text(
      currentTask.links!,
      style: const TextStyle(
        color: Colors.blueAccent,
        fontSize: 14,
        decoration: TextDecoration.underline,
      ),
    );
  }

  // Helper methods for date/time formatting
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays > 1) {
      return 'in ${difference.inDays} days';
    } else {
      return '${-difference.inDays} days ago';
    }
  }

  Color _getDeadlineColor(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays < 0) {
      return Colors.red; // Overdue
    } else if (difference.inDays == 0) {
      return Colors.orange; // Due today
    } else if (difference.inDays <= 2) {
      return Colors.yellow; // Due soon
    } else {
      return Colors.green; // Not urgent
    }
  }

  String _formatTimeToAmPm(String timeStr) {
    // Handle range format like "10:00 - 12:00"
    if (timeStr.contains('-')) {
      final times = timeStr.split('-');
      return '${_convertToAmPm(times[0].trim())} - ${_convertToAmPm(times[1].trim())}';
    }
    // Handle single time format
    return _convertToAmPm(timeStr.trim());
  }

  String _convertToAmPm(String time) {
    // If already has AM/PM, return as is
    if (time.endsWith('AM') || time.endsWith('PM')) {
      return time;
    }

    try {
      // Parse hour and minute
      final parts = time.split(':');
      if (parts.length != 2)
        return time; // Return original if format is unexpected

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert hour to 12-hour format
      hour = hour % 12;
      if (hour == 0) hour = 12; // Convert 0 to 12 for midnight

      return '$hour:$minute $period';
    } catch (e) {
      return time; // Return original on error
    }
  }
}

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
