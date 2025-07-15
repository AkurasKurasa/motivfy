import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motiv_fy/core/widgets/custom_widget.dart';
import 'package:motiv_fy/core/widgets/task_popup.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';

class TaskItem extends StatefulWidget {
  final dynamic icon; // Can be IconData, String (emoji), or Lottie asset path
  final String title;
  final String time;
  final Color color;
  final bool isUrgent;
  final bool isImportant;
  final bool isAnimatedEmoji;
  final Task task;

  const TaskItem({
    super.key,
    required this.task,
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
    this.isUrgent = false,
    this.isImportant = false,
    this.isAnimatedEmoji = false,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _offsetAnim;
  late Animation<double> _fadeAnim;
  bool _checked = false;
  bool _isAnimating = false;
  late String
  _taskId; // Store the task ID to track if this widget is for the same task

  @override
  void initState() {
    super.initState();
    _taskId = widget.task.id; // Store the initial task ID
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 525,
      ), // Faster individual animation
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );
    _offsetAnim = Tween<Offset>(begin: Offset.zero, end: const Offset(2.0, 0))
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );
    _fadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Archive immediately when animation completes
        if (mounted && _taskId == widget.task.id) {
          // Only archive if this widget still represents the same task
          TaskService().archiveTask(_taskId);
          setState(() {
            _isAnimating = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If we're animating, completely prevent any widget updates
    // to preserve the animation state
    if (_isAnimating) {
      return;
    }

    // If this is actually a different task (different ID),
    // then it's safe to update
    if (_taskId != widget.task.id) {
      // This widget is now representing a different task
      _taskId = widget.task.id;
      _checked = false;
      _isAnimating = false;
      _controller.reset();
    }
  }

  void _onCheckPressed() {
    if (_isAnimating) return; // Prevent multiple clicks during animation
    if (_taskId != widget.task.id)
      return; // Safety check - ensure we're still the right task

    setState(() {
      _checked = true;
      _isAnimating = true;
    });
    _controller.forward();
  }

  // Convert 24-hour format to AM/PM format
  String _formatTimeToAmPm(String timeStr) {
    // Handle range format like "10:00 - 12:00"
    if (timeStr.contains('-')) {
      final times = timeStr.split('-');
      return '${_convertToAmPm(times[0].trim())} - ${_convertToAmPm(times[1].trim())}';
    }
    // Handle single time format
    return _convertToAmPm(timeStr.trim());
  }

  // Helper method to convert a single time
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
      if (hour == 0) hour = 12; // 0 hour in 24-hour is 12 AM

      return '$hour:$minute $period';
    } catch (e) {
      return time; // Return original on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutQuart,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: SlideTransition(
            position: _offsetAnim,
            child: Dismissible(
              key: Key(widget.task.id),
              direction: DismissDirection.endToStart,
              dismissThresholds: const {DismissDirection.endToStart: 0.4},
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.red.withOpacity(0.3),
                      Colors.red.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                // Show confirmation dialog
                return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF1E1E1E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'Delete Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to delete "${widget.title}"?\n\nThis task will be moved to recently deleted.',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ) ??
                    false;
              },
              onDismissed: (direction) {
                // Delete the task and move to recently deleted
                TaskService().deleteTask(widget.task.id);

                // Show snackbar with undo option
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.title} moved to recently deleted',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF2D2D2D),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.blue,
                      onPressed: () {
                        // Restore the task
                        TaskService().restoreTask(widget.task.id);
                      },
                    ),
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              child: GestureDetector(
                onTap: () => showTaskDetailPopup(context, widget.task),
                child: CustomWidget(
                  height: 50,
                  borderRadius: BorderRadius.circular(12.0),
                  borderColor: widget.color,
                  borderWidth: 1.5,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  childWidget: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final showFullTime = constraints.maxWidth > 280;
                        return Row(
                          children: [
                            // Display either animated emoji, emoji text, or icon
                            widget.isAnimatedEmoji
                                ? SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Lottie.asset(
                                      widget.icon as String,
                                      repeat: true,
                                      animate: true,
                                    ),
                                  )
                                : widget.icon is String
                                ? Text(
                                    widget.icon,
                                    style: const TextStyle(fontSize: 20),
                                  ) // Reduced font size
                                : Icon(
                                    widget.icon as IconData,
                                    color: Colors.white,
                                    size: 18,
                                  ), // Reduced size
                            const SizedBox(width: 8.0), // Reduced width
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13, // Reduced font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  if (widget.isUrgent || widget.isImportant)
                                    Row(
                                      children: [
                                        if (widget.isUrgent)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 2,
                                            ), // Reduced margin
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3, // Reduced padding
                                              vertical: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(
                                                0.3,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    3,
                                                  ), // Reduced radius
                                              border: Border.all(
                                                color: Colors.red.withOpacity(
                                                  0.6,
                                                ),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: const Text(
                                              'URGENT',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize:
                                                    8, // Reduced font size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        if (widget.isImportant)
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                              3,
                                              1,
                                              1,
                                              1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withOpacity(
                                                0.3,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    3,
                                                  ), // Reduced radius
                                              border: Border.all(
                                                color: Colors.amber.withOpacity(
                                                  0.6,
                                                ),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: const Text(
                                              'IMPORTANT',
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontSize:
                                                    8, // Reduced font size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(6, 4, 3, 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  // Convert to AM/PM format
                                  showFullTime
                                      ? _formatTimeToAmPm(widget.time)
                                      : _formatTimeToAmPm(
                                          widget.time.split(' - ')[0].trim(),
                                        ),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10, // Reduced font size
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ), // Significantly increased spacing before divider to move both divider and checkbox much further right
                            const VerticalDivider(
                              color: Colors.white24,
                              thickness:
                                  2, // Made thicker to see the movement better
                              width:
                                  6, // Increased divider width to make it more visible
                              indent: 8,
                              endIndent: 8,
                            ),
                            // Removed spacing after divider to bring line closer to checkbox
                            GestureDetector(
                              onTap: _checked ? null : _onCheckPressed,
                              child: Container(
                                width:
                                    28, // Increased touch area to meet accessibility standards
                                height:
                                    28, // Increased touch area to meet accessibility standards
                                alignment: Alignment
                                    .centerRight, // Align checkbox to the left within the touch area to bring it closer to divider
                                child: Container(
                                  width: 25, // Slightly larger visual checkbox
                                  height: 25, // Slightly larger visual checkbox
                                  decoration: BoxDecoration(
                                    color: _checked
                                        ? Colors.green
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(
                                      color: _checked
                                          ? Colors.green
                                          : Colors.white.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _checked
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
