import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';

abstract class Server {
  void updatePosition(String playerId, Vector2 position, double angle);

  Stream<DatabaseEvent> onPlayerPositionUpdate$(String playerId);
  Stream<DatabaseEvent> onPlayerAdded$();
  Stream<DatabaseEvent> onPlayerRemoved$();
  Future<void> createPlayer(String id, String nick);
}
