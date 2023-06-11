import '../handler/attack.connection.dart';
import '../handler/dash.connection.dart';

abstract class Action {
  Future<void> handle();
}

class CreatingBombCooldownAction implements Action {
  const CreatingBombCooldownAction(this.playerId, this.isCooldown);

  final int playerId;
  final bool isCooldown;

  @override
  Future<void> handle() async {
    // TODO: fix
    await attackCooldownUpdate(playerId, isCooldown);
  }
}

class DashCooldownAction implements Action {
  const DashCooldownAction(this.playerId, this.isCooldown);

  final int playerId;
  final bool isCooldown;

  @override
  Future<void> handle() async {
    // TODO: fix
    await dashCooldownUpdate(playerId, isCooldown);
  }
}
