import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/task_form.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';

/// Represents the content page for manual task creation.
class ManualTaskCreateContentPage extends StatefulWidget {
  const ManualTaskCreateContentPage({super.key});

  @override
  State<ManualTaskCreateContentPage> createState() =>
      _ManualTaskCreateContentPageState();
}

class _ManualTaskCreateContentPageState
    extends State<ManualTaskCreateContentPage> {
  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Page subtitle
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
            left: 21.0,
            right: 21.0,
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'New Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Using the TaskForm component
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: TaskForm(
              onTaskCreated: (taskData) {
                // Extract data from taskData
                final isAnimatedEmoji =
                    taskData['isAnimatedEmoji'] as bool? ?? false;
                final emoji = taskData['emoji'] as String? ?? '📝';
                final title = taskData['title'] as String? ?? 'Untitled Task';
                final time = taskData['time'] as String? ?? '00:00';
                final priority = taskData['priority'] as String? ?? 'Normal';
                final date = taskData['date'] as DateTime? ?? DateTime.now();
                final deadline = taskData['deadline'] as DateTime?;
                final deadlineTime = taskData['deadlineTime'] as TimeOfDay?;
                final subtasksData =
                    taskData['subtasks'] as List<dynamic>? ?? [];

                // Convert subtasks data to SubTask objects
                final subtasks = subtasksData
                    .map(
                      (subtaskData) => SubTask(
                        id: subtaskData['id'] as String,
                        title: subtaskData['title'] as String,
                        isCompleted: subtaskData['isCompleted'] as bool,
                      ),
                    )
                    .toList();

                // Create a task and add it to the service
                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  icon: emoji,
                  title: title,
                  time: time,
                  color: TaskService.getPriorityColor(priority),
                  isUrgent: priority == 'Urgent',
                  isImportant: priority == 'Important',
                  date: date,
                  deadline: deadline,
                  deadlineTime: deadlineTime != null
                      ? TaskService.formatTimeOfDay(deadlineTime)
                      : null,
                  isAnimatedEmoji: isAnimatedEmoji,
                  subtasks: subtasks,
                  description: taskData['description'] as String?,
                  links: taskData['links'] as String?,
                );

                _taskService.addTask(task);
                print('Task added: $title with ID: ${task.id} and time: $time');

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task created successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Navigate back to the previous page (home) after successful creation
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
