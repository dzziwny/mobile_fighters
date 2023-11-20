class PlayerControlsState {
  final int playerId;

  double inputForceX = 0.0;
  double inputForceY = 0.0;
  double angle = 0.0;

  bool isBullet = false;
  bool isBomb = false;
  bool isDash = false;

  PlayerControlsState(this.playerId);

  @override
  String toString() => """x: $inputForceX,
      y: $inputForceY,
      angle: $angle,
      isBullet: $isBullet,
      isBomb: $isBomb,
      isDash: $isDash
      """;
}
