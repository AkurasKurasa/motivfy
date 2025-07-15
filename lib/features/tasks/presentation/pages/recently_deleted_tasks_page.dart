import 'package:flutter/material.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';

class RecentlyDeletedTasksPage extends StatefulWidget {
  const RecentlyDeletedTasksPage({super.key});

  @override
  State<RecentlyDeletedTasksPage> createState() =>
      _RecentlyDeletedTasksPageState();
}

class _RecentlyDeletedTasksPageState extends State<RecentlyDeletedTasksPage> {
  final TaskService _taskService = TaskService();
  final Set<String> _selectedTasks = {};
  bool _isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final horizontalPadding = screenWidth > 600 ? 40.0 : 20.0;
            final isSmallScreen = screenWidth < 400;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top spacing for better visual hierarchy
                const SizedBox(height: 16),

                // Header with back button and title
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      const SizedBox(width: 8),

                      // Title with icon
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Recently Deleted Tasks',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isSelectionMode) ...[
                            // Restore button
                            if (isSmallScreen)
                              IconButton(
                                icon: Icon(
                                  Icons.restore,
                                  color: _selectedTasks.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.green.shade400,
                                  size: 22,
                                ),
                                onPressed: _selectedTasks.isEmpty
                                    ? null
                                    : _restoreSelected,
                                tooltip: 'Restore Selected',
                              )
                            else
                              TextButton.icon(
                                icon: const Icon(Icons.restore, size: 18),
                                label: const Text('Restore'),
                                onPressed: _selectedTasks.isEmpty
                                    ? null
                                    : _restoreSelected,
                                style: TextButton.styleFrom(
                                  foregroundColor: _selectedTasks.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.green.shade400,
                                ),
                              ),

                            const SizedBox(width: 4),

                            // Delete All button
                            if (isSmallScreen)
                              IconButton(
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: _selectedTasks.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.red.shade400,
                                  size: 22,
                                ),
                                onPressed: _selectedTasks.isEmpty
                                    ? null
                                    : _confirmDeleteSelected,
                                tooltip: 'Delete Forever',
                              )
                            else
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.delete_forever,
                                  size: 18,
                                ),
                                label: const Text('Delete'),
                                onPressed: _selectedTasks.isEmpty
                                    ? null
                                    : _confirmDeleteSelected,
                                style: TextButton.styleFrom(
                                  foregroundColor: _selectedTasks.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.red.shade400,
                                ),
                              ),
                          ],

                          const SizedBox(width: 8),

                          // Selection mode toggle
                          IconButton(
                            icon: Icon(
                              _isSelectionMode ? Icons.close : Icons.select_all,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _isSelectionMode = !_isSelectionMode;
                                if (!_isSelectionMode) {
                                  _selectedTasks.clear();
                                }
                              });
                            },
                            tooltip: _isSelectionMode
                                ? 'Cancel Selection'
                                : 'Select Tasks',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Body content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: _buildTasksList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return FutureBuilder(
      future: Future.value(_taskService.getDeletedTasks()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading deleted tasks: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final deletedTasks = snapshot.data ?? [];

        if (deletedTasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No recently deleted tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Deleted tasks will appear here',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: deletedTasks.length,
          itemBuilder: (context, index) {
            final task = deletedTasks[index];
            final isSelected = _selectedTasks.contains(task.id);

            return GestureDetector(
              onTap: () {
                if (_isSelectionMode) {
                  setState(() {
                    if (isSelected) {
                      _selectedTasks.remove(task.id);
                    } else {
                      _selectedTasks.add(task.id);
                    }
                  });
                }
              },
              onLongPress: () {
                if (!_isSelectionMode) {
                  setState(() {
                    _isSelectionMode = true;
                    _selectedTasks.add(task.id);
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? Colors.green.withOpacity(0.5)
                        : const Color(0xFF636363).withOpacity(0.5),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Selection indicator
                    if (_isSelectionMode)
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? Colors.green.shade400
                              : Colors.grey.shade600,
                          size: 24,
                        ),
                      ),

                    // Task icon
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(right: 12),
                      child: Text(
                        task.icon,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                    // Task details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Deleted: ${_formatDeletedDate(task.deletedDate)}',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                          if (task.description?.isNotEmpty == true) ...[
                            const SizedBox(height: 4),
                            Text(
                              task.description!,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Restore button
                    if (!_isSelectionMode)
                      IconButton(
                        icon: const Icon(
                          Icons.restore,
                          color: Colors.green,
                          size: 20,
                        ),
                        onPressed: () => _restoreTask(task.id),
                        tooltip: 'Restore Task',
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDeletedDate(DateTime? deletedDate) {
    if (deletedDate == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(deletedDate);

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

  void _restoreTask(String taskId) {
    _taskService.restoreTask(taskId);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task restored successfully'),
        backgroundColor: Colors.green.shade700,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () => _taskService.deleteTask(taskId),
        ),
      ),
    );
  }

  void _restoreSelected() {
    final count = _selectedTasks.length;
    for (final taskId in _selectedTasks) {
      _taskService.restoreTask(taskId);
    }

    setState(() {
      _selectedTasks.clear();
      _isSelectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count task(s) restored'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  void _confirmDeleteSelected() {
    final count = _selectedTasks.length;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Permanently Delete Tasks',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to permanently delete $count task(s)? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              for (final taskId in _selectedTasks) {
                _taskService.permanentlyDeleteTask(taskId);
              }

              setState(() {
                _selectedTasks.clear();
                _isSelectionMode = false;
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count task(s) permanently deleted'),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
