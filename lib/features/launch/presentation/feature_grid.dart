import 'package:flutter/material.dart';
import 'package:motiv_fy/features/pomodoro/pomodoro_page.dart';
import 'package:motiv_fy/features/tasks/presentation/pages/task_creation_page.dart';
import 'package:motiv_fy/features/productivity_assistant/presentation/pages/productivity_assistant_page.dart';
import 'package:motiv_fy/features/tasks/presentation/pages/tasks_archive_page_new.dart';
import 'feature_card.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final horizontalPadding = screenWidth > 600 ? 40.0 : 24.0;
        final cardSpacing = screenWidth > 600 ? 12.0 : 8.0;
        final verticalSpacing = screenWidth > 600 ? 12.0 : 8.0;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              // First row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FeatureCard(
                      asset:
                          'assets/Home_Page/SliderMenuButton/PomodoroTimer.svg',
                      label: 'Pomodoro\nTimer',
                      iconSize: 32,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const PomodoroPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: cardSpacing),
                  const Expanded(
                    child: FeatureCard(
                      asset: 'procrastination_analysis',
                      label: 'Procrastination\nAnalysis',
                      iconSize: 32,
                    ),
                  ),
                  SizedBox(width: cardSpacing),
                  const Expanded(
                    child: FeatureCard(
                      asset: 'block_list',
                      label: 'Block\nList',
                      iconSize: 32,
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing),
              // Second row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FeatureCard(
                      asset: 'done_list',
                      label: 'Done\nList',
                      iconSize: 32,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const TasksArchivePage(
                                      initialFilter: 'Completed',
                                    ),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: cardSpacing),
                  Expanded(
                    child: FeatureCard(
                      asset:
                          'assets/Home_Page/SliderMenuButton/NotefFlow_Logo_Main.svg',
                      label: 'Note\nFlow',
                      iconSize: 32,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const TaskCreationPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: cardSpacing),
                  Expanded(
                    child: FeatureCard(
                      asset:
                          'assets/Home_Page/SliderMenuButton/ProductivityAssistant.svg',
                      label: 'Productivity\nAssistant',
                      iconSize: 32,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ProductivityAssistantPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
