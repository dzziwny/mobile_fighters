class BulletInput {
  final _isShooting = <int, bool>{};

  Future<void> update(int playerId, bool isShooting) async {
    _isShooting[playerId] = isShooting;
  }

  bool isShooting(int playerId) => _isShooting[playerId]!;

  void create(int playerId) => _isShooting[playerId] = false;
}
