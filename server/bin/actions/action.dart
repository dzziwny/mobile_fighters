import 'package:vector_math/vector_math.dart';

import '../handler/attack.connection.dart';
import '../handler/dash.connection.dart';
import '../updates/attack.update.dart';
import '../updates/bullet.update.dart';

abstract class Action {
  Future<void> handle();
}

class AttackAction implements Action {
  const AttackAction(this.playerId);

  final int playerId;

  @override
  Future<void> handle() async {
    // TODO: fix
    await attackUpdate(playerId);
  }
}

class CompleteAttackAction implements Action {
  const CompleteAttackAction(this.attackId, this.attackerId, this.attackCenter);

  final int attackId;
  final int attackerId;
  final Vector2 attackCenter;

  @override
  Future<void> handle() async {
    // TODO: fix
    await completeAttackUpdate(attackId, attackerId, attackCenter);
  }
}

class AttackCooldownAction implements Action {
  const AttackCooldownAction(this.playerId, this.isCooldown);

  final int playerId;
  final bool isCooldown;

  @override
  Future<void> handle() async {
    // TODO: fix
    await attackCooldownUpdate(playerId, isCooldown);
  }
}

class CreateBulletAction implements Action {
  const CreateBulletAction(this.playerId);

  final int playerId;

  @override
  Future<void> handle() async {
    // TODO: fix
    await createBulletUpdate(playerId);
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
