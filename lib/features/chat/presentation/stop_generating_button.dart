import 'package:flutter/material.dart';

class StopGeneratingButton extends StatelessWidget {
  final VoidCallback onStop;

  const StopGeneratingButton({super.key, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: onStop,
          icon: const Icon(Icons.stop),
          label: const Text("Stop Generating"),
        ),
      ),
    );
  }
}
