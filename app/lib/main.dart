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

  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
