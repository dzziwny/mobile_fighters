import 'package:rxdart/rxdart.dart';

class StartWindowController {
  final _show = BehaviorSubject.seeded(true);

  Stream<bool> show() => _show.asBroadcastStream();

  void set(bool state) => _show.add(state);
}

final startWindowController = StartWindowController();
