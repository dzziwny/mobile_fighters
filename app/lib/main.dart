import 'package:bubble_fight/home.dart';
import 'package:bubble_fight/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'initialize_instances.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  if (!displaySplash) {
    await initializeInstances();
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme(),
      home: displaySplash ? const SplashScreen() : const Home(),
    );
  }
}
