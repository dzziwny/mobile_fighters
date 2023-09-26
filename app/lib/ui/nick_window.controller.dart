import 'package:rxdart/rxdart.dart';

class NickWindowController {
  final _show = PublishSubject<bool>();

  Stream<bool> show() => _show.asBroadcastStream();

  void set(bool state) => _show.add(state);
}
