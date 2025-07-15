import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'user_data.dart';
import '../../../features/tasks/data/services/task_service.dart';
import '../../../features/noteflow/data/services/note_flow_service.dart';
import '../logger_service.dart';

/// UserDataManager is responsible for managing the Individual_User_Data
/// and handling persistence operations.
class UserDataManager {
  // Singleton pattern
  static final UserDataManager _instance = UserDataManager._internal();
  factory UserDataManager() => _instance;
  UserDataManager._internal();

  // The user data instance
  Individual_User_Data? _userData;

  // Get the user data, initializing if necessary
  Future<Individual_User_Data> getUserData() async {
    if (_userData == null) {
      await _loadUserData();
    }
    return _userData!;
  }

  // Load user data from storage
  Future<void> _loadUserData() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        _userData = Individual_User_Data.deserialize(contents);
      } else {
        // Create a new user data instance if none exists
        _userData = Individual_User_Data();
        await saveUserData();
      }
    } catch (e) {
      LoggerService().error('Error loading user data', e);
      _userData = Individual_User_Data();
    }
  }

  // Save user data to storage
  Future<void> saveUserData() async {
    try {
      final file = await _getFile();
      await file.writeAsString(_userData!.serialize());
    } catch (e) {
      LoggerService().error('Error saving user data', e);
      // Consider adding error recovery or notification here
    }
  }

  // Get the file for storing user data
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_data.json');
  }

  // Sync tasks from TaskService to user data
  Future<void> syncTasksFromService(TaskService taskService) async {
    final userData = await getUserData();

    // Get all tasks from the service
    final tasks = taskService.getAllTasks();

    // Convert tasks to TaskData objects and update in user data
    final taskDataList = tasks.map((task) => task.toTaskData()).toList();

    // Update user data
    userData.tasksAndNotes.tasks.clear();
    userData.tasksAndNotes.tasks.addAll(taskDataList);

    // Save the updated user data
    await saveUserData();
  }

  // Sync notes from NoteFlowService to user data
  Future<void> syncNotesFromService(NoteFlowService noteFlowService) async {
    final userData = await getUserData();

    // Check if there's note text to save
    if (noteFlowService.noteText.isNotEmpty) {
      // Create a new note
      final noteData = NoteData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: noteFlowService.noteText,
        textAlignment: noteFlowService.textAlignment,
      );

      // Add the note to user data
      userData.tasksAndNotes.addNote(noteData);

      // Save the updated user data
      await saveUserData();
    }
  }

  // Add a login session
  Future<void> recordLoginSession({
    String deviceInfo = '',
    String ipAddress = '',
    String location = '',
  }) async {
    final userData = await getUserData();

    // Create a new login session
    final session = LoginSession(
      deviceInfo: deviceInfo,
      ipAddress: ipAddress,
      location: location,
    );

    // Add the session to user data
    userData.logInfo.addLoginSession(session);

    // Save the updated user data
    await saveUserData();
  }

  // Record task completion
  Future<void> recordTaskCompletion(String taskId) async {
    final userData = await getUserData();

    // Mark the task as completed
    userData.tasksAndNotes.completeTask(taskId);

    // Add to DoneList
    final taskIndex = userData.tasksAndNotes.tasks.indexWhere(
      (task) => task.id == taskId,
    );

    if (taskIndex != -1) {
      final task = userData.tasksAndNotes.tasks[taskIndex];

      // Add to done list
      final doneItem = DoneItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: task.title,
        taskId: task.id,
      );

      userData.doneList.addDoneItem(doneItem);
    }

    // Save the updated user data
    await saveUserData();
  }

  // Update app settings
  Future<void> updateAppSettings(AppSettings newSettings) async {
    final userData = await getUserData();
    userData.settings = newSettings;
    await saveUserData();
  }

  // Update pomodoro settings
  Future<void> updatePomodoroSettings(PomodoroSettings newSettings) async {
    final userData = await getUserData();
    userData.pomodoroSettings = newSettings;
    await saveUserData();
  }

  // Update personal info
  Future<void> updatePersonalInfo(PersonalInfo newInfo) async {
    final userData = await getUserData();
    userData.personalInfo = newInfo;
    await saveUserData();
  }
}
