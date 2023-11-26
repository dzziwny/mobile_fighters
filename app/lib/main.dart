import 'package:bubble_fight/game_board/game_board.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'initialize_instances.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await initializeInstances();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme(),
      home: const HomeScreen(),
    );
  }
}
