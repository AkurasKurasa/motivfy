import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/ui_tab_selector.dart';
import 'package:motiv_fy/features/noteflow/presentation/pages/tasks_notes_page.dart';
import 'package:motiv_fy/features/noteflow/presentation/pages/note_flow_content_page.dart';
import 'package:motiv_fy/features/tasks/presentation/pages/manual_task_create_content_page.dart';

class TaskCreationPage extends StatefulWidget {
  const TaskCreationPage({super.key});

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  int _selectedTabIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey _menuIconKey = GlobalKey();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 21.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    key: _menuIconKey,
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      // Navigate to TasksNotesPage when hamburger menu is clicked
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const TasksNotesPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                  ),
                  Flexible(
                    child: Hero(
                      tag: 'tabSelector',
                      child: TabSelector(
                        tabs: const [
                          TabItem(
                            label: 'NoteFlow',
                            icon: Icons.auto_awesome,
                            selectedColor: Colors.white,
                            unselectedColor: Colors.white70,
                          ),
                          TabItem(
                            label: 'Manual',
                            icon: Icons.edit_note,
                            selectedColor: Colors.white,
                            unselectedColor: Colors.white70,
                          ),
                        ],
                        onTabChanged: (index) {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        width: 220,
                        height: 36,
                        borderColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                children: const [
                  NoteFlowContentPage(),
                  ManualTaskCreateContentPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
