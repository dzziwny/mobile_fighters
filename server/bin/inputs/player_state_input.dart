class PlayerControlsState {
  final int playerId;

  double x = 0.0;
  double y = 0.0;
  double angle = 0.0;

  bool isBullet = false;

  PlayerControlsState(this.playerId);

  @override
  String toString() => 'x: $x, y: $y, angle: $angle, isBullet: $isBullet';
}
