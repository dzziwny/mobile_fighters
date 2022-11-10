import 'package:bubble_fight/ui/home.screen.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton(ServerClient());

  // Isolate.spawn((_) => server.main(), null);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Colors.amber,
      brightness: Brightness.dark,
    );

    final base = ThemeData.from(
      colorScheme: scheme,
      useMaterial3: true,
    );

    return MaterialApp(
      theme: base,
      home: HomeScreen(),
    );
  }
}
