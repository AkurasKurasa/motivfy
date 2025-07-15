/// This class provides access to all app icons used throughout the application.
/// It serves as a central place to manage icons, making it easy to update them globally.
class AppIcons {
  // Slider Menu Button Icons
  static const String blockList =
      'assets/Home_Page/SliderMenuButton/BlockList.svg';
  static const String noteFlow =
      'assets/Home_Page/SliderMenuButton/NotefFlow_Logo_Main.svg';
  static const String pomodoroTimer =
      'assets/Home_Page/SliderMenuButton/PomodoroTimer.svg';
  static const String productivityAssistant =
      'assets/Home_Page/SliderMenuButton/ProductivityAssistant.svg';

  // Navigation Icons
  static const String home = 'assets/Home_Dark.svg';
  static const String profile = 'assets/Profile.svg';
  static const String settings = 'assets/settings.svg';
  static const String start = 'assets/start.svg';

  // NoteFlow Page Icons
  static const String manualType = 'assets/ManualType.svg';

  // Home Dashboard Icons
  static const String crown = 'assets/Home_Page/HomeDash/crown.svg';

  // Add more icon categories and paths as needed

  /// Returns the list of slide menu icons
  static List<String> get sliderMenuIcons => [
    blockList,
    noteFlow,
    pomodoroTimer,
    productivityAssistant,
  ];
}
