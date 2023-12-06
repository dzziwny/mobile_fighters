import 'dart:io';

import 'package:bubble_fight/60hz_refreshable_playground/playground_layer.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class DebugGameSettings extends StatefulWidget {
  const DebugGameSettings({
    super.key,
    required this.physics,
  });

  final GamePhysics physics;

  @override
  State<DebugGameSettings> createState() => _DebugGameSettingsState();
}

class _DebugGameSettingsState extends State<DebugGameSettings> {
  late final _kController =
      TextEditingController(text: widget.physics.k.toString());
  late final _nController =
      TextEditingController(text: widget.physics.n.toString());
  late final _fController =
      TextEditingController(text: widget.physics.f.toString());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _kController,
          decoration: const InputDecoration(
            labelText: 'player default friction k',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.physics.k = double.tryParse(value) ?? 0;
          },
        ),
        TextField(
          controller: _nController,
          decoration: const InputDecoration(
            labelText: 'player default friction n',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.physics.n = double.tryParse(value) ?? 0;
          },
        ),
        TextField(
          controller: _fController,
          decoration: const InputDecoration(
            labelText: 'player default move force',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.physics.f = double.tryParse(value) ?? 0;
          },
        ),
        MaterialButton(
          onPressed: () {
            exit(0);
          },
          child: const Text('Exit app'),
        ),
      ].expand(
        (element) sync* {
          yield element;
          yield const SizedBox(height: 16.0);
        },
      ).toList(),
    );
  }
}
