import 'package:bubble_fight/server/server.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';

class FirebaseServer implements Server {
  final DatabaseReference gameRef;

  FirebaseServer({
    required String gameId,
  }) : gameRef = FirebaseDatabase.instance.ref('games/$gameId');

  @override
  Future<void> updatePosition(
      String playerId, Vector2 position, double angle) async {
    await gameRef.child('players/$playerId/position').update({
      'x': position.x,
      'y': position.y,
      'angle': angle,
    });
  }

  @override
  Stream<DatabaseEvent> onPlayerPositionUpdate$(String playerId) {
    return gameRef.child('players/$playerId/position').onValue;
  }

  @override
  Stream<DatabaseEvent> onPlayerRemoved$() {
    return gameRef.child('players').onChildRemoved;
  }

  @override
  Future<void> createPlayer(String id, String nick) async {
    await gameRef.child('players/$id').update({
      'nick': nick,
    });
  }

  @override
  Stream<DatabaseEvent> onPlayerAdded$() {
    return gameRef.child('players').onChildAdded;
  }
}
