import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/ui/home.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Isolate.spawn((_) => server.main(), null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown,
  ]);

  // await client.connect();
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
