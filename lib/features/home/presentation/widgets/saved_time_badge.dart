import 'package:flutter/material.dart';

class SavedTimeBadge extends StatelessWidget {
  final int hoursSaved;

  const SavedTimeBadge({super.key, required this.hoursSaved});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        // Makes it responsive and avoid overflow in small containers
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent, // Removed black background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.center, // ensures vertical centering
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F63E2), // Blue dot
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // aligns text to the left
                children: [
                  Text(
                    'You Saved',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$hoursSaved hour${hoursSaved == 1 ? '' : 's'}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
