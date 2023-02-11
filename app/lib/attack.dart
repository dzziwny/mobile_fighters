import 'di.dart';

class Attack {
  final id = uuid.v4();
  final int serverId;
  final double startX;
  final double startY;
  final double targetX;
  final double targetY;

  Attack(
    this.serverId,
    this.startX,
    this.startY,
    this.targetX,
    this.targetY,
  );
}
