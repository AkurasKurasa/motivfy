import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/timer_circle.dart';
import 'presentation/timer_control_button.dart';
import 'presentation/mode_label.dart';
import 'presentation/dot_indicator.dart';
import 'presentation/duration_editor_modal.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  Duration workDuration = const Duration(minutes: 25);
  Duration breakDuration = const Duration(minutes: 5);

  late Duration currentTime;
  late Duration totalTime;

  bool isRunning = false;
  bool isWorkTime = true;
  Timer? timer;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    currentTime = workDuration;
    totalTime = workDuration;

    _pageController.addListener(() {
      final page = _pageController.page?.round();
      if (page != null && (page == 0 || page == 1)) {
        if (isWorkTime != (page == 0)) {
          setState(() {
            isWorkTime = page == 0;
            currentTime = isWorkTime ? workDuration : breakDuration;
            totalTime = currentTime;
          });
        }
      }
    });
  }

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (currentTime.inSeconds > 0) {
        setState(() => currentTime -= const Duration(seconds: 1));
      } else {
        timer?.cancel();
        setState(() {
          isRunning = false;
          isWorkTime = !isWorkTime;
          currentTime = isWorkTime ? workDuration : breakDuration;
          totalTime = currentTime;
          _pageController.jumpToPage(isWorkTime ? 0 : 1);
        });
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  double get progress => 1.0 - (currentTime.inSeconds / totalTime.inSeconds);

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void editCurrentDuration() async {
    final picked = await showDurationEditor(
      context: context,
      isWork: isWorkTime,
      initialMinutes: isWorkTime ? workDuration.inMinutes : breakDuration.inMinutes,
    );

    if (picked != null) {
      setState(() {
        if (isWorkTime) {
          workDuration = picked;
          currentTime = picked;
          totalTime = picked;
        } else {
          breakDuration = picked;
          currentTime = picked;
          totalTime = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color timerColor = isWorkTime ? const Color(0xFFEF5350) : const Color(0xFF66BB6A);

    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Pomodoro",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 60),

            TimerCircle(
              progress: progress,
              time: formatTime(currentTime),
              color: timerColor,
              onTap: editCurrentDuration,
            ),

            const SizedBox(height: 32),

            TimerControlButton(
              onPressed: isRunning ? pauseTimer : startTimer,
              isRunning: isRunning,
              backgroundColor: timerColor,
            ),

            const SizedBox(height: 160),

            ModeLabel(isWork: isWorkTime),

            const SizedBox(height: 24),

            DotIndicator(isWork: isWorkTime),
          ],
        ),
      ),
    );
  }
}
