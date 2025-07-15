import 'package:flutter/material.dart';
import 'package:motiv_fy/features/home/presentation/pages/home_page.dart';

/// Universal navigation service following clean architecture principles
/// Provides centralized navigation logic for consistent app behavior
class UniversalNavigationService {
  /// Navigates to home page and clears the navigation stack
  /// This ensures the NavigationMenu state is properly reset to home (index 0)
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
      (route) => false, // Remove all previous routes
    );
  }

  /// Alternative method for cases where you want to pop to home if it exists
  /// in the stack, otherwise navigate to home
  static void returnToHome(BuildContext context) {
    // Try to pop until we reach home, if home is in the stack
    Navigator.of(context).popUntil((route) {
      // If we can't pop anymore (reached the first route), navigate to home
      if (route.isFirst) {
        // Check if the first route is HomePage
        if (route.settings.name != '/home') {
          // Replace with home if it's not home
          Future.microtask(() => navigateToHome(context));
        }
        return true;
      }
      return false;
    });
  }

  /// Smooth pop animation that can be used for return buttons
  static void popWithAnimation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // If nothing to pop, go to home
      navigateToHome(context);
    }
  }
}
