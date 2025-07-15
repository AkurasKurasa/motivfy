import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motiv_fy/core/widgets/view_all_button.dart';
import 'package:motiv_fy/features/noteflow/presentation/pages/tasks_notes_page.dart';

void main() {
  testWidgets('ViewAllButton navigates to TasksNotesPage when tapped', (
    WidgetTester tester,
  ) async {
    // Define test date
    const testDate = 'July 6, 2025';

    // Build the ViewAllButton widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ViewAllButton(selectedDate: testDate)),
      ),
    );

    // Verify that the button displays the correct text
    expect(find.text('View all'), findsOneWidget);

    // Tap the button
    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();

    // Verify navigation to TasksNotesPage
    expect(find.byType(TasksNotesPage), findsOneWidget);
  });
}
