import 'package:bubble_fight/server/event.dart';
import 'package:bubble_fight/server/server.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:rxdart/rxdart.dart';

class LocalServer implements Server {
  final _playerPositions = <String, BehaviorSubject<DatabaseEvent>>{};
  final _playerAdded$ = ReplaySubject<DatabaseEvent>(maxSize: 1);
  final _playerRemoved$ = ReplaySubject<DatabaseEvent>(maxSize: 1);

  final _updatingPosition$ = BehaviorSubject();
  late final _updatingPositionSub$;

  LocalServer() {
    _updatingPositionSub$ = _updatingPosition$
        // .throttleTime(const Duration(milliseconds: 1000))
        .map((func) {
      func();
    }).listen(null);
  }

  @override
  void updatePosition(String playerId, Vector2 position, double angle) {
    final snapshot = Snapshot(key: playerId, value: {
      'x': position.x,
      'y': position.y,
      'angle': angle,
    });
    final event =
        Event(snapshot: snapshot, type: DatabaseEventType.childChanged);
    _updatingPosition$.add(() => _playerPositions[playerId]!.add(event));
  }

  @override
  Stream<DatabaseEvent> onPlayerPositionUpdate$(String playerId) {
    return _playerPositions[playerId]!.asBroadcastStream();
  }

  @override
  Stream<DatabaseEvent> onPlayerRemoved$() {
    return _playerRemoved$.asBroadcastStream();
  }

  @override
  Future<void> createPlayer(String id, String nick) async {
    _playerPositions[id] = BehaviorSubject();
    final snapshot = Snapshot(key: id, value: {
      'nick': nick,
    });
    final event =
        Event(snapshot: snapshot, type: DatabaseEventType.childChanged);
    _playerAdded$.add(event);
  }

  @override
  Stream<DatabaseEvent> onPlayerAdded$() {
    return _playerAdded$.asBroadcastStream();
  }
}
