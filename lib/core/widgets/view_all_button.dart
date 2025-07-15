import 'package:flutter/material.dart';
import 'package:motiv_fy/features/noteflow/presentation/pages/tasks_notes_page.dart';

class ViewAllButton extends StatelessWidget {
  final String selectedDate;

  const ViewAllButton({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to tasks page with selected date
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksNotesPage(initialDate: selectedDate),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          'View all',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
