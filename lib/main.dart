import 'dart:io';

import 'package:bubble_fight/firebase_options.dart';
import 'package:bubble_fight/home.screen.dart';
import 'package:bubble_fight/server.dart';
import 'package:bubble_fight/server/server_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final toServerSocket =
      await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  final fromServerSenderSocket =
      await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  final fromServerReceiverSocket =
      await RawDatagramSocket.bind(InternetAddress.anyIPv4, 4545);
  fromServerReceiverSocket.joinMulticast(InternetAddress('239.10.10.100'));
  var toHttpServer = await HttpServer.bind(InternetAddress.anyIPv4, 0);
  var fromHttpServer = await HttpServer.bind(InternetAddress.anyIPv4, 0);

  GetIt.I.registerSingleton(fromHttpServer, instanceName: 'fromHttpServer');
  GetIt.I.registerSingleton(toHttpServer, instanceName: 'toHttpServer');
  GetIt.I.registerSingleton(toServerSocket, instanceName: 'toServerSocket');
  GetIt.I.registerSingleton(
    fromServerSenderSocket,
    instanceName: 'fromServerSenderSocket',
  );
  GetIt.I.registerSingleton(
    fromServerReceiverSocket,
    instanceName: 'fromServerReceiverSocket',
  );
  GetIt.I.registerSingleton(ServerClient()..run());

  final server = Server()..run();

  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
