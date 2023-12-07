import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

class DebugGameSettingsController {
  var settings = const GameSettings();
}

class DebugGameSettings extends StatefulWidget {
  const DebugGameSettings({
    required this.controller,
    super.key,
  });

  final DebugGameSettingsController controller;

  @override
  State<DebugGameSettings> createState() => _DebugGameSettingsState();
}

class _DebugGameSettingsState extends State<DebugGameSettings> {
  late final _frameRateController = TextEditingController(
      text: widget.controller.settings.frameRate.toString());

  late final _kController = TextEditingController(
      text: widget.controller.settings.frictionK.toString());
  late final _nController = TextEditingController(
      text: widget.controller.settings.frictionN.toString());
  late final _fController = TextEditingController(
      text: widget.controller.settings.forceRatio.toString());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const Text('Frames'),
              Flexible(
                child: TextField(
                  controller: _frameRateController,
                  decoration: const InputDecoration(
                    labelText: 'frame rate',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      frameRate: int.tryParse(value),
                    );
                  },
                ),
              ),
            ].expand(
              (element) sync* {
                yield element;
                yield const SizedBox(height: 16.0);
              },
            ).toList(),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            children: [
              const Text('Player'),
              Flexible(
                child: TextField(
                  controller: _kController,
                  decoration: const InputDecoration(
                    labelText: 'player default friction k',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      frictionK: double.tryParse(value),
                    );
                  },
                ),
              ),
              TextField(
                controller: _nController,
                decoration: const InputDecoration(
                  labelText: 'player default friction n',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.controller.settings =
                      widget.controller.settings.copyWith(
                    frictionN: double.tryParse(value),
                  );
                },
              ),
              TextField(
                controller: _fController,
                decoration: const InputDecoration(
                  labelText: 'player default move force',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.controller.settings =
                      widget.controller.settings.copyWith(
                    forceRatio: double.tryParse(value),
                  );
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
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _kController.dispose();
    _nController.dispose();
    _fController.dispose();
    super.dispose();
  }
}
