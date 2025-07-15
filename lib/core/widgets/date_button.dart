import 'package:flutter/material.dart';

class DateButton extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateChanged;

  DateButton({super.key, String? selectedDate, required this.onDateChanged})
    : selectedDate = selectedDate ?? _getCurrentDateFormatted();

  // Static method to get current date formatted
  static String _getCurrentDateFormatted() {
    final now = DateTime.now();
    final month = _getMonthName(now.month);
    final day = now.day.toString().padLeft(2, '0');
    final year = now.year.toString();
    return '$month $day $year';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Show date picker when tapped
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.grey.shade800,
                  onPrimary: Colors.white,
                  surface: Colors.grey.shade900,
                  onSurface: Colors.white,
                ),
                dialogTheme: DialogThemeData(
                  backgroundColor: Colors.grey.shade900,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          // Format the date and call the callback
          final String month = _getMonthName(picked.month);
          final String day = picked.day.toString().padLeft(2, '0');
          final String year = picked.year.toString();
          final String newDate = '$month $day $year';
          onDateChanged(newDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedDate,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // Static method to get month name
  static String _getMonthName(int month) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
