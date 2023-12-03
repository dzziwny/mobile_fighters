import 'package:bubble_fight/controls/controls.bloc.dart';
import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'leave_button.dart';

class ButtonsRail extends StatefulWidget {
  const ButtonsRail({super.key});

  @override
  State<ButtonsRail> createState() => _ButtonsRailState();
}

class _ButtonsRailState extends State<ButtonsRail>
    with TickerProviderStateMixin {
  final player = gameService.gameState.players[serverClient.state.value.id];

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => setState(() {}));
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const LeaveButton(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _AttackButton(
                    enabled: !player.isDashCooldown,
                    icon: const Icon(Icons.rocket_launch),
                    onPointerDown: controlsBloc.startDash,
                    onPointerUp: controlsBloc.stopDash,
                  ),
                  const SizedBox(height: 8.0),
                  _AttackButton(
                    enabled: !player.isBombCooldown,
                    icon: const Icon(Icons.sunny),
                    onPointerDown: controlsBloc.startBomb,
                    onPointerUp: controlsBloc.stopBomb,
                  ),
                  const SizedBox(height: 8.0),
                  _AttackButton(
                    icon: const Icon(Icons.donut_large_rounded),
                    onPointerDown: controlsBloc.startBullet,
                    onPointerUp: controlsBloc.stopBullet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttackButton extends StatelessWidget {
  const _AttackButton({
    required this.onPointerDown,
    required this.onPointerUp,
    required this.icon,
    this.enabled = true,
  });

  final void Function() onPointerDown;
  final void Function() onPointerUp;
  final bool enabled;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onPointerDown(),
      onPointerUp: (_) => onPointerUp(),
      child: IconButton.filled(
        onPressed: enabled ? () {} : null,
        icon: icon,
      ),
    );
  }
}
