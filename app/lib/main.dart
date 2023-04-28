import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/ui/home.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Isolate.spawn((_) => server.main(), null);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown,
  ]);

  serverClient.connect();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final halfWidth = mediaQuery.size.width / 2;
    final halfHeight = mediaQuery.size.height / 2;
    return Listener(
      onPointerHover: (event) =>
          movementBloc.setAngle(event, halfWidth, halfHeight),
      child: MaterialApp(
        theme: lightTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
