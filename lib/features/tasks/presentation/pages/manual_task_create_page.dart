import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/ui_tab_selector.dart';
import 'package:motiv_fy/features/noteflow/presentation/pages/note_flow_page.dart';
import 'package:motiv_fy/core/widgets/task_form.dart';
import 'package:motiv_fy/features/noteflow/presentation/pages/tasks_notes_page.dart';
import 'package:motiv_fy/features/noteflow/data/services/note_flow_service.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';
import 'package:motiv_fy/core/utils/device_utils.dart';

/// Represents the main page for manual task creation.
class ManualTaskCreatePage extends StatefulWidget {
  const ManualTaskCreatePage({super.key});

  @override
  State<ManualTaskCreatePage> createState() => _ManualTaskCreatePageState();
}

class _ManualTaskCreatePageState extends State<ManualTaskCreatePage> {
  final NoteFlowService _noteFlowService = NoteFlowService();
  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: RepaintBoundary(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with page title and navigation
              RepaintBoundary(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DeviceUtils.isLowEndDevice ? 16.0 : 21.0,
                    vertical: 0.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RepaintBoundary(
                        child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: DeviceUtils.isLowEndDevice ? 24 : 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const TasksNotesPage(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(-1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(
                                        tween,
                                      );
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                transitionDuration: Duration(
                                  milliseconds: DeviceUtils.isLowEndDevice
                                      ? 200
                                      : 300,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Flexible(
                        child: RepaintBoundary(
                          child: Hero(
                            tag: 'tabSelector',
                            child: TabSelector(
                              tabs: const [
                                TabItem(
                                  label: 'NoteFlow',
                                  icon: Icons.auto_awesome,
                                  selectedColor: Colors.white,
                                  unselectedColor: Colors.white70,
                                ),
                                TabItem(
                                  label: 'Manual',
                                  icon: Icons.edit_note,
                                  selectedColor: Colors.white,
                                  unselectedColor: Colors.white70,
                                ),
                              ],
                              initialIndex:
                                  1, // Manual tab is selected by default
                              onTabChanged: (index) {
                                if (index == 0) {
                                  // Access the saved text from NoteFlowService
                                  print(
                                    'Navigating back to NoteFlow with saved text: ${_noteFlowService.noteText}',
                                  );

                                  // Navigate to NoteFlowPage when NoteFlow tab is selected
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => const NoteFlowPage(),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                      transitionDuration: Duration(
                                        milliseconds: DeviceUtils.isLowEndDevice
                                            ? 100
                                            : 150,
                                      ),
                                      maintainState:
                                          true, // Changed to true to maintain state
                                    ),
                                  );
                                }
                              },
                              width: DeviceUtils.isLowEndDevice ? 200 : 220,
                              height: DeviceUtils.isLowEndDevice ? 32 : 36,
                              borderColor: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      RepaintBoundary(
                        child: IconButton(
                          icon: Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: DeviceUtils.isLowEndDevice ? 28 : 32,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Page subtitle
              RepaintBoundary(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: DeviceUtils.isLowEndDevice ? 12.0 : 16.0,
                    bottom: DeviceUtils.isLowEndDevice ? 12.0 : 16.0,
                    left: DeviceUtils.isLowEndDevice ? 16.0 : 21.0,
                    right: DeviceUtils.isLowEndDevice ? 16.0 : 21.0,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: DeviceUtils.isLowEndDevice ? 4.0 : 6.0,
                          horizontal: DeviceUtils.isLowEndDevice ? 12.0 : 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(
                            DeviceUtils.isLowEndDevice ? 12 : 16,
                          ),
                        ),
                        child: Text(
                          'New Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: DeviceUtils.isLowEndDevice ? 12 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Using the TaskForm component with proper padding
              Expanded(
                child: RepaintBoundary(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: DeviceUtils.isLowEndDevice ? 16.0 : 21.0,
                    ),
                    child: TaskForm(
                      onTaskCreated: (taskData) {
                        // Extract data from taskData
                        final isAnimatedEmoji =
                            taskData['isAnimatedEmoji'] as bool? ?? false;
                        final emoji = taskData['emoji'] as String? ?? '📝';
                        final title =
                            taskData['title'] as String? ?? 'Untitled Task';
                        final time = taskData['time'] as String? ?? '00:00';
                        final priority =
                            taskData['priority'] as String? ?? 'Normal';
                        final date =
                            taskData['date'] as DateTime? ?? DateTime.now();
                        final deadline = taskData['deadline'] as DateTime?;
                        final deadlineTime =
                            taskData['deadlineTime'] as TimeOfDay?;
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
                        print(
                          'Task added: $title with ID: ${task.id} and time: $time',
                        );

                        // Navigate back to the home page
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
