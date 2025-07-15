import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/subtasks_list.dart';
import 'package:motiv_fy/features/tasks/presentation/widgets/task_form_helpers.dart';

class TaskForm extends StatefulWidget {
  final Function(Map<String, dynamic>)? onTaskCreated;
  final Map<String, dynamic>? initialValues;
  final bool showAddButton;

  const TaskForm({
    super.key,
    this.onTaskCreated,
    this.initialValues,
    this.showAddButton = true,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  // Controllers
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _linksController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form values
  String? selectedPriority;
  String? selectedRepeat;
  int selectedEmojiIndex = 0;
  DateTime? selectedDate;
  DateTime? selectedDeadline;
  TimeOfDay? selectedDeadlineTime; // Added deadline time
  TimeOfDay? selectedReminder;
  TimeOfDay? selectedTime;
  bool showAnimatedEmojis = false;
  int selectedAnimatedEmojiIndex = 0;
  List<SubTaskItem> subtasks = [];

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  void _initializeFormFields() {
    if (widget.initialValues == null) return;

    _taskNameController.text = widget.initialValues!['taskName'] ?? '';
    _linksController.text = widget.initialValues!['links'] ?? '';
    _descriptionController.text = widget.initialValues!['description'] ?? '';

    // Priority mapping
    String? priority = widget.initialValues!['priority'];
    if (priority != null) {
      selectedPriority = priority;
      if (priority == 'High') selectedPriority = 'Urgent';
      if (priority == 'Medium') selectedPriority = 'Important';
      if (priority == 'Low') selectedPriority = 'Normal';
    }

    selectedRepeat = widget.initialValues!['repeat'];
    selectedEmojiIndex = widget.initialValues!['emojiIndex'] ?? 0;
    selectedDate = widget.initialValues!['date'];
    selectedDeadline = widget.initialValues!['deadline'];
    selectedDeadlineTime = widget.initialValues!['deadlineTime'];
    selectedReminder = widget.initialValues!['reminder'];
    selectedTime = widget.initialValues!['selectedTime'];
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _linksController.dispose();
    _descriptionController.dispose();
    for (var subtask in subtasks) {
      subtask.controller.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> _collectFormData() {
    // Format time string
    String timeString = '00:00';
    if (selectedTime != null) {
      timeString = TaskFormUtils.formatTime(selectedTime!);
    } else if (selectedDeadline != null) {
      timeString =
          '${selectedDeadline!.hour.toString().padLeft(2, '0')}:${selectedDeadline!.minute.toString().padLeft(2, '0')}';
    }

    // Collect subtasks data
    final subtasksData = subtasks
        .where((subtask) => subtask.controller.text.trim().isNotEmpty)
        .map(
          (subtask) => {
            'id': subtask.id,
            'title': subtask.controller.text.trim(),
            'isCompleted': subtask.isCompleted,
          },
        )
        .toList();

    return {
      'title': _taskNameController.text.trim(),
      'taskName': _taskNameController.text.trim(),
      'priority': selectedPriority ?? 'Normal',
      'links': _linksController.text.trim(),
      'description': _descriptionController.text.trim(),
      'date': selectedDate ?? DateTime.now(),
      'deadline': selectedDeadline,
      'deadlineTime': selectedDeadlineTime,
      'reminder': selectedReminder,
      'repeat': selectedRepeat ?? 'Never',
      'time': timeString,
      'emojiIndex': selectedEmojiIndex,
      'emoji': showAnimatedEmojis
          ? TaskFormUtils.animatedEmojiOptions[selectedAnimatedEmojiIndex]
          : TaskFormUtils.emojiOptions[selectedEmojiIndex],
      'isAnimatedEmoji': showAnimatedEmojis,
      'selectedTime': selectedTime,
      'subtasks': subtasksData,
    };
  }

  void _handleTaskCreation() {
    // Validate task name
    if (_taskNameController.text.trim().isEmpty) {
      TaskFormUtils.showError(context, 'Task name cannot be empty');
      return;
    }

    // Call onTaskCreated callback with form data
    if (widget.onTaskCreated != null) {
      widget.onTaskCreated!(_collectFormData());
    }
  }

  void _validateAndAddTask() {
    if (_taskNameController.text.isEmpty) {
      TaskFormUtils.showError(context, 'Task Name is required');
      return;
    }
    if (selectedDate == null) {
      TaskFormUtils.showError(context, 'Date is required');
      return;
    }
    if (selectedTime == null) {
      TaskFormUtils.showError(context, 'Time is required');
      return;
    }
    if (selectedPriority == null) {
      TaskFormUtils.showError(context, 'Priority is required');
      return;
    }

    // Require deadline time if deadline date is selected
    if (selectedDeadline != null && selectedDeadlineTime == null) {
      TaskFormUtils.showError(
        context,
        'Deadline time is required when deadline date is set',
      );
      return;
    }

    _handleTaskCreation();
  }

  // Date & Time pickers
  Future<void> _showDatePicker({
    required Function(DateTime) onDateSelected,
  }) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark()),
        child: child!,
      ),
    );

    if (pickedDate != null) onDateSelected(pickedDate);
  }

  Future<void> _showTimePicker({
    required Function(TimeOfDay) onTimeSelected,
    TimeOfDay? initialTime,
  }) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark()),
        child: child!,
      ),
    );

    if (pickedTime != null) onTimeSelected(pickedTime);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Task details form
            LabeledFormField(
              label: 'Task Name',
              child: StyledTextField(controller: _taskNameController),
            ),

            _buildPriorityField(),

            LabeledFormField(
              label: 'Links',
              optional: true,
              child: StyledTextField(
                controller: _linksController,
                hintText: 'Add links',
                prefixIcon: const Icon(Icons.link, color: Colors.grey),
              ),
            ),

            LabeledFormField(
              label: 'Description',
              child: StyledTextField(
                controller: _descriptionController,
                height: 120,
                maxLines: null,
                expands: true,
              ),
            ),

            _buildSubtasksSection(),
            _buildDateTimeSection(),
            _buildEmojiSection(),

            if (widget.showAddButton) _buildAddButton(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityField() {
    return LabeledFormField(
      label: 'Priority',
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(
            color: selectedPriority != null
                ? TaskFormUtils.getPriorityColor(selectedPriority)
                : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonFormField<String>(
          value: selectedPriority,
          dropdownColor: Colors.grey.shade800,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          items: TaskFormUtils.priorityOptions
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) => setState(() => selectedPriority = value),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSubtasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTasksList(
          subtasks: subtasks,
          onAdd: (subtask) => setState(() => subtasks.add(subtask)),
          onRemove: (id) =>
              setState(() => subtasks.removeWhere((item) => item.id == id)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and Time Row
        Row(
          children: [
            Expanded(
              child: DateTimePickerField(
                label: 'Date',
                displayText: selectedDate != null
                    ? TaskFormUtils.formatDate(selectedDate!)
                    : null,
                hintText: 'Select date',
                icon: Icons.calendar_today,
                onTap: () => _showDatePicker(
                  onDateSelected: (date) => setState(() => selectedDate = date),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DateTimePickerField(
                label: 'Time',
                displayText: selectedTime != null
                    ? TaskFormUtils.formatTime(selectedTime!)
                    : null,
                hintText: 'Select time',
                icon: Icons.access_time,
                onTap: () => _showTimePicker(
                  initialTime: selectedTime,
                  onTimeSelected: (time) => setState(() => selectedTime = time),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Deadline, Reminder and Repeat
        Row(
          children: [
            Expanded(
              child: DateTimePickerField(
                label: 'Deadline Date (Optional)',
                displayText: selectedDeadline != null
                    ? TaskFormUtils.formatDate(selectedDeadline!)
                    : null,
                hintText: 'Select deadline',
                icon: Icons.crisis_alert,
                onTap: () => _showDatePicker(
                  onDateSelected: (date) {
                    setState(() => selectedDeadline = date);

                    // Automatically prompt for time selection if no time is set yet
                    if (selectedDeadlineTime == null) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _showTimePicker(
                          onTimeSelected: (time) =>
                              setState(() => selectedDeadlineTime = time),
                        );
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DateTimePickerField(
                label: 'Deadline Time' + (selectedDeadline != null ? ' *' : ''),
                displayText: selectedDeadlineTime != null
                    ? TaskFormUtils.formatTime(selectedDeadlineTime!)
                    : null,
                hintText: 'Select time',
                icon: Icons.access_time_filled,
                onTap: () => _showTimePicker(
                  initialTime: selectedDeadlineTime,
                  onTimeSelected: (time) =>
                      setState(() => selectedDeadlineTime = time),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: DateTimePickerField(
                label: 'Set Reminder',
                displayText: selectedReminder != null
                    ? TaskFormUtils.formatTime(selectedReminder!)
                    : null,
                hintText: 'Set time',
                icon: Icons.notifications_none,
                onTap: () => _showTimePicker(
                  onTimeSelected: (time) =>
                      setState(() => selectedReminder = time),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _buildRepeatField()),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRepeatField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Repeat',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedRepeat,
            dropdownColor: Colors.grey.shade800,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              isDense: true,
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.white),
            items: TaskFormUtils.repeatOptions
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 13)),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => selectedRepeat = value),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Emoji',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Selected Emoji
        Center(
          child: EmojiHelper.buildSelectedEmojiDisplay(
            showAnimatedEmojis,
            selectedEmojiIndex,
            selectedAnimatedEmojiIndex,
          ),
        ),
        const SizedBox(height: 8),

        // Emoji type toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmojiHelper.buildEmojiTypeChip('Standard', !showAnimatedEmojis, (
              selected,
            ) {
              if (selected) setState(() => showAnimatedEmojis = false);
            }),
            const SizedBox(width: 8),
            EmojiHelper.buildEmojiTypeChip('Animated', showAnimatedEmojis, (
              selected,
            ) {
              if (selected) setState(() => showAnimatedEmojis = true);
            }),
          ],
        ),
        const SizedBox(height: 8),

        // Emoji Selection Grid
        SizedBox(
          height: 70,
          child: !showAnimatedEmojis
              ? EmojiHelper.buildEmojiGrid(
                  selectedEmojiIndex,
                  (index) => setState(() => selectedEmojiIndex = index),
                )
              : EmojiHelper.buildAnimatedEmojiGrid(
                  selectedAnimatedEmojiIndex,
                  (index) => setState(() => selectedAnimatedEmojiIndex = index),
                ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: _validateAndAddTask,
        child: const Text(
          'Add Task',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
