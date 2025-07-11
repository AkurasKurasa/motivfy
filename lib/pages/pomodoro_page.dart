import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final Duration? picked = await showModalBottomSheet<Duration>(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int minutes = isWorkTime ? workDuration.inMinutes : breakDuration.inMinutes;

        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isWorkTime ? 'Set Work Duration' : 'Set Break Duration',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (minutes > 1) minutes--;
                      }),
                      icon: const Icon(Icons.remove_circle, color: Colors.white),
                    ),
                    Text(
                      '$minutes min',
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (minutes < 90) minutes++;
                      }),
                      icon: const Icon(Icons.add_circle, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, Duration(minutes: minutes)),
                  child: const Text("Save"),
                ),
              ],
            ),
          );
        });
      },
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
            // HEADER
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

            // TIMER CIRCLE
            GestureDetector(
              onTap: editCurrentDuration,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) => Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: 1.0 - value,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                      ),
                    ),
                    Text(
                      formatTime(currentTime),
                      style: GoogleFonts.quicksand(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // START/PAUSE BUTTON
            ElevatedButton(
              onPressed: isRunning ? pauseTimer : startTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: timerColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isRunning ? "Pause" : "Start",
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 160),

            // WORK / BREAK ANIMATED LABEL
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(0.0, 0.5),
                  end: Offset.zero,
                ).animate(animation);

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              child: Text(
                isWorkTime ? "Work" : "Break",
                key: ValueKey<String>(isWorkTime ? "Work" : "Break"),
                style: GoogleFonts.quicksand(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                bool isActive = (isWorkTime && index == 0) || (!isWorkTime && index == 1);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: isActive ? 14 : 8,
                  height: isActive ? 14 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.white : Colors.white30,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
