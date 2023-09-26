class ActionsState {
  final int id;

  bool isBombCooldown = false;
  bool bomb = false;
  bool isDashCooldown = false;
  bool dash = false;

  ActionsState(this.id);
}
