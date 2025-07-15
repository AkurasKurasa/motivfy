import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:motiv_fy/features/home/presentation/pages/home_page.dart';
import 'package:motiv_fy/core/utils/device_utils.dart';

/// Entry point of the application with performance optimizations.
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Performance optimizations
  debugPaintSizeEnabled = false;

  // Add memory pressure callback for better performance
  SystemChannels.lifecycle.setMessageHandler((msg) async {
    if (msg == AppLifecycleState.paused.toString()) {
      // Clear caches when app goes to background
      MemoryManager.onMemoryPressure();
      // Clear image cache
      imageCache.clear();
      imageCache.clearLiveImages();
    }
    return null;
  });

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Add performance overlay for debugging (remove in production)
      showPerformanceOverlay: false, // Set to true for debugging
      home: const HomePage(),
      builder: (context, child) {
        // Add memory pressure handling and device-optimized scaling
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(
              DeviceUtils.isLowEndDevice ? 0.9 : 0.8, // Smaller text on low-end
              DeviceUtils.isLowEndDevice ? 1.1 : 1.2, // Less scaling on low-end
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
