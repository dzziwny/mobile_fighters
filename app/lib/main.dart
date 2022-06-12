import 'dart:io';
import 'dart:isolate';

import 'package:bubble_fight/statics.dart' as statics;
import 'package:bubble_fight/firebase_options.dart';
import 'package:bubble_fight/home.screen.dart';
import 'package:bubble_fight/server.dart' as server;
import 'package:bubble_fight/server/server_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final toServerSocket = await RawDatagramSocket.bind(
    InternetAddress.anyIPv4,
    statics.toServerSocketPort,
  );

  final fromServerReceiverSocket = await RawDatagramSocket.bind(
    InternetAddress.anyIPv4,
    statics.multicastPort,
  );
  fromServerReceiverSocket.joinMulticast(statics.multicastAddress);

  GetIt.I.registerSingleton(toServerSocket, instanceName: 'toServerSocket');
  GetIt.I.registerSingleton(
    fromServerReceiverSocket,
    instanceName: 'fromServerReceiverSocket',
  );
  GetIt.I.registerSingleton(ServerClient()..run());

  Isolate.spawn((_) => server.main(), null);

  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
