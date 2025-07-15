import 'package:flutter/material.dart';

/// Represents a single task in the application
class Task {
  final String id;
  final String icon;
  final String title;
  final String time;
  final Color color;
  final bool isUrgent;
  final bool isImportant;
  final DateTime date;
  final DateTime? deadline; // Added deadline field
  final String? deadlineTime; // Added deadlineTime field
  final bool isAnimatedEmoji;
  final List<SubTask> subtasks; // Added subtasks field
  final String? description; // Added description field
  final String? links; // Added links field
  final bool isArchived; // New field to track if task is archived
  final bool isCompleted; // New field to track if task is completed
  final DateTime? archivedDate; // When the task was archived
  final bool isDeleted; // New field to track if task is deleted
  final DateTime? deletedDate; // When the task was deleted

  Task({
    required this.id,
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
    required this.isUrgent,
    required this.isImportant,
    required this.date,
    this.deadline, // Added deadline parameter
    this.deadlineTime, // Added deadlineTime parameter
    this.isAnimatedEmoji = false,
    this.subtasks = const [], // Default to empty list
    this.description, // Added description parameter
    this.links, // Added links parameter
    this.isArchived = false, // Default to not archived
    this.isCompleted = false, // Default to not completed
    this.archivedDate, // When the task was archived
    this.isDeleted = false, // Default to not deleted
    this.deletedDate, // When the task was deleted
  });

  /// Create a copy of this task with updated fields
  Task copyWith({
    String? id,
    String? icon,
    String? title,
    String? time,
    Color? color,
    bool? isUrgent,
    bool? isImportant,
    DateTime? date,
    DateTime? deadline,
    String? deadlineTime,
    bool? isAnimatedEmoji,
    List<SubTask>? subtasks,
    String? description,
    String? links,
    bool? isArchived,
    bool? isCompleted,
    DateTime? archivedDate,
    bool? isDeleted,
    DateTime? deletedDate,
  }) {
    return Task(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      time: time ?? this.time,
      color: color ?? this.color,
      isUrgent: isUrgent ?? this.isUrgent,
      isImportant: isImportant ?? this.isImportant,
      date: date ?? this.date,
      deadline: deadline ?? this.deadline,
      deadlineTime: deadlineTime ?? this.deadlineTime,
      isAnimatedEmoji: isAnimatedEmoji ?? this.isAnimatedEmoji,
      subtasks: subtasks ?? this.subtasks,
      description: description ?? this.description,
      links: links ?? this.links,
      isArchived: isArchived ?? this.isArchived,
      isCompleted: isCompleted ?? this.isCompleted,
      archivedDate: archivedDate ?? this.archivedDate,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedDate: deletedDate ?? this.deletedDate,
    );
  }
}

// New SubTask class to model individual subtasks
class SubTask {
  final String id;
  final String title;
  bool isCompleted;

  SubTask({required this.id, required this.title, this.isCompleted = false});
}

/// Service class to manage and provide tasks
class TaskService extends ChangeNotifier {
  // Singleton pattern
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal() {
    _loadSampleTasks(); // Load sample tasks when service is initialized
  }

  // List to store tasks
  final List<Task> _tasks = [];

  // Performance optimization: Add caching
  final Map<String, List<Task>> _filteredTasksCache = {};
  final Map<String, List<Task>> _dateTasksCache = {};

  void _clearCache() {
    _filteredTasksCache.clear();
    _dateTasksCache.clear();
  }

  @override
  void notifyListeners() {
    _clearCache(); // Clear cache when data changes
    super.notifyListeners();
  }

  /// Load sample tasks for testing
  void _loadSampleTasks() {
    final today = DateTime.now();
    _tasks.addAll([
      Task(
        id: '1',
        icon: '📌',
        title: 'Complete Flutter Project',
        time: '09:00',
        color: Colors.blue,
        isUrgent: true,
        isImportant: true,
        date: today,
        deadline: today.add(Duration(days: 2)),
        deadlineTime: '18:00',
        description:
            'Complete the mobile app development project with all features including task management, analytics, and user interface improvements.',
        links: 'https://github.com/yourproject/flutter-app',
        subtasks: [
          SubTask(id: '1-1', title: 'Design UI components', isCompleted: true),
          SubTask(
            id: '1-2',
            title: 'Implement task service',
            isCompleted: true,
          ),
          SubTask(id: '1-3', title: 'Add animations', isCompleted: false),
          SubTask(
            id: '1-4',
            title: 'Test on different devices',
            isCompleted: false,
          ),
        ],
      ),
      Task(
        id: '2',
        icon: 'assets/AnimatedEmojis/Book Reading.json',
        title: 'Study for Exam',
        time: '14:30',
        color: Colors.green,
        isUrgent: false,
        isImportant: true,
        date: today,
        description:
            'Prepare for the upcoming computer science exam covering algorithms, data structures, and system design.',
        isAnimatedEmoji: true,
        subtasks: [
          SubTask(
            id: '2-1',
            title: 'Review sorting algorithms',
            isCompleted: true,
          ),
          SubTask(
            id: '2-2',
            title: 'Practice coding problems',
            isCompleted: false,
          ),
          SubTask(id: '2-3', title: 'Study system design', isCompleted: false),
        ],
      ),
      Task(
        id: '3',
        icon: '💡',
        title: 'Team Meeting',
        time: '16:00',
        color: Colors.orange,
        isUrgent: false,
        isImportant: false,
        date: today,
        description:
            'Weekly team meeting to discuss project progress and upcoming deadlines.',
        subtasks: [
          SubTask(id: '3-1', title: 'Prepare agenda', isCompleted: true),
          SubTask(id: '3-2', title: 'Review team progress', isCompleted: false),
        ],
      ),
      Task(
        id: '4',
        icon: '🚀',
        title: 'Launch Product',
        time: '10:00',
        color: Colors.red,
        isUrgent: true,
        isImportant: true,
        date: today.add(Duration(days: 1)),
        deadline: today.add(Duration(days: 1)),
        deadlineTime: '17:00',
        description:
            'Final product launch with marketing campaign and customer support ready.',
        links: 'https://example.com/product-launch',
      ),
    ]);
  }

  /// Get all tasks (not archived and not deleted) - with caching
  List<Task> getAllTasks() {
    const cacheKey = 'all_tasks';

    // Check cache first
    if (_filteredTasksCache.containsKey(cacheKey)) {
      return _filteredTasksCache[cacheKey]!;
    }

    final tasks = _tasks
        .where((task) => !task.isArchived && !task.isDeleted)
        .toList();

    // Cache the result
    _filteredTasksCache[cacheKey] = tasks;

    return List.unmodifiable(tasks);
  }

  /// Get tasks for a specific date (not archived and not deleted) - with caching
  List<Task> getTasksForDate(DateTime date) {
    final cacheKey = '${date.year}-${date.month}-${date.day}';

    // Check cache first
    if (_dateTasksCache.containsKey(cacheKey)) {
      final cachedTasks = _dateTasksCache[cacheKey]!;
      print(
        'TaskService: Using cached tasks for date: $cacheKey, found ${cachedTasks.length} tasks',
      );
      return cachedTasks;
    }

    final filteredTasks = _tasks
        .where(
          (task) =>
              !task.isArchived &&
              !task.isDeleted &&
              task.date.year == date.year &&
              task.date.month == date.month &&
              task.date.day == date.day,
        )
        .toList();

    // Cache the result
    _dateTasksCache[cacheKey] = filteredTasks;

    print(
      'TaskService: Filtering tasks for date: ${date.toString()}, found ${filteredTasks.length} tasks (cached)',
    );

    return filteredTasks;
  }

  /// Get archived tasks with optional filter
  List<Task> getArchivedTasks(String filter) {
    List<Task> archivedTasks = _tasks
        .where((task) => task.isArchived && !task.isDeleted)
        .toList();

    switch (filter) {
      case 'Completed':
        return archivedTasks.where((task) => task.isCompleted).toList();
      case 'Overdue':
        final now = DateTime.now();
        return archivedTasks
            .where(
              (task) =>
                  task.deadline != null &&
                  task.deadline!.isBefore(now) &&
                  !task.isCompleted,
            )
            .toList();
      case 'Incoming':
        final now = DateTime.now();
        return archivedTasks
            .where(
              (task) =>
                  task.deadline != null &&
                  task.deadline!.isAfter(now) &&
                  !task.isCompleted,
            )
            .toList();
      default: // 'All Tasks'
        return archivedTasks;
    }
  }

  /// Get deleted tasks
  List<Task> getDeletedTasks() {
    return List.unmodifiable(_tasks.where((task) => task.isDeleted).toList());
  }

  /// Add a new task
  void addTask(Task task) {
    _tasks.add(task);
    print(
      'Task added to service: ${task.title} with date ${task.date.toString()}. Notifying listeners...',
    );
    // Add more detailed date info for debugging
    print(
      'Date components: Y=${task.date.year}, M=${task.date.month}, D=${task.date.day}',
    );
    print(
      'Priority: ${task.isUrgent
          ? "Urgent"
          : task.isImportant
          ? "Important"
          : "Normal"}',
    );
    notifyListeners(); // Notify all listeners that a task was added
    print('Listeners notified.');
  }

  /// Remove a task
  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners(); // Notify all listeners that a task was removed
  }

  /// Archive a task
  void archiveTask(String id, {bool isCompleted = false}) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isArchived: true,
        isCompleted: isCompleted,
        archivedDate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  /// Unarchive a task
  void unarchiveTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isArchived: false,
        archivedDate: null,
      );
      notifyListeners();
    }
  }

  /// Mark a task as completed
  void completeTask(String id, bool isCompleted) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
      notifyListeners();
    }
  }

  /// Update a subtask's completion status
  void updateSubtaskCompletion(
    String taskId,
    String subtaskId,
    bool isCompleted,
  ) {
    print(
      '🎯 TaskService.updateSubtaskCompletion called: $taskId/$subtaskId -> $isCompleted',
    );
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);

    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      final updatedSubtasks = List<SubTask>.from(task.subtasks);
      final subtaskIndex = updatedSubtasks.indexWhere(
        (subtask) => subtask.id == subtaskId,
      );

      if (subtaskIndex != -1) {
        print(
          '✅ Updating subtask from ${updatedSubtasks[subtaskIndex].isCompleted} to $isCompleted',
        );
        updatedSubtasks[subtaskIndex].isCompleted = isCompleted;
        _tasks[taskIndex] = task.copyWith(subtasks: updatedSubtasks);
        print('🔔 Notifying listeners...');
        notifyListeners();
        print('✅ TaskService update complete');
      } else {
        print('❌ Subtask not found: $subtaskId');
      }
    } else {
      print('❌ Task not found: $taskId');
    }
  }

  /// Soft delete a task (move to deleted state)
  void deleteTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isDeleted: true,
        deletedDate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  /// Restore a deleted task
  void restoreTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isDeleted: false,
        deletedDate: null,
      );
      notifyListeners();
    }
  }

  /// Permanently delete a task (remove from memory)
  void permanentlyDeleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  /// Format time to 24-hour format
  static String formatTo24Hour(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Format TimeOfDay to string
  static String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Normal':
        return Colors.grey;
      case 'Important':
        return Colors.amber;
      case 'Urgent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
