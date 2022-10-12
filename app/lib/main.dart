import 'package:bubble_fight/ui/home.screen.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton(ServerClient());

  // Isolate.spawn((_) => server.main(), null);

  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
