class KnobInput {
  final _x = <int, double>{};
  final _y = <int, double>{};
  final _angles = <int, double>{};

  Future<void> update(int playerId, double x, double y, double angle) async {
    _x[playerId] = x;
    _y[playerId] = y;
    _angles[playerId] = angle;
  }

  double x(int playerId) => _x[playerId]!;
  double y(int playerId) => _y[playerId]!;
  double angle(int playerId) => _angles[playerId]!;

  void updateKeyboard(int playerId, double x, double y) {
    _x[playerId] = x;
    _y[playerId] = y;
  }

  void updateAngle(int playerId, double angle) {
    _angles[playerId] = angle;
  }

  void create(int playerId, double angle) {
    _x[playerId] = 0.0;
    _y[playerId] = 0.0;
    _angles[playerId] = angle;
  }
}
