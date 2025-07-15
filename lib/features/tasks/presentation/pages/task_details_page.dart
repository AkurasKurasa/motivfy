import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';
import 'package:motiv_fy/core/widgets/glassmorphic_text_button.dart';
import 'package:motiv_fy/features/tasks/presentation/widgets/task_form_helpers.dart';
import 'package:motiv_fy/core/widgets/subtasks_list.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final ValueChanged<Task>? onTaskUpdated;

  const TaskDetailsPage({Key? key, required this.task, this.onTaskUpdated})
    : super(key: key);

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  // Edit mode
  bool isEditMode = false;

  // Controllers for edit mode
  late TextEditingController _taskNameController;
  late TextEditingController _linksController;
  late TextEditingController _descriptionController;

  // Form values for edit mode
  String? selectedPriority;
  DateTime? selectedDate;
  DateTime? selectedDeadline;
  TimeOfDay? selectedDeadlineTime;
  TimeOfDay? selectedTime;
  bool showAnimatedEmojis = false;
  int selectedEmojiIndex = 0;
  int selectedAnimatedEmojiIndex = 0;
  List<SubTaskItem> subtasks = [];

  // Additional form values for complete task editing
  String? selectedRepeat;
  TimeOfDay? selectedReminder;
  TimeOfDay? reminderTime;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    // Listen to TaskService updates to refresh when task changes
    TaskService().addListener(_refreshTaskData);
  }

  void _refreshTaskData() {
    // Get the latest task data from TaskService
    final latestTask = TaskService().getAllTasks().firstWhere(
      (task) => task.id == widget.task.id,
      orElse: () => widget.task,
    );

    // Update subtasks with latest data
    setState(() {
      // Dispose old controllers
      for (var subtask in subtasks) {
        subtask.controller.dispose();
      }

      // Recreate subtasks with updated data
      subtasks = latestTask.subtasks
          .map(
            (subtask) => SubTaskItem(
              id: subtask.id,
              controller: TextEditingController(text: subtask.title),
              isCompleted: subtask.isCompleted,
            ),
          )
          .toList();
    });
  }

  void _initializeControllers() {
    _taskNameController = TextEditingController(text: widget.task.title);
    _linksController = TextEditingController(text: widget.task.links ?? '');
    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );

    // Initialize form values
    selectedPriority = widget.task.isUrgent
        ? 'Urgent'
        : widget.task.isImportant
        ? 'Important'
        : 'Normal';
    selectedDate = widget.task.date;
    selectedDeadline = widget.task.deadline;
    selectedDeadlineTime = widget.task.deadlineTime != null
        ? TimeOfDay.fromDateTime(
            DateTime.parse('2023-01-01 ${widget.task.deadlineTime}:00'),
          )
        : null;

    // Parse time
    try {
      final timeParts = widget.task.time.split(':');
      selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    } catch (e) {
      selectedTime = TimeOfDay.now();
    }

    // Initialize emoji selection
    showAnimatedEmojis = widget.task.isAnimatedEmoji;
    if (widget.task.isAnimatedEmoji) {
      selectedAnimatedEmojiIndex = TaskFormUtils.animatedEmojiOptions.indexOf(
        widget.task.icon,
      );
      // Safety check: ensure index is valid
      if (selectedAnimatedEmojiIndex == -1 ||
          selectedAnimatedEmojiIndex >=
              TaskFormUtils.animatedEmojiOptions.length) {
        selectedAnimatedEmojiIndex = 0;
      }
    } else {
      selectedEmojiIndex = TaskFormUtils.emojiOptions.indexOf(widget.task.icon);
      // Safety check: ensure index is valid
      if (selectedEmojiIndex == -1 ||
          selectedEmojiIndex >= TaskFormUtils.emojiOptions.length) {
        selectedEmojiIndex = 0;
      }
    }

    // Initialize subtasks
    subtasks = widget.task.subtasks
        .map(
          (subtask) => SubTaskItem(
            id: subtask.id,
            controller: TextEditingController(text: subtask.title),
            isCompleted: subtask.isCompleted,
          ),
        )
        .toList();

    // Initialize additional form values
    selectedRepeat = 'Never'; // Default value
    selectedReminder = null; // Default no reminder
  }

  @override
  void dispose() {
    TaskService().removeListener(_refreshTaskData);
    _taskNameController.dispose();
    _linksController.dispose();
    _descriptionController.dispose();
    for (var subtask in subtasks) {
      subtask.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Debug print to see if we're getting the task data
    print('TaskDetailsPage: Building with task: ${widget.task.title}');
    print('TaskDetailsPage: Task ID: ${widget.task.id}');
    print('TaskDetailsPage: Task description: ${widget.task.description}');

    // Add error boundary in case of null task data
    if (widget.task.title.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Error loading task details',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Task ID: ${widget.task.id}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'Task Details'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        foregroundColor: Colors.white,
        toolbarHeight:
            kToolbarHeight + 20, // Add extra height for proper spacing
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(isEditMode ? Icons.save : Icons.edit),
              onPressed: isEditMode ? _saveTask : _toggleEditMode,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12), // Top spacer for header
            _buildTaskCard(),
            const SizedBox(height: 24),
            _buildTaskNameField(),
            const SizedBox(height: 24),
            _buildPriorityField(),
            const SizedBox(height: 24),
            if (widget.task.links?.isNotEmpty == true || isEditMode) ...[
              _buildLinksField(context),
              const SizedBox(height: 24),
            ],
            _buildDescriptionField(),
            const SizedBox(height: 32),
            _buildDateSection(),
            const SizedBox(height: 32),
            if (widget.task.deadline != null || isEditMode) ...[
              _buildDeadlineSection(),
              const SizedBox(height: 32),
            ],
            if (isEditMode) ...[
              _buildReminderSection(),
              const SizedBox(height: 32),
              _buildRepeatSection(),
              const SizedBox(height: 32),
            ],
            if (widget.task.subtasks.isNotEmpty || isEditMode) ...[
              _buildSubtasksSection(),
              const SizedBox(height: 32),
            ],
            _buildEmoteSection(),
            const SizedBox(height: 32),
            _buildActionButtons(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard() {
    final task = widget.task;

    // Safety check for emoji indices
    String currentIcon;
    if (showAnimatedEmojis) {
      if (selectedAnimatedEmojiIndex >= 0 &&
          selectedAnimatedEmojiIndex <
              TaskFormUtils.animatedEmojiOptions.length) {
        currentIcon =
            TaskFormUtils.animatedEmojiOptions[selectedAnimatedEmojiIndex];
      } else {
        currentIcon =
            TaskFormUtils.animatedEmojiOptions[0]; // Fallback to first emoji
        selectedAnimatedEmojiIndex = 0;
      }
    } else {
      if (selectedEmojiIndex >= 0 &&
          selectedEmojiIndex < TaskFormUtils.emojiOptions.length) {
        currentIcon = TaskFormUtils.emojiOptions[selectedEmojiIndex];
      } else {
        currentIcon = TaskFormUtils.emojiOptions[0]; // Fallback to first emoji
        selectedEmojiIndex = 0;
      }
    }

    return _GlassmorphicContainer(
      child: Row(
        children: [
          // Task Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
                  (isEditMode
                          ? TaskFormUtils.getPriorityColor(selectedPriority)
                          : task.color)
                      .withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    (isEditMode
                            ? TaskFormUtils.getPriorityColor(selectedPriority)
                            : task.color)
                        .withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Center(
              child: (isEditMode ? showAnimatedEmojis : task.isAnimatedEmoji)
                  ? SizedBox(
                      width: 30,
                      height: 30,
                      child: _buildLottieWidget(
                        isEditMode ? currentIcon : task.icon,
                      ),
                    )
                  : Text(
                      isEditMode ? currentIcon : task.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Task Info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode
                      ? _taskNameController.text.isNotEmpty
                            ? _taskNameController.text
                            : 'Untitled Task'
                      : task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  isEditMode
                      ? TaskFormUtils.formatTime(selectedTime!)
                      : task.time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Priority Indicator
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    (isEditMode
                            ? TaskFormUtils.getPriorityColor(selectedPriority)
                            : task.color)
                        .withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      (isEditMode
                              ? TaskFormUtils.getPriorityColor(selectedPriority)
                              : task.color)
                          .withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  isEditMode
                      ? selectedPriority!
                      : (task.isUrgent
                            ? 'Urgent'
                            : task.isImportant
                            ? 'Important'
                            : 'Normal'),
                  style: TextStyle(
                    color: isEditMode
                        ? TaskFormUtils.getPriorityColor(selectedPriority)
                        : task.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Name',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: _GlassmorphicContainer(
            child: isEditMode
                ? TextFormField(
                    controller: _taskNameController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Enter task name',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : Text(
                    widget.task.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityField() {
    final task = widget.task;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: _GlassmorphicContainer(
            child: isEditMode
                ? DropdownButtonFormField<String>(
                    value: selectedPriority,
                    dropdownColor: const Color(0xFF2A2A2A),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    items: TaskFormUtils.priorityOptions.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: TaskFormUtils.getPriorityColor(priority),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(priority),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPriority = value;
                      });
                    },
                  )
                : Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: task.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        task.isUrgent
                            ? 'Urgent'
                            : task.isImportant
                            ? 'Important'
                            : 'Normal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinksField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Link/s',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: _GlassmorphicContainer(
            child: isEditMode
                ? TextFormField(
                    controller: _linksController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Enter link (optional)',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : GestureDetector(
                    onTap: () => _handleLinkTap(context, widget.task.links),
                    child: Row(
                      children: [
                        const Icon(Icons.link, color: Colors.blue, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.task.links ?? '',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// Handles link tap with validation
  void _handleLinkTap(BuildContext context, String? link) {
    if (link == null || link.isEmpty) return;

    try {
      final uri = Uri.parse(link);
      if (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) {
        // Valid URL - you could add url_launcher here if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Link: $link'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid URL format'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid URL format'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: _GlassmorphicContainer(
            child: isEditMode
                ? TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter task description (optional)',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : Text(
                    widget.task.description?.isNotEmpty == true
                        ? widget.task.description!
                        : 'No description provided for this task.',
                    style: TextStyle(
                      color: widget.task.description?.isNotEmpty == true
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 16,
                      height: 1.5,
                      fontStyle: widget.task.description?.isNotEmpty == true
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    final task = widget.task;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Date',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _GlassmorphicContainer(
                child: isEditMode
                    ? GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              TaskFormUtils.formatDate(selectedDate!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            TaskFormUtils.formatDate(task.date),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Time',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _GlassmorphicContainer(
                child: isEditMode
                    ? GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              TaskFormUtils.formatTime(selectedTime!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            task.time,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineSection() {
    final task = widget.task;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deadline',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _GlassmorphicContainer(
          child: isEditMode
              ? GestureDetector(
                  onTap: () => _selectDeadline(context),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        selectedDeadline != null
                            ? TaskFormUtils.formatDate(selectedDeadline!)
                            : 'Select deadline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      if (selectedDeadlineTime != null) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _selectDeadlineTime(context),
                          child: Text(
                            '• ${TaskFormUtils.formatTime(selectedDeadlineTime!)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _selectDeadlineTime(context),
                          child: const Text(
                            '• Add time',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      TaskFormUtils.formatDate(task.deadline!),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    if (task.deadlineTime != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '• ${task.deadlineTime}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildSubtasksSection() {
    final task = widget.task;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subtasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _GlassmorphicContainer(
          child: Column(
            children: [
              if (isEditMode) ...[
                // Edit mode - editable subtasks with toggle functionality
                ...subtasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final subtask = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              subtasks[index].isCompleted =
                                  !subtasks[index].isCompleted;
                            });
                          },
                          child: Container(
                            width:
                                44, // Increased touch area for better accessibility
                            height:
                                44, // Increased touch area for better accessibility
                            alignment:
                                Alignment.center, // Center the visual checkbox
                            child: Container(
                              width: 24, // Slightly larger visual checkbox
                              height: 24, // Slightly larger visual checkbox
                              decoration: BoxDecoration(
                                color: subtask.isCompleted
                                    ? Colors.green
                                    : Colors.transparent,
                                border: Border.all(
                                  color: subtask.isCompleted
                                      ? Colors.green
                                      : Colors.white54,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: subtask.isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: subtask.controller,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: subtask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: Colors.white54,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter subtask',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              subtasks[index].controller.dispose();
                              subtasks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                // Add new subtask button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      subtasks.add(
                        SubTaskItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          controller: TextEditingController(),
                          isCompleted: false,
                        ),
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: Colors.blue, size: 20),
                        const SizedBox(width: 12),
                        const Text(
                          'Add subtask',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // View mode - display existing subtasks
                ...task.subtasks.map((subtask) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // In view mode, we could potentially toggle completion
                            // but for now, this is just visual feedback
                          },
                          child: Container(
                            width:
                                44, // Increased touch area for better accessibility
                            height:
                                44, // Increased touch area for better accessibility
                            alignment:
                                Alignment.center, // Center the visual checkbox
                            child: Container(
                              width: 24, // Slightly larger visual checkbox
                              height: 24, // Slightly larger visual checkbox
                              decoration: BoxDecoration(
                                color: subtask.isCompleted
                                    ? Colors.green
                                    : Colors.transparent,
                                border: Border.all(
                                  color: subtask.isCompleted
                                      ? Colors.green
                                      : Colors.white54,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: subtask.isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            subtask.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: subtask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: Colors.white54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmoteSection() {
    final task = widget.task;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Emote',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        // Selected Emoji Display
        Center(
          child: _GlassmorphicContainer(
            padding: const EdgeInsets.all(20),
            child: (isEditMode ? showAnimatedEmojis : task.isAnimatedEmoji)
                ? SizedBox(
                    width: 60,
                    height: 60,
                    child: _buildLottieWidget(
                      isEditMode
                          ? (selectedAnimatedEmojiIndex >= 0 &&
                                    selectedAnimatedEmojiIndex <
                                        TaskFormUtils
                                            .animatedEmojiOptions
                                            .length)
                                ? TaskFormUtils
                                      .animatedEmojiOptions[selectedAnimatedEmojiIndex]
                                : TaskFormUtils.animatedEmojiOptions[0]
                          : task.icon,
                    ),
                  )
                : Text(
                    isEditMode
                        ? (selectedEmojiIndex >= 0 &&
                                  selectedEmojiIndex <
                                      TaskFormUtils.emojiOptions.length)
                              ? TaskFormUtils.emojiOptions[selectedEmojiIndex]
                              : TaskFormUtils.emojiOptions[0]
                        : task.icon,
                    style: const TextStyle(fontSize: 48),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        if (isEditMode) ...[
          // Emoji type toggle (only in edit mode)
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmojiHelper.buildEmojiTypeChip(
                    'Standard',
                    !showAnimatedEmojis,
                    (selected) {
                      if (selected) setState(() => showAnimatedEmojis = false);
                    },
                  ),
                  const SizedBox(width: 8),
                  EmojiHelper.buildEmojiTypeChip(
                    'Animated',
                    showAnimatedEmojis,
                    (selected) {
                      if (selected) setState(() => showAnimatedEmojis = true);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Emoji Selection Grid (only in edit mode)
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: !showAnimatedEmojis
                ? EmojiHelper.buildEmojiGrid(
                    selectedEmojiIndex,
                    (index) => setState(() => selectedEmojiIndex = index),
                  )
                : EmojiHelper.buildAnimatedEmojiGrid(
                    selectedAnimatedEmojiIndex,
                    (index) =>
                        setState(() => selectedAnimatedEmojiIndex = index),
                  ),
          ),
        ] else ...[
          // View mode - show only current emoji indicator, no selector
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final task = widget.task;

    return Row(
      children: [
        Expanded(
          child: GlassmorphicTextButton(
            text: 'Delete',
            onPressed: () {
              HapticFeedback.heavyImpact();
              _showDeleteConfirmation(context);
            },
            backgroundColor: Colors.red.withOpacity(0.2),
            borderColor: Colors.red.withOpacity(0.5),
            textColor: Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassmorphicTextButton(
            text: task.isCompleted ? 'Completed' : 'Mark Complete',
            onPressed: task.isCompleted
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    _showCompleteConfirmation(context);
                  },
            backgroundColor: Colors.green.withOpacity(0.2),
            borderColor: Colors.green.withOpacity(0.5),
            textColor: Colors.green,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildConfirmationDialog(
        context,
        title: 'Delete Task',
        content:
            'Are you sure you want to delete this task? This action cannot be undone.',
        confirmText: 'Delete',
        confirmColor: Colors.red,
        onConfirm: () {
          try {
            // Actually delete the task using TaskService
            TaskService().deleteTask(widget.task.id);
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Go back to previous screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task deleted successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } catch (e) {
            Navigator.pop(context); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete task: $e'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _showCompleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildConfirmationDialog(
        context,
        title: 'Complete Task',
        content: 'Mark this task as completed?',
        confirmText: 'Complete',
        confirmColor: Colors.green,
        onConfirm: () {
          try {
            // Actually complete the task using TaskService
            TaskService().completeTask(widget.task.id, true);
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Go back to previous screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task completed successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } catch (e) {
            Navigator.pop(context); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to complete task: $e'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: _GlassmorphicContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GlassmorphicTextButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    borderColor: Colors.grey.withOpacity(0.5),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassmorphicTextButton(
                    text: confirmText,
                    onPressed: onConfirm,
                    backgroundColor: confirmColor.withOpacity(0.2),
                    borderColor: confirmColor.withOpacity(0.5),
                    textColor: confirmColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a Lottie widget with error handling
  Widget _buildLottieWidget(String assetPath) {
    // Debug print to help identify loading issues
    print('TaskDetailsPage: Attempting to load Lottie asset: $assetPath');

    try {
      return Lottie.asset(
        assetPath,
        repeat: true,
        animate: true,
        fit: BoxFit.contain, // Ensure proper fit
        errorBuilder: (context, error, stackTrace) {
          // Enhanced error logging
          print('TaskDetailsPage: Failed to load Lottie asset: $assetPath');
          print('TaskDetailsPage: Error: $error');
          // Fallback to emoji if Lottie fails to load
          return const Text('📋', style: TextStyle(fontSize: 24));
        },
      );
    } catch (e) {
      // Enhanced error logging
      print('TaskDetailsPage: Exception loading Lottie asset: $assetPath');
      print('TaskDetailsPage: Exception: $e');
      // Fallback emoji if there's any error
      return const Text('📋', style: TextStyle(fontSize: 24));
    }
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  Future<void> _saveTask() async {
    if (_taskNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create updated task
      final updatedTask = widget.task.copyWith(
        title: _taskNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        links: _linksController.text.trim().isEmpty
            ? null
            : _linksController.text.trim(),
        date: selectedDate,
        time:
            '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}',
        deadline: selectedDeadline,
        deadlineTime: selectedDeadlineTime != null
            ? '${selectedDeadlineTime!.hour.toString().padLeft(2, '0')}:${selectedDeadlineTime!.minute.toString().padLeft(2, '0')}'
            : null,
        isImportant: selectedPriority == 'Important',
        isUrgent: selectedPriority == 'Urgent',
        icon: showAnimatedEmojis
            ? TaskFormUtils.animatedEmojiOptions[selectedAnimatedEmojiIndex]
            : TaskFormUtils.emojiOptions[selectedEmojiIndex],
        isAnimatedEmoji: showAnimatedEmojis,
        subtasks: subtasks
            .map(
              (item) => SubTask(
                id: item.id,
                title: item.controller.text.trim(),
                isCompleted: item.isCompleted,
              ),
            )
            .where((subtask) => subtask.title.isNotEmpty)
            .toList(),
      );

      // Update task through service
      _updateTask(updatedTask);

      setState(() {
        isEditMode = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh the task data
      widget.onTaskUpdated?.call(updatedTask);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update task: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateTask(Task updatedTask) {
    // Find and update the task in the service
    final taskService = TaskService();
    final tasks = taskService.getAllTasks();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index != -1) {
      // Remove old task and add updated one
      taskService.removeTask(updatedTask.id);
      taskService.addTask(updatedTask);
    }
  }

  Widget _buildReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set Reminder',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _GlassmorphicContainer(
          child: GestureDetector(
            onTap: () => _selectReminder(context),
            child: Row(
              children: [
                const Icon(Icons.alarm, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Text(
                  selectedReminder != null
                      ? TaskFormUtils.formatTime(selectedReminder!)
                      : 'Set reminder time',
                  style: TextStyle(
                    color: selectedReminder != null
                        ? Colors.white
                        : Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Repeat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _GlassmorphicContainer(
          child: DropdownButtonFormField<String>(
            value: selectedRepeat,
            dropdownColor: const Color(0xFF2A2A2A),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            items: TaskFormUtils.repeatOptions.map((repeat) {
              return DropdownMenuItem(
                value: repeat,
                child: Row(
                  children: [
                    const Icon(Icons.repeat, color: Colors.purple, size: 20),
                    const SizedBox(width: 12),
                    Text(repeat),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedRepeat = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectReminder(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: reminderTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: const Color(0xFF2C2C2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        reminderTime = time;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: const Color(0xFF2C2C2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: const Color(0xFF2C2C2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: const Color(0xFF2C2C2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDeadline = date;
      });
    }
  }

  Future<void> _selectDeadlineTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedDeadlineTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: const Color(0xFF2C2C2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedDeadlineTime = time;
      });
    }
  }
}

// Simple Container Widget to replace glassmorphic containers
class _GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _GlassmorphicContainer({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
