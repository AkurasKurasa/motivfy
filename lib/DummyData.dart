import 'package:flutter/material.dart';
import 'features/home/presentation/widgets/analytics_weekly_focus.dart'; // For LegendItem

/// Provides dummy data for saved time.
class DummySavedTimeData {
  /// Returns the number of saved hours.
  static int getSavedHours() {
    return 2; // You can randomize this later if needed
  }
}

/// Provides dummy analytics data for charts and legends.
class DummyAnalyticsData {
  /// Returns bar chart data with height and color.
  static List<Map<String, dynamic>> getBarData() {
    return [
      {"height": 20.0, "color": const Color(0xFF0F63E2)}, // Focused
      {"height": 35.0, "color": const Color(0xFFFE9933)}, // Zoned out
      {"height": 50.0, "color": const Color(0xFF0F63E2)},
      {"height": 45.0, "color": const Color(0xFF0F63E2)},
      {"height": 30.0, "color": const Color(0xFFFE9933)},
      {"height": 55.0, "color": const Color(0xFF0F63E2)},
      {"height": 40.0, "color": const Color(0xFFFE9933)},
    ];
  }

  /// Returns the days of the week.
  static List<String> getDays() {
    return ["S", "M", "T", "W", "TH", "F", "S"];
  }

  /// Returns legend items for analytics.
  static List<LegendItem> getLegendItems() {
    return [
      LegendItem(const Color(0xFFFE9933), "Zoned out"),
      LegendItem(const Color(0xFF0F63E2), "Focused"),
    ];
  }

  /// Returns the time label for analytics.
  static String getTimeLabel() {
    return "01:23:45";
  }

  /// Returns the streak count.
  static int getStreak() {
    return 8;
  }
}
