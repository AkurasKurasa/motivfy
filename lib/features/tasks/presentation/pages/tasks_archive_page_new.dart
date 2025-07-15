import 'package:flutter/material.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';
import 'package:motiv_fy/core/widgets/animated_filter_selector.dart';
import 'package:motiv_fy/features/tasks/presentation/pages/recently_deleted_tasks_page.dart';

class TasksArchivePage extends StatefulWidget {
  final String? initialFilter;

  const TasksArchivePage({super.key, this.initialFilter});

  @override
  State<TasksArchivePage> createState() => _TasksArchivePageState();
}

class _TasksArchivePageState extends State<TasksArchivePage> {
  final TaskService _taskService = TaskService();
  String _selectedFilter = 'All Tasks'; // Default filter

  @override
  void initState() {
    super.initState();
    // Set initial filter if provided
    if (widget.initialFilter != null) {
      _selectedFilter = widget.initialFilter!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final horizontalPadding = screenWidth > 600 ? 40.0 : 20.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and centered title
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 20,
                  ),
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back button
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        // Centered icon and title
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.archive,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Tasks Archive',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Recently deleted tasks button
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.white.withOpacity(0.8),
                              size: 18,
                            ),
                            onPressed: () {
                              // Navigate to recently deleted tasks page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RecentlyDeletedTasksPage(),
                                ),
                              );
                            },
                            tooltip: 'Recently Deleted',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter selector using AnimatedFilterSelector
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: AnimatedFilterSelector(
                    options: const ['All Tasks', 'Completed', 'Overdue'],
                    selectedOption: _selectedFilter,
                    onOptionChanged: (option) {
                      setState(() {
                        _selectedFilter = option;
                      });
                    },
                    optionColors: const {
                      'All Tasks': Colors.white,
                      'Completed': Colors.green,
                      'Overdue': Colors.red,
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Archived tasks list
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: _buildArchivedTasksList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper method to get appropriate icon for each filter
  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'All Tasks':
        return Icons.all_inbox;
      case 'Completed':
        return Icons.check_circle_outline;
      case 'Overdue':
        return Icons.event_busy;
      default:
        return Icons.list;
    }
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'All Tasks':
        return Colors.white;
      case 'Completed':
        return Colors.green;
      case 'Overdue':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Widget _buildArchivedTasksList() {
    // Get archived tasks based on selected filter
    final archivedTasks = _taskService.getArchivedTasks(_selectedFilter);

    if (archivedTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getFilterIcon(_selectedFilter),
              size: 48,
              color: _getFilterColor(_selectedFilter).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${_selectedFilter == "All Tasks" ? "Archived" : _selectedFilter} Tasks',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == "All Tasks"
                  ? 'Tasks you archive will appear here'
                  : '${_selectedFilter} tasks will be shown here',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: archivedTasks.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final task = archivedTasks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF636363).withOpacity(0.5),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            // Glassmorphic effect
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                // Task color indicator and icon
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: task.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: task.color.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          task.icon,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      if (task.isCompleted)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.grey.shade400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.grey.shade400,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.time,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.archive,
                            color: Colors.grey.shade400,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.archivedDate != null
                                ? _formatArchivedDate(task.archivedDate!)
                                : 'Unknown',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Restore button
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.unarchive,
                      color: Colors.green,
                      size: 18,
                    ),
                    onPressed: () {
                      _taskService.unarchiveTask(task.id);
                      setState(() {});

                      // Show snackbar with undo option
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${task.title} restored'),
                          backgroundColor: Colors.green.shade700,
                          action: SnackBarAction(
                            label: 'Undo',
                            textColor: Colors.white,
                            onPressed: () {
                              _taskService.archiveTask(
                                task.id,
                                isCompleted: task.isCompleted,
                              );
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                    tooltip: 'Restore Task',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatArchivedDate(DateTime archivedDate) {
    final now = DateTime.now();
    final difference = now.difference(archivedDate);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
