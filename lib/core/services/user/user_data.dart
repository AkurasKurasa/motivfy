import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../features/tasks/data/services/task_service.dart';

/// Individual_User_Data is a comprehensive class that stores all user-related information
/// for the Motivfy application. This will be used for future database connections.
class Individual_User_Data {
  // Personal Information
  PersonalInfo personalInfo;

  // Log Information
  LogInfo logInfo;

  // App Settings
  AppSettings settings;

  // Tasks and Notes
  TasksAndNotes tasksAndNotes;

  // Pomodoro Timer Settings
  PomodoroSettings pomodoroSettings;

  // Blocked Apps Configuration
  BlockList blockList;

  // Productivity Assistant Data
  ProductivityData productivityData;

  // Done Lists
  DoneList doneList;

  // AI Chat Messages (for future implementation)
  AIChatHistory aiChatHistory;

  /// Constructor
  Individual_User_Data({
    PersonalInfo? personalInfo,
    LogInfo? logInfo,
    AppSettings? settings,
    TasksAndNotes? tasksAndNotes,
    PomodoroSettings? pomodoroSettings,
    BlockList? blockList,
    ProductivityData? productivityData,
    DoneList? doneList,
    AIChatHistory? aiChatHistory,
  }) : personalInfo = personalInfo ?? PersonalInfo(),
       logInfo = logInfo ?? LogInfo(),
       settings = settings ?? AppSettings(),
       tasksAndNotes = tasksAndNotes ?? TasksAndNotes(),
       pomodoroSettings = pomodoroSettings ?? PomodoroSettings(),
       blockList = blockList ?? BlockList(),
       productivityData = productivityData ?? ProductivityData(),
       doneList = doneList ?? DoneList(),
       aiChatHistory = aiChatHistory ?? AIChatHistory();

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'logInfo': logInfo.toJson(),
      'settings': settings.toJson(),
      'tasksAndNotes': tasksAndNotes.toJson(),
      'pomodoroSettings': pomodoroSettings.toJson(),
      'blockList': blockList.toJson(),
      'productivityData': productivityData.toJson(),
      'doneList': doneList.toJson(),
      'aiChatHistory': aiChatHistory.toJson(),
    };
  }

  // Create from JSON
  factory Individual_User_Data.fromJson(Map<String, dynamic> json) {
    return Individual_User_Data(
      personalInfo: PersonalInfo.fromJson(json['personalInfo']),
      logInfo: LogInfo.fromJson(json['logInfo']),
      settings: AppSettings.fromJson(json['settings']),
      tasksAndNotes: TasksAndNotes.fromJson(json['tasksAndNotes']),
      pomodoroSettings: PomodoroSettings.fromJson(json['pomodoroSettings']),
      blockList: BlockList.fromJson(json['blockList']),
      productivityData: ProductivityData.fromJson(json['productivityData']),
      doneList: DoneList.fromJson(json['doneList']),
      aiChatHistory: AIChatHistory.fromJson(json['aiChatHistory']),
    );
  }

  // Serialize to string (for storage)
  String serialize() {
    return jsonEncode(toJson());
  }

  // Deserialize from string
  factory Individual_User_Data.deserialize(String data) {
    return Individual_User_Data.fromJson(jsonDecode(data));
  }
}

/// Personal information about the user
class PersonalInfo {
  String? name;
  int? age;
  String? email;
  String? profilePicture;
  DateTime? dateOfBirth;
  String? phoneNumber;

  PersonalInfo({
    this.name,
    this.age,
    this.email,
    this.profilePicture,
    this.dateOfBirth,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
      'profilePicture': profilePicture,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phoneNumber': phoneNumber,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PersonalInfo();
    return PersonalInfo(
      name: json['name'],
      age: json['age'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      phoneNumber: json['phoneNumber'],
    );
  }
}

/// Log information tracking user activities
class LogInfo {
  List<LoginSession> loginHistory;
  List<TaskHistory> tasksHistory;
  DateTime lastActive;
  int totalSessionsCount;
  double totalActiveTimeInHours;

  LogInfo({
    List<LoginSession>? loginHistory,
    List<TaskHistory>? tasksHistory,
    DateTime? lastActive,
    this.totalSessionsCount = 0,
    this.totalActiveTimeInHours = 0.0,
  }) : loginHistory = loginHistory ?? [],
       tasksHistory = tasksHistory ?? [],
       lastActive = lastActive ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'loginHistory': loginHistory.map((session) => session.toJson()).toList(),
      'tasksHistory': tasksHistory.map((task) => task.toJson()).toList(),
      'lastActive': lastActive.toIso8601String(),
      'totalSessionsCount': totalSessionsCount,
      'totalActiveTimeInHours': totalActiveTimeInHours,
    };
  }

  factory LogInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LogInfo();
    return LogInfo(
      loginHistory:
          (json['loginHistory'] as List?)
              ?.map((e) => LoginSession.fromJson(e))
              .toList() ??
          [],
      tasksHistory:
          (json['tasksHistory'] as List?)
              ?.map((e) => TaskHistory.fromJson(e))
              .toList() ??
          [],
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : DateTime.now(),
      totalSessionsCount: json['totalSessionsCount'] ?? 0,
      totalActiveTimeInHours: json['totalActiveTimeInHours'] ?? 0.0,
    );
  }

  // Add a new login session
  void addLoginSession(LoginSession session) {
    loginHistory.add(session);
    totalSessionsCount++;
    lastActive = DateTime.now();
  }

  // Add a task history entry
  void addTaskHistory(TaskHistory taskHistory) {
    tasksHistory.add(taskHistory);
  }
}

/// Represents a single login session
class LoginSession {
  DateTime loginTime;
  DateTime? logoutTime;
  String deviceInfo;
  String ipAddress;
  String location;

  LoginSession({
    DateTime? loginTime,
    this.logoutTime,
    this.deviceInfo = '',
    this.ipAddress = '',
    this.location = '',
  }) : loginTime = loginTime ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'loginTime': loginTime.toIso8601String(),
      'logoutTime': logoutTime?.toIso8601String(),
      'deviceInfo': deviceInfo,
      'ipAddress': ipAddress,
      'location': location,
    };
  }

  factory LoginSession.fromJson(Map<String, dynamic> json) {
    return LoginSession(
      loginTime: DateTime.parse(json['loginTime']),
      logoutTime: json['logoutTime'] != null
          ? DateTime.parse(json['logoutTime'])
          : null,
      deviceInfo: json['deviceInfo'] ?? '',
      ipAddress: json['ipAddress'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

/// History of task changes for tracking user progress
class TaskHistory {
  String taskId;
  String action; // 'created', 'completed', 'deleted', 'modified'
  DateTime timestamp;
  Map<String, dynamic> taskData;
  Map<String, dynamic>? changes; // For 'modified' action

  TaskHistory({
    required this.taskId,
    required this.action,
    DateTime? timestamp,
    required this.taskData,
    this.changes,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'taskData': taskData,
      'changes': changes,
    };
  }

  factory TaskHistory.fromJson(Map<String, dynamic> json) {
    return TaskHistory(
      taskId: json['taskId'],
      action: json['action'],
      timestamp: DateTime.parse(json['timestamp']),
      taskData: json['taskData'],
      changes: json['changes'],
    );
  }
}

/// Application settings and configuration
class AppSettings {
  // Theme settings
  bool isDarkMode;
  Color accentColor;
  double fontSize;

  // Notification settings
  bool enableNotifications;
  bool enableSounds;
  bool enableVibration;

  // Privacy settings
  bool collectAnalytics;
  bool showTasksOnLockScreen;

  // General settings
  String language;
  bool autoSync;
  int syncFrequency; // In minutes
  bool startupScreen; // Which screen to show on startup

  // Task settings
  int defaultTaskPriority; // 0: Low, 1: Medium, 2: High
  String defaultTaskView; // 'list', 'calendar', 'kanban'

  AppSettings({
    this.isDarkMode = true,
    Color? accentColor,
    this.fontSize = 14.0,
    this.enableNotifications = true,
    this.enableSounds = true,
    this.enableVibration = true,
    this.collectAnalytics = false,
    this.showTasksOnLockScreen = false,
    this.language = 'English',
    this.autoSync = true,
    this.syncFrequency = 60,
    this.startupScreen = true,
    this.defaultTaskPriority = 1,
    this.defaultTaskView = 'list',
  }) : accentColor = accentColor ?? Colors.blue;

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'accentColor': accentColor.value,
      'fontSize': fontSize,
      'enableNotifications': enableNotifications,
      'enableSounds': enableSounds,
      'enableVibration': enableVibration,
      'collectAnalytics': collectAnalytics,
      'showTasksOnLockScreen': showTasksOnLockScreen,
      'language': language,
      'autoSync': autoSync,
      'syncFrequency': syncFrequency,
      'startupScreen': startupScreen,
      'defaultTaskPriority': defaultTaskPriority,
      'defaultTaskView': defaultTaskView,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AppSettings();
    return AppSettings(
      isDarkMode: json['isDarkMode'] ?? true,
      accentColor: Color(json['accentColor'] ?? Colors.blue.value),
      fontSize: json['fontSize'] ?? 14.0,
      enableNotifications: json['enableNotifications'] ?? true,
      enableSounds: json['enableSounds'] ?? true,
      enableVibration: json['enableVibration'] ?? true,
      collectAnalytics: json['collectAnalytics'] ?? false,
      showTasksOnLockScreen: json['showTasksOnLockScreen'] ?? false,
      language: json['language'] ?? 'English',
      autoSync: json['autoSync'] ?? true,
      syncFrequency: json['syncFrequency'] ?? 60,
      startupScreen: json['startupScreen'] ?? true,
      defaultTaskPriority: json['defaultTaskPriority'] ?? 1,
      defaultTaskView: json['defaultTaskView'] ?? 'list',
    );
  }
}

/// Tasks and Notes management
class TasksAndNotes {
  List<TaskData> tasks;
  List<NoteData> notes;
  int totalTasksCreated;
  int totalTasksCompleted;
  int totalNotesCreated;

  TasksAndNotes({
    List<TaskData>? tasks,
    List<NoteData>? notes,
    this.totalTasksCreated = 0,
    this.totalTasksCompleted = 0,
    this.totalNotesCreated = 0,
  }) : tasks = tasks ?? [],
       notes = notes ?? [];

  Map<String, dynamic> toJson() {
    return {
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'notes': notes.map((note) => note.toJson()).toList(),
      'totalTasksCreated': totalTasksCreated,
      'totalTasksCompleted': totalTasksCompleted,
      'totalNotesCreated': totalNotesCreated,
    };
  }

  factory TasksAndNotes.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TasksAndNotes();
    return TasksAndNotes(
      tasks:
          (json['tasks'] as List?)?.map((e) => TaskData.fromJson(e)).toList() ??
          [],
      notes:
          (json['notes'] as List?)?.map((e) => NoteData.fromJson(e)).toList() ??
          [],
      totalTasksCreated: json['totalTasksCreated'] ?? 0,
      totalTasksCompleted: json['totalTasksCompleted'] ?? 0,
      totalNotesCreated: json['totalNotesCreated'] ?? 0,
    );
  }

  // Add a new task
  void addTask(TaskData task) {
    tasks.add(task);
    totalTasksCreated++;
  }

  // Complete a task
  void completeTask(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      tasks[index].isCompleted = true;
      tasks[index].completedDate = DateTime.now();
      totalTasksCompleted++;
    }
  }

  // Add a new note
  void addNote(NoteData note) {
    notes.add(note);
    totalNotesCreated++;
  }
}

/// Task data model
class TaskData {
  String id;
  String title;
  String description;
  DateTime createdDate;
  DateTime? dueDate;
  DateTime? completedDate;
  bool isCompleted;
  bool isUrgent;
  bool isImportant;
  String priority; // 'Normal', 'Important', 'Urgent'
  String icon;
  bool isAnimatedEmoji;
  String time;
  int colorValue;
  String repeat; // 'Never', 'Daily', 'Weekly', 'Monthly'
  List<String> tags;

  TaskData({
    required this.id,
    required this.title,
    this.description = '',
    DateTime? createdDate,
    this.dueDate,
    this.completedDate,
    this.isCompleted = false,
    this.isUrgent = false,
    this.isImportant = false,
    this.priority = 'Normal',
    required this.icon,
    this.isAnimatedEmoji = false,
    required this.time,
    required this.colorValue,
    this.repeat = 'Never',
    List<String>? tags,
  }) : createdDate = createdDate ?? DateTime.now(),
       tags = tags ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'isUrgent': isUrgent,
      'isImportant': isImportant,
      'priority': priority,
      'icon': icon,
      'isAnimatedEmoji': isAnimatedEmoji,
      'time': time,
      'colorValue': colorValue,
      'repeat': repeat,
      'tags': tags,
    };
  }

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      createdDate: DateTime.parse(json['createdDate']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
      isUrgent: json['isUrgent'] ?? false,
      isImportant: json['isImportant'] ?? false,
      priority: json['priority'] ?? 'Normal',
      icon: json['icon'],
      isAnimatedEmoji: json['isAnimatedEmoji'] ?? false,
      time: json['time'],
      colorValue: json['colorValue'],
      repeat: json['repeat'] ?? 'Never',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

/// Note data model
class NoteData {
  String id;
  String content;
  String title;
  DateTime createdDate;
  DateTime lastEditedDate;
  List<String> tags;
  int textAlignment; // 0: left, 1: center, 2: right, 3: justify
  bool isFavorite;
  List<String>? attachedFiles;

  NoteData({
    required this.id,
    required this.content,
    this.title = '',
    DateTime? createdDate,
    DateTime? lastEditedDate,
    List<String>? tags,
    this.textAlignment = 0,
    this.isFavorite = false,
    this.attachedFiles,
  }) : createdDate = createdDate ?? DateTime.now(),
       lastEditedDate = lastEditedDate ?? DateTime.now(),
       tags = tags ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'title': title,
      'createdDate': createdDate.toIso8601String(),
      'lastEditedDate': lastEditedDate.toIso8601String(),
      'tags': tags,
      'textAlignment': textAlignment,
      'isFavorite': isFavorite,
      'attachedFiles': attachedFiles,
    };
  }

  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
      id: json['id'],
      content: json['content'],
      title: json['title'] ?? '',
      createdDate: DateTime.parse(json['createdDate']),
      lastEditedDate: DateTime.parse(json['lastEditedDate']),
      tags: List<String>.from(json['tags'] ?? []),
      textAlignment: json['textAlignment'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      attachedFiles: json['attachedFiles'] != null
          ? List<String>.from(json['attachedFiles'])
          : null,
    );
  }
}

/// Pomodoro Timer Settings
class PomodoroSettings {
  int workDurationMinutes;
  int shortBreakDurationMinutes;
  int longBreakDurationMinutes;
  int sessionsBeforeLongBreak;
  bool autoStartBreaks;
  bool autoStartPomodoros;
  bool enableSounds;
  String workSound;
  String breakSound;
  double soundVolume;
  List<PomodoroSession> history;
  int totalSessionsCompleted;
  double totalWorkTimeInHours;

  PomodoroSettings({
    this.workDurationMinutes = 25,
    this.shortBreakDurationMinutes = 5,
    this.longBreakDurationMinutes = 15,
    this.sessionsBeforeLongBreak = 4,
    this.autoStartBreaks = true,
    this.autoStartPomodoros = false,
    this.enableSounds = true,
    this.workSound = 'default',
    this.breakSound = 'default',
    this.soundVolume = 0.7,
    List<PomodoroSession>? history,
    this.totalSessionsCompleted = 0,
    this.totalWorkTimeInHours = 0.0,
  }) : history = history ?? [];

  Map<String, dynamic> toJson() {
    return {
      'workDurationMinutes': workDurationMinutes,
      'shortBreakDurationMinutes': shortBreakDurationMinutes,
      'longBreakDurationMinutes': longBreakDurationMinutes,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
      'autoStartBreaks': autoStartBreaks,
      'autoStartPomodoros': autoStartPomodoros,
      'enableSounds': enableSounds,
      'workSound': workSound,
      'breakSound': breakSound,
      'soundVolume': soundVolume,
      'history': history.map((session) => session.toJson()).toList(),
      'totalSessionsCompleted': totalSessionsCompleted,
      'totalWorkTimeInHours': totalWorkTimeInHours,
    };
  }

  factory PomodoroSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PomodoroSettings();
    return PomodoroSettings(
      workDurationMinutes: json['workDurationMinutes'] ?? 25,
      shortBreakDurationMinutes: json['shortBreakDurationMinutes'] ?? 5,
      longBreakDurationMinutes: json['longBreakDurationMinutes'] ?? 15,
      sessionsBeforeLongBreak: json['sessionsBeforeLongBreak'] ?? 4,
      autoStartBreaks: json['autoStartBreaks'] ?? true,
      autoStartPomodoros: json['autoStartPomodoros'] ?? false,
      enableSounds: json['enableSounds'] ?? true,
      workSound: json['workSound'] ?? 'default',
      breakSound: json['breakSound'] ?? 'default',
      soundVolume: json['soundVolume'] ?? 0.7,
      history:
          (json['history'] as List?)
              ?.map((e) => PomodoroSession.fromJson(e))
              .toList() ??
          [],
      totalSessionsCompleted: json['totalSessionsCompleted'] ?? 0,
      totalWorkTimeInHours: json['totalWorkTimeInHours'] ?? 0.0,
    );
  }

  // Add a completed session
  void addCompletedSession(PomodoroSession session) {
    history.add(session);
    totalSessionsCompleted++;
    totalWorkTimeInHours += session.durationMinutes / 60.0;
  }
}

/// Pomodoro Session
class PomodoroSession {
  DateTime startTime;
  DateTime endTime;
  int durationMinutes;
  String sessionType; // 'work', 'shortBreak', 'longBreak'
  String? taskId; // Optional associated task

  PomodoroSession({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.sessionType,
    this.taskId,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'sessionType': sessionType,
      'taskId': taskId,
    };
  }

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      durationMinutes: json['durationMinutes'],
      sessionType: json['sessionType'],
      taskId: json['taskId'],
    );
  }
}

/// Blocked Apps Configuration
class BlockList {
  List<BlockedApp> blockedApps;
  bool isEnabled;
  List<BlockSchedule> schedules;
  bool blockNotifications;
  bool allowOverride;
  String? overridePassword;
  bool blockWebsites;
  List<String> blockedWebsites;

  BlockList({
    List<BlockedApp>? blockedApps,
    this.isEnabled = false,
    List<BlockSchedule>? schedules,
    this.blockNotifications = true,
    this.allowOverride = true,
    this.overridePassword,
    this.blockWebsites = true,
    List<String>? blockedWebsites,
  }) : blockedApps = blockedApps ?? [],
       schedules = schedules ?? [],
       blockedWebsites = blockedWebsites ?? [];

  Map<String, dynamic> toJson() {
    return {
      'blockedApps': blockedApps.map((app) => app.toJson()).toList(),
      'isEnabled': isEnabled,
      'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
      'blockNotifications': blockNotifications,
      'allowOverride': allowOverride,
      'overridePassword': overridePassword,
      'blockWebsites': blockWebsites,
      'blockedWebsites': blockedWebsites,
    };
  }

  factory BlockList.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BlockList();
    return BlockList(
      blockedApps:
          (json['blockedApps'] as List?)
              ?.map((e) => BlockedApp.fromJson(e))
              .toList() ??
          [],
      isEnabled: json['isEnabled'] ?? false,
      schedules:
          (json['schedules'] as List?)
              ?.map((e) => BlockSchedule.fromJson(e))
              .toList() ??
          [],
      blockNotifications: json['blockNotifications'] ?? true,
      allowOverride: json['allowOverride'] ?? true,
      overridePassword: json['overridePassword'],
      blockWebsites: json['blockWebsites'] ?? true,
      blockedWebsites: List<String>.from(json['blockedWebsites'] ?? []),
    );
  }

  // Add a blocked app
  void addBlockedApp(BlockedApp app) {
    blockedApps.add(app);
  }

  // Add a blocking schedule
  void addSchedule(BlockSchedule schedule) {
    schedules.add(schedule);
  }
}

/// Blocked App
class BlockedApp {
  String packageName;
  String appName;
  String? appIcon;
  bool isBlocked;
  bool blockAlways;
  List<int> blockDays; // 1-7 for Monday-Sunday
  TimeOfDay? blockStartTime;
  TimeOfDay? blockEndTime;

  BlockedApp({
    required this.packageName,
    required this.appName,
    this.appIcon,
    this.isBlocked = true,
    this.blockAlways = true,
    List<int>? blockDays,
    this.blockStartTime,
    this.blockEndTime,
  }) : blockDays = blockDays ?? List.generate(7, (index) => index + 1);

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'appIcon': appIcon,
      'isBlocked': isBlocked,
      'blockAlways': blockAlways,
      'blockDays': blockDays,
      'blockStartTime': blockStartTime != null
          ? '${blockStartTime!.hour}:${blockStartTime!.minute}'
          : null,
      'blockEndTime': blockEndTime != null
          ? '${blockEndTime!.hour}:${blockEndTime!.minute}'
          : null,
    };
  }

  factory BlockedApp.fromJson(Map<String, dynamic> json) {
    TimeOfDay? startTime;
    if (json['blockStartTime'] != null) {
      final parts = json['blockStartTime'].split(':');
      startTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    TimeOfDay? endTime;
    if (json['blockEndTime'] != null) {
      final parts = json['blockEndTime'].split(':');
      endTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return BlockedApp(
      packageName: json['packageName'],
      appName: json['appName'],
      appIcon: json['appIcon'],
      isBlocked: json['isBlocked'] ?? true,
      blockAlways: json['blockAlways'] ?? true,
      blockDays: List<int>.from(json['blockDays'] ?? [1, 2, 3, 4, 5, 6, 7]),
      blockStartTime: startTime,
      blockEndTime: endTime,
    );
  }
}

/// Block Schedule
class BlockSchedule {
  String name;
  bool isEnabled;
  List<int> activeDays; // 1-7 for Monday-Sunday
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<String> appsToBlock; // Package names
  bool blockAllApps;

  BlockSchedule({
    required this.name,
    this.isEnabled = true,
    List<int>? activeDays,
    required this.startTime,
    required this.endTime,
    List<String>? appsToBlock,
    this.blockAllApps = false,
  }) : activeDays = activeDays ?? [],
       appsToBlock = appsToBlock ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isEnabled': isEnabled,
      'activeDays': activeDays,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'appsToBlock': appsToBlock,
      'blockAllApps': blockAllApps,
    };
  }

  factory BlockSchedule.fromJson(Map<String, dynamic> json) {
    final startTimeParts = json['startTime'].split(':');
    final endTimeParts = json['endTime'].split(':');

    return BlockSchedule(
      name: json['name'],
      isEnabled: json['isEnabled'] ?? true,
      activeDays: List<int>.from(json['activeDays'] ?? []),
      startTime: TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      appsToBlock: List<String>.from(json['appsToBlock'] ?? []),
      blockAllApps: json['blockAllApps'] ?? false,
    );
  }
}

/// Productivity Data
class ProductivityData {
  Map<String, double> appUsageTimeInHours; // App package name -> hours spent
  List<ProductivitySession> sessions;
  List<DailyProductivityStats> dailyStats;
  double productivityScore; // 0-100
  int focusStreakDays;
  int tasksCompletedToday;

  ProductivityData({
    Map<String, double>? appUsageTimeInHours,
    List<ProductivitySession>? sessions,
    List<DailyProductivityStats>? dailyStats,
    this.productivityScore = 0,
    this.focusStreakDays = 0,
    this.tasksCompletedToday = 0,
  }) : appUsageTimeInHours = appUsageTimeInHours ?? {},
       sessions = sessions ?? [],
       dailyStats = dailyStats ?? [];

  Map<String, dynamic> toJson() {
    return {
      'appUsageTimeInHours': appUsageTimeInHours,
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'dailyStats': dailyStats.map((stats) => stats.toJson()).toList(),
      'productivityScore': productivityScore,
      'focusStreakDays': focusStreakDays,
      'tasksCompletedToday': tasksCompletedToday,
    };
  }

  factory ProductivityData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProductivityData();
    return ProductivityData(
      appUsageTimeInHours:
          (json['appUsageTimeInHours'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as double),
          ) ??
          {},
      sessions:
          (json['sessions'] as List?)
              ?.map((e) => ProductivitySession.fromJson(e))
              .toList() ??
          [],
      dailyStats:
          (json['dailyStats'] as List?)
              ?.map((e) => DailyProductivityStats.fromJson(e))
              .toList() ??
          [],
      productivityScore: json['productivityScore'] ?? 0,
      focusStreakDays: json['focusStreakDays'] ?? 0,
      tasksCompletedToday: json['tasksCompletedToday'] ?? 0,
    );
  }

  // Track app usage time
  void trackAppUsage(String packageName, double hoursSpent) {
    appUsageTimeInHours[packageName] =
        (appUsageTimeInHours[packageName] ?? 0) + hoursSpent;
  }

  // Add a productivity session
  void addSession(ProductivitySession session) {
    sessions.add(session);

    // Update daily stats
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month}-${today.day}';

    final existingStatIndex = dailyStats.indexWhere(
      (stat) => stat.date == dateStr,
    );

    if (existingStatIndex != -1) {
      dailyStats[existingStatIndex].totalFocusTimeHours +=
          session.durationMinutes / 60.0;
      dailyStats[existingStatIndex].sessionsCompleted++;
    } else {
      dailyStats.add(
        DailyProductivityStats(
          date: dateStr,
          totalFocusTimeHours: session.durationMinutes / 60.0,
          sessionsCompleted: 1,
          tasksCompleted: 0,
        ),
      );
    }
  }
}

/// Productivity Session
class ProductivitySession {
  DateTime startTime;
  DateTime endTime;
  int durationMinutes;
  String? taskId;
  String? category;
  bool wasDistracted;
  int distractionCount;

  ProductivitySession({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.taskId,
    this.category,
    this.wasDistracted = false,
    this.distractionCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'taskId': taskId,
      'category': category,
      'wasDistracted': wasDistracted,
      'distractionCount': distractionCount,
    };
  }

  factory ProductivitySession.fromJson(Map<String, dynamic> json) {
    return ProductivitySession(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      durationMinutes: json['durationMinutes'],
      taskId: json['taskId'],
      category: json['category'],
      wasDistracted: json['wasDistracted'] ?? false,
      distractionCount: json['distractionCount'] ?? 0,
    );
  }
}

/// Daily Productivity Statistics
class DailyProductivityStats {
  String date; // YYYY-MM-DD format
  double totalFocusTimeHours;
  int sessionsCompleted;
  int tasksCompleted;
  Map<String, double>? appUsageBreakdown;
  double productivityScore;

  DailyProductivityStats({
    required this.date,
    this.totalFocusTimeHours = 0.0,
    this.sessionsCompleted = 0,
    this.tasksCompleted = 0,
    this.appUsageBreakdown,
    this.productivityScore = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'totalFocusTimeHours': totalFocusTimeHours,
      'sessionsCompleted': sessionsCompleted,
      'tasksCompleted': tasksCompleted,
      'appUsageBreakdown': appUsageBreakdown,
      'productivityScore': productivityScore,
    };
  }

  factory DailyProductivityStats.fromJson(Map<String, dynamic> json) {
    return DailyProductivityStats(
      date: json['date'],
      totalFocusTimeHours: json['totalFocusTimeHours'] ?? 0.0,
      sessionsCompleted: json['sessionsCompleted'] ?? 0,
      tasksCompleted: json['tasksCompleted'] ?? 0,
      appUsageBreakdown: (json['appUsageBreakdown'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as double)),
      productivityScore: json['productivityScore'] ?? 0.0,
    );
  }
}

/// Done Lists
class DoneList {
  List<DoneItem> items;
  int totalItemsCompleted;
  Map<String, int> categoryCounts;

  DoneList({
    List<DoneItem>? items,
    this.totalItemsCompleted = 0,
    Map<String, int>? categoryCounts,
  }) : items = items ?? [],
       categoryCounts = categoryCounts ?? {};

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalItemsCompleted': totalItemsCompleted,
      'categoryCounts': categoryCounts,
    };
  }

  factory DoneList.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DoneList();
    return DoneList(
      items:
          (json['items'] as List?)?.map((e) => DoneItem.fromJson(e)).toList() ??
          [],
      totalItemsCompleted: json['totalItemsCompleted'] ?? 0,
      categoryCounts:
          (json['categoryCounts'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          {},
    );
  }

  // Add a done item
  void addDoneItem(DoneItem item) {
    items.add(item);
    totalItemsCompleted++;

    // Update category counts
    if (item.category != null) {
      categoryCounts[item.category!] =
          (categoryCounts[item.category!] ?? 0) + 1;
    }
  }
}

/// Done Item
class DoneItem {
  String id;
  String text;
  DateTime completedDate;
  String? category;
  String? taskId; // Reference to original task if applicable
  bool isHighlighted;

  DoneItem({
    required this.id,
    required this.text,
    DateTime? completedDate,
    this.category,
    this.taskId,
    this.isHighlighted = false,
  }) : completedDate = completedDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'completedDate': completedDate.toIso8601String(),
      'category': category,
      'taskId': taskId,
      'isHighlighted': isHighlighted,
    };
  }

  factory DoneItem.fromJson(Map<String, dynamic> json) {
    return DoneItem(
      id: json['id'],
      text: json['text'],
      completedDate: DateTime.parse(json['completedDate']),
      category: json['category'],
      taskId: json['taskId'],
      isHighlighted: json['isHighlighted'] ?? false,
    );
  }
}

/// AI Chat History
class AIChatHistory {
  List<ChatConversation> conversations;
  int totalMessagesCount;
  DateTime? lastChatDate;

  AIChatHistory({
    List<ChatConversation>? conversations,
    this.totalMessagesCount = 0,
    this.lastChatDate,
  }) : conversations = conversations ?? [];

  Map<String, dynamic> toJson() {
    return {
      'conversations': conversations.map((chat) => chat.toJson()).toList(),
      'totalMessagesCount': totalMessagesCount,
      'lastChatDate': lastChatDate?.toIso8601String(),
    };
  }

  factory AIChatHistory.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AIChatHistory();
    return AIChatHistory(
      conversations:
          (json['conversations'] as List?)
              ?.map((e) => ChatConversation.fromJson(e))
              .toList() ??
          [],
      totalMessagesCount: json['totalMessagesCount'] ?? 0,
      lastChatDate: json['lastChatDate'] != null
          ? DateTime.parse(json['lastChatDate'])
          : null,
    );
  }

  // Add a new message to a conversation
  void addMessage(String conversationId, ChatMessage message) {
    final index = conversations.indexWhere((conv) => conv.id == conversationId);

    if (index != -1) {
      conversations[index].messages.add(message);
      conversations[index].lastUpdated = DateTime.now();
    } else {
      // Create a new conversation if it doesn't exist
      final newConversation = ChatConversation(
        id: conversationId,
        title: 'New Chat',
        messages: [message],
      );
      conversations.add(newConversation);
    }

    totalMessagesCount++;
    lastChatDate = DateTime.now();
  }
}

/// Chat Conversation
class ChatConversation {
  String id;
  String title;
  List<ChatMessage> messages;
  DateTime createdAt;
  DateTime lastUpdated;
  bool isPinned;

  ChatConversation({
    required this.id,
    required this.title,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.isPinned = false,
  }) : messages = messages ?? [],
       createdAt = createdAt ?? DateTime.now(),
       lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'],
      title: json['title'],
      messages:
          (json['messages'] as List?)
              ?.map((e) => ChatMessage.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      isPinned: json['isPinned'] ?? false,
    );
  }
}

/// Chat Message
class ChatMessage {
  String id;
  String content;
  bool isUserMessage;
  DateTime timestamp;
  List<String>? attachments;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUserMessage,
    DateTime? timestamp,
    this.attachments,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUserMessage': isUserMessage,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isUserMessage: json['isUserMessage'],
      timestamp: DateTime.parse(json['timestamp']),
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
    );
  }
}

// Extension to convert TaskService Task to userData TaskData
extension TaskConversion on Task {
  TaskData toTaskData() {
    return TaskData(
      id: id,
      title: title,
      icon: icon,
      time: time,
      colorValue: color.value,
      isUrgent: isUrgent,
      isImportant: isImportant,
      priority: isUrgent
          ? 'Urgent'
          : isImportant
          ? 'Important'
          : 'Normal',
      isAnimatedEmoji: isAnimatedEmoji,
    );
  }
}
