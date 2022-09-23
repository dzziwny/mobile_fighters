class Position {
  final int playerId;
  final double x;
  final double y;
  final double angle;

  const Position(this.playerId, this.x, this.y, this.angle);

  @override
  String toString() {
    return "position: [id: $playerId, x: $x, y: $y, angle: $angle]";
  }
}
