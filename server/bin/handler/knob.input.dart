import 'package:core/core.dart';

class KnobInput {
  final _knobs = <int, Knob>{};
  Future<void> update(int playerId, Knob knob) async {
    _knobs[playerId] = knob;
  }

  Knob get(int playerId) {
    return _knobs[playerId] ?? Knob(0.0, 0.0, 0.0);
  }
}
