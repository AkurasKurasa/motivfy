import 'package:flutter/material.dart';
import 'package:motiv_fy/features/tasks/presentation/widgets/task_item.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';

class TaskList extends StatefulWidget {
  final int taskCount;
  final String filter;
  final DateTime? selectedDate;

  const TaskList({
    super.key,
    this.taskCount = 5,
    this.filter = 'All Tasks',
    this.selectedDate,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> with TickerProviderStateMixin {
  final TaskService _taskService = TaskService();
  late AnimationController _repositionController;
  List<String> _previousTaskIds = [];
  bool _isAnimatingReposition = false;
  String? _removedTaskId; // Track which task was removed
  int _removedTaskIndex = -1; // Track the index of the removed task

  @override
  void initState() {
    super.initState();
    print('REAL TaskList: initState called - Setting up animations');

    // Set up animation controller
    _repositionController = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ), // Faster repositioning for better performance
      vsync: this,
    );

    // Initialize with current tasks
    final initialTasks = widget.selectedDate != null
        ? _taskService.getTasksForDate(widget.selectedDate!)
        : _taskService.getAllTasks();
    _previousTaskIds = initialTasks.map((task) => task.id).toList();
    print('REAL TaskList: Initial task IDs: $_previousTaskIds');

    // Listen for changes in tasks
    _taskService.addListener(_onTasksChanged);

    // Start with animation completed
    _repositionController.value = 1.0;
  }

  @override
  void dispose() {
    _repositionController.dispose();
    // Clean up listener
    _taskService.removeListener(_onTasksChanged);
    super.dispose();
  }

  void _onTasksChanged() {
    print('REAL TaskList: _onTasksChanged called!');
    if (!mounted) return;

    // Get current tasks
    final currentTasks = widget.selectedDate != null
        ? _taskService.getTasksForDate(widget.selectedDate!)
        : _taskService.getAllTasks();
    final currentTaskIds = currentTasks.map((task) => task.id).toList();

    print('REAL TaskList: Previous IDs: $_previousTaskIds');
    print('REAL TaskList: Current IDs: $currentTaskIds');

    // Detect if tasks were removed and track which one
    if (currentTaskIds.length < _previousTaskIds.length &&
        !_isAnimatingReposition) {
      // Find which task was removed and its index
      for (int i = 0; i < _previousTaskIds.length; i++) {
        if (!currentTaskIds.contains(_previousTaskIds[i])) {
          _removedTaskId = _previousTaskIds[i];
          _removedTaskIndex = i;
          print(
            'REAL TaskList: Task removed at index $_removedTaskIndex (ID: $_removedTaskId)',
          );
          break;
        }
      }

      print('REAL TaskList: *** STARTING REPOSITION ANIMATION ***');
      _isAnimatingReposition = true;
      _repositionController.reset();
      _repositionController.forward().then((_) {
        if (mounted) {
          print('REAL TaskList: *** ANIMATION COMPLETED ***');
          _isAnimatingReposition = false;
          _removedTaskId = null;
          _removedTaskIndex = -1;
        }
      });
    }

    _previousTaskIds = currentTaskIds;

    // Refresh the UI when tasks change
    setState(() {
      print('REAL TaskList: setState called - triggering rebuild');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get tasks from service and filter by date if selectedDate is provided
    final List<Task> serviceTasks = widget.selectedDate != null
        ? _taskService.getTasksForDate(widget.selectedDate!)
        : _taskService.getAllTasks();

    print(
      'TaskList selected date: ${widget.selectedDate}, found ${serviceTasks.length} tasks',
    );

    // Filter tasks based on selected filter BEFORE creating widgets
    final filteredServiceTasks = widget.filter == 'All Tasks'
        ? serviceTasks
        : widget.filter == 'Urgent'
        ? serviceTasks.where((task) => task.isUrgent).toList()
        : serviceTasks.where((task) => task.isImportant).toList();

    // Limit to task count or show all if on the Tasks page
    final tasksToShow = widget.taskCount < 0
        ? filteredServiceTasks
        : filteredServiceTasks.take(widget.taskCount).toList();

    // Show a message if no tasks match the filter
    if (tasksToShow.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'No ${widget.filter.toLowerCase()} tasks found',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    // Create task widgets with optimizations
    final taskWidgets = tasksToShow
        .map(
          (task) => RepaintBoundary(
            key: ValueKey('repaint_${task.id}'),
            child: TaskItem(
              key: ValueKey(task.id),
              task: task,
              icon: task.icon,
              title: task.title,
              time: task.time,
              color: task.color,
              isUrgent: task.isUrgent,
              isImportant: task.isImportant,
              isAnimatedEmoji: task.isAnimatedEmoji,
            ),
          ),
        )
        .toList();

    // Use AnimatedBuilder to create smooth slide-up animations
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _repositionController,
        builder: (context, child) {
          return IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: taskWidgets.asMap().entries.expand((entry) {
                final index = entry.key;
                final taskWidget = entry.value;

                // Determine if this task should animate based on its original position
                bool shouldAnimate = false;
                if (_isAnimatingReposition && _removedTaskIndex >= 0) {
                  // Only animate tasks that were originally below the removed task
                  // Find the current task's original index in the previous list
                  final currentTaskId = tasksToShow[index].id;
                  final originalIndex = _previousTaskIds.indexOf(currentTaskId);

                  // If this task was originally below the removed task, it should animate
                  shouldAnimate = originalIndex > _removedTaskIndex;

                  print(
                    'REAL TaskList: Task at index $index (ID: $currentTaskId) - originalIndex: $originalIndex, removedIndex: $_removedTaskIndex, shouldAnimate: $shouldAnimate',
                  );
                }

                // Create staggered slide-up animation only for tasks that should move
                final slideAnimation = shouldAnimate
                    ? Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _repositionController,
                          curve: Interval(
                            (index * 0.1).clamp(
                              0.0,
                              0.9,
                            ), // Less stagger for faster feel
                            1.0,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                      )
                    : AlwaysStoppedAnimation(
                        1.0,
                      ); // No animation for tasks that don't move

                // Create the animated task widget
                final animatedTask = AnimatedBuilder(
                  animation: slideAnimation,
                  builder: (context, child) {
                    // Only apply slide offset to tasks that should animate
                    final slideOffset =
                        (shouldAnimate && _isAnimatingReposition)
                        ? (1 - slideAnimation.value) *
                              60.0 // Reduced from 80px for better performance
                        : 0.0;

                    return Transform.translate(
                      offset: Offset(0, slideOffset),
                      child: Opacity(
                        opacity: (shouldAnimate && _isAnimatingReposition)
                            ? slideAnimation
                                  .value // Fade in during animation
                            : 1.0,
                        child: taskWidget,
                      ),
                    );
                  },
                );

                // Return task and spacing (if not last item)
                if (index < taskWidgets.length - 1) {
                  return [animatedTask, const SizedBox(height: 8.0)];
                } else {
                  return [animatedTask];
                }
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
