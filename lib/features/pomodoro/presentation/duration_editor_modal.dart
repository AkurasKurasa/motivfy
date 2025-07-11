import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<Duration?> showDurationEditor({
  required BuildContext context,
  required bool isWork,
  required int initialMinutes,
}) {
  return showModalBottomSheet<Duration>(
    context: context,
    backgroundColor: const Color(0xFF2A2A2A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      int minutes = initialMinutes;

      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isWork ? 'Set Work Duration' : 'Set Break Duration',
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
        },
      );
    },
  );
}
