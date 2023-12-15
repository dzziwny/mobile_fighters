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
  // Frames
  late final _frameRateController = TextEditingController(
    text: widget.controller.settings.frameRate.toString(),
  );
  late final _sliceTimeController = TextEditingController(
    text: widget.controller.settings.sliceTimeMicroseconds.toString(),
  );

  // Player
  late final _playerFrictionKController = TextEditingController(
    text: widget.controller.settings.playerFrictionK.toString(),
  );
  late final _playerFrictionNController = TextEditingController(
    text: widget.controller.settings.playerFrictionN.toString(),
  );
  late final _playerForceRatioController = TextEditingController(
    text: widget.controller.settings.playerForceRatio.toString(),
  );
  late final _playerStartHpController = TextEditingController(
    text: widget.controller.settings.playerStartHp.toString(),
  );
  late final _playerRadiusController = TextEditingController(
    text: widget.controller.settings.playerRadius.toString(),
  );

  // Dash
  late final _dashForceRatioController = TextEditingController(
    text: widget.controller.settings.dashForceRatio.toString(),
  );
  late final _dashAfterForceRatioController = TextEditingController(
    text: widget.controller.settings.dashAfterForceRatio.toString(),
  );
  late final _dashCooldownController = TextEditingController(
    text: widget.controller.settings.dashCooldown.toString(),
  );
  late final _dashDurationController = TextEditingController(
    text: widget.controller.settings.dashDuration.toString(),
  );

  // Bullet
  late final _bulletRadiusController = TextEditingController(
    text: widget.controller.settings.bulletRadius.toString(),
  );
  late final _bulletDistanceController = TextEditingController(
    text: widget.controller.settings.bulletDistance.toString(),
  );
  late final _bulletsCooldownController = TextEditingController(
    text: widget.controller.settings.bulletsCooldown.toString(),
  );
  late final _bulletPowerController = TextEditingController(
    text: widget.controller.settings.bulletPower.toString(),
  );
  late final _bulletVelocityController = TextEditingController(
    text: widget.controller.settings.bulletVelocity.toString(),
  );

  // Bomb
  late final _bombRadiusController = TextEditingController(
    text: widget.controller.settings.bombRadius.toString(),
  );
  late final _bombDistanceController = TextEditingController(
    text: widget.controller.settings.bombDistance.toString(),
  );
  late final _bombCooldownController = TextEditingController(
    text: widget.controller.settings.bombCooldown.toString(),
  );
  late final _bombPowerController = TextEditingController(
    text: widget.controller.settings.bombPower.toString(),
  );
  late final _bombVelocityController = TextEditingController(
    text: widget.controller.settings.bombVelocity.toString(),
  );

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
              Flexible(
                child: TextField(
                  controller: _sliceTimeController,
                  decoration: const InputDecoration(
                    labelText: 'slice time (μs)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      sliceTimeMicroseconds: int.tryParse(value),
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
                  controller: _playerFrictionKController,
                  decoration: const InputDecoration(
                    labelText: 'friction k',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      playerFrictionK: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _playerFrictionNController,
                  decoration: const InputDecoration(
                    labelText: 'friction n',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      playerFrictionN: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _playerForceRatioController,
                  decoration: const InputDecoration(
                    labelText: 'move force',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      playerForceRatio: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _playerStartHpController,
                  decoration: const InputDecoration(
                    labelText: 'start hp',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      playerStartHp: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _playerRadiusController,
                  decoration: const InputDecoration(
                    labelText: 'radius',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      playerRadius: double.tryParse(value),
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
              const Text('Dash'),
              Flexible(
                child: TextField(
                  controller: _dashForceRatioController,
                  decoration: const InputDecoration(
                    labelText: 'force',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      dashForceRatio: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _dashAfterForceRatioController,
                  decoration: const InputDecoration(
                    labelText: 'force after',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      dashAfterForceRatio: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _dashCooldownController,
                  decoration: const InputDecoration(
                    labelText: 'cooldown',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      dashCooldown: int.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _dashDurationController,
                  decoration: const InputDecoration(
                    labelText: 'duration',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      dashDuration: int.tryParse(value),
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
              const Text('Bullet'),
              Flexible(
                child: TextField(
                  controller: _bulletRadiusController,
                  decoration: const InputDecoration(
                    labelText: 'radius',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bulletRadius: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _bulletDistanceController,
                  decoration: const InputDecoration(
                    labelText: 'distance',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bulletDistance: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _bulletsCooldownController,
                  decoration: const InputDecoration(
                    labelText: 'cooldown',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bulletsCooldown: int.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _bulletPowerController,
                  decoration: const InputDecoration(
                    labelText: 'power',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bulletPower: int.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _bulletVelocityController,
                  decoration: const InputDecoration(
                    labelText: 'velocity',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bulletVelocity: double.tryParse(value),
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
              const Text('Bomb'),
              Flexible(
                child: TextField(
                  controller: _bombRadiusController,
                  decoration: const InputDecoration(
                    labelText: 'radius',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bombRadius: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _bombDistanceController,
                  decoration: const InputDecoration(
                    labelText: 'distance',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bombDistance: double.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _bombCooldownController,
                  decoration: const InputDecoration(
                    labelText: 'cooldown',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bombCooldown: int.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _bombPowerController,
                  decoration: const InputDecoration(
                    labelText: 'power',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bombPower: int.tryParse(value),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextField(
                  controller: _bombVelocityController,
                  decoration: const InputDecoration(
                    labelText: 'velocity',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.controller.settings =
                        widget.controller.settings.copyWith(
                      bombVelocity: double.tryParse(value),
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
      ],
    );
  }

  @override
  void dispose() {
    _playerFrictionKController.dispose();
    _playerFrictionNController.dispose();
    _playerForceRatioController.dispose();
    super.dispose();
  }
}
