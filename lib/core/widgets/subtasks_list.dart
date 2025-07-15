import 'package:flutter/material.dart';

class SubTaskItem {
  final TextEditingController controller;
  final String id;
  bool isCompleted;

  SubTaskItem({
    required this.controller,
    required this.id,
    this.isCompleted = false,
  });
}

class SubTasksList extends StatefulWidget {
  final List<SubTaskItem> subtasks;
  final Function(SubTaskItem) onAdd;
  final Function(String) onRemove;

  const SubTasksList({
    super.key,
    required this.subtasks,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<SubTasksList> createState() => _SubTasksListState();
}

class _SubTasksListState extends State<SubTasksList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtasks Header
        const Text(
          'Subtasks',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),

        // Subtasks List
        ...widget.subtasks.map((subtask) => _buildSubtaskItem(subtask)),

        // Add New Subtask Button
        TextButton.icon(
          onPressed: () {
            final controller = TextEditingController();
            final newSubtask = SubTaskItem(
              controller: controller,
              id: DateTime.now().millisecondsSinceEpoch.toString(),
            );
            widget.onAdd(newSubtask);
          },
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.white70,
            size: 18,
          ),
          label: const Text(
            'Add Subtask',
            style: TextStyle(color: Colors.white70),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtaskItem(SubTaskItem subtask) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          // Checkbox for completion status
          SizedBox(
            width: 44, // Increased touch area for better accessibility
            height: 44, // Increased touch area for better accessibility
            child: Transform.scale(
              scale: 1.2, // Make the visual checkbox slightly larger
              child: Checkbox(
                value: subtask.isCompleted,
                onChanged: (value) {
                  setState(() {
                    subtask.isCompleted = value ?? false;
                  });
                },
                side: const BorderSide(color: Colors.white54, width: 1.5),
                fillColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.green;
                  }
                  return Colors.transparent;
                }),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Subtask Text Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: subtask.controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Enter subtask',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          // Remove Subtask Button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54, size: 18),
            onPressed: () => widget.onRemove(subtask.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
