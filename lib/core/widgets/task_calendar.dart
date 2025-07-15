import 'package:flutter/material.dart';

/// Model class for calendar days
class CalendarDay {
  final String day;
  final int month;
  final int year;
  final bool isCurrentMonth;

  CalendarDay({
    required this.day,
    required this.month,
    required this.year,
    required this.isCurrentMonth,
  });
}

/// Calendar widget for task date selection
class TaskCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final int currentMonth;
  final int currentYear;
  final Function(int, int) onMonthChanged;

  const TaskCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.currentMonth,
    required this.currentYear,
    required this.onMonthChanged,
  });

  @override
  State<TaskCalendar> createState() => _TaskCalendarState();
}

class _TaskCalendarState extends State<TaskCalendar> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Calendar header with month/year navigation
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () => _navigateMonth(-1),
                  ),
                  Text(
                    _getMonthName(widget.currentMonth) +
                        ' ${widget.currentYear}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () => _navigateMonth(1),
                  ),
                ],
              ),
            ),
            // Days of week header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                    .map(
                      (day) => SizedBox(
                        width: 32,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCalendarGrid(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      widget.currentYear,
      widget.currentMonth,
      1,
    );
    final daysInMonth = DateTime(
      widget.currentYear,
      widget.currentMonth + 1,
      0,
    ).day;

    int firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday
    final daysFromPrevMonth = firstWeekday - 1;

    final prevMonth = widget.currentMonth - 1 > 0
        ? widget.currentMonth - 1
        : 12;
    final prevMonthYear = widget.currentMonth - 1 > 0
        ? widget.currentYear
        : widget.currentYear - 1;
    final daysInPrevMonth = DateTime(prevMonthYear, prevMonth + 1, 0).day;

    final nextMonth = widget.currentMonth + 1 <= 12
        ? widget.currentMonth + 1
        : 1;
    final nextMonthYear = widget.currentMonth + 1 <= 12
        ? widget.currentYear
        : widget.currentYear + 1;

    List<List<CalendarDay>> calendarRows = [];
    List<CalendarDay> currentRow = [];

    // Add days from previous month
    for (int i = 0; i < daysFromPrevMonth; i++) {
      int day = daysInPrevMonth - daysFromPrevMonth + i + 1;
      currentRow.add(
        CalendarDay(
          day: day.toString(),
          month: prevMonth,
          year: prevMonthYear,
          isCurrentMonth: false,
        ),
      );
    }

    // Add days from current month
    for (int i = 1; i <= daysInMonth; i++) {
      currentRow.add(
        CalendarDay(
          day: i.toString(),
          month: widget.currentMonth,
          year: widget.currentYear,
          isCurrentMonth: true,
        ),
      );

      if (currentRow.length == 7) {
        calendarRows.add(currentRow);
        currentRow = [];
      }
    }

    // Add days from next month to complete the last row
    if (currentRow.isNotEmpty) {
      int daysToAdd = 7 - currentRow.length;
      for (int i = 1; i <= daysToAdd; i++) {
        currentRow.add(
          CalendarDay(
            day: i.toString(),
            month: nextMonth,
            year: nextMonthYear,
            isCurrentMonth: false,
          ),
        );
      }
      calendarRows.add(currentRow);
    }

    return Column(
      children: calendarRows.map((row) => _buildCalendarRow(row)).toList(),
    );
  }

  Widget _buildCalendarRow(List<CalendarDay> days) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          bool isSelected =
              widget.selectedDate.day.toString() == day.day &&
              widget.selectedDate.month == day.month &&
              widget.selectedDate.year == day.year;

          return GestureDetector(
            onTap: () {
              final newDate = DateTime(day.year, day.month, int.parse(day.day));
              widget.onDateChanged(newDate);

              // If it's a different month, update current month and year
              if (day.month != widget.currentMonth) {
                widget.onMonthChanged(day.month, day.year);
              }
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                day.day,
                style: TextStyle(
                  fontSize: 12,
                  color: !day.isCurrentMonth
                      ? Colors.grey.shade700
                      : isSelected
                      ? Colors.white
                      : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _navigateMonth(int direction) {
    int newMonth = widget.currentMonth + direction;
    int newYear = widget.currentYear;

    if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    } else if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    }

    widget.onMonthChanged(newMonth, newYear);
  }

  String _getMonthName(int month) {
    const months = [
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
