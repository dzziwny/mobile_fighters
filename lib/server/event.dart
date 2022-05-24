import 'package:firebase_database/firebase_database.dart';

class Event implements DatabaseEvent {
  @override
  final String? previousChildKey;
  @override
  final DataSnapshot snapshot;
  @override
  final DatabaseEventType type;

  const Event({
    required this.snapshot,
    required this.type,
    this.previousChildKey,
  });
}

class Snapshot implements DataSnapshot {
  @override
  DataSnapshot child(String path) {
    throw UnimplementedError();
  }

  @override
  Iterable<DataSnapshot> get children => throw UnimplementedError();

  @override
  bool get exists => throw UnimplementedError();

  @override
  bool hasChild(String path) {
    throw UnimplementedError();
  }

  @override
  Object? get priority => throw UnimplementedError();

  @override
  DatabaseReference get ref => throw UnimplementedError();

  @override
  final String? key;

  @override
  final Object? value;

  const Snapshot({
    required this.key,
    required this.value,
  });
}
