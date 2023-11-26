import 'dart:io';

import 'package:bubble_fight/60hz_refreshable_playground/playground_layer.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class DebugGameSettings extends StatefulWidget {
  const DebugGameSettings({super.key});

  @override
  State<DebugGameSettings> createState() => _DebugGameSettingsState();
}

class _DebugGameSettingsState extends State<DebugGameSettings> {
  var gamepPhysics = GamePhysics();

  late final _kController =
      TextEditingController(text: gamepPhysics.k.toString());
  late final _nController =
      TextEditingController(text: gamepPhysics.n.toString());
  late final _fController =
      TextEditingController(text: gamepPhysics.f.toString());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 200.0,
      child: Column(
        children: [
          TextField(
            controller: _kController,
            onChanged: (value) {
              gamepPhysics.k = double.tryParse(value) ?? 0;
            },
          ),
          TextField(
            controller: _nController,
            onChanged: (value) {
              gamepPhysics.n = double.tryParse(value) ?? 0;
            },
          ),
          TextField(
            controller: _fController,
            onChanged: (value) {
              gamepPhysics.f = double.tryParse(value) ?? 0;
            },
          ),
          MaterialButton(
            onPressed: () async {
              await serverClient.setGamePhysics(gamepPhysics);
              if (!mounted) {
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Success')),
              );

              playgroundFocusNode.requestFocus();
            },
            child: const Text('Apply'),
          ),
          MaterialButton(
            onPressed: () {
              exit(0);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
