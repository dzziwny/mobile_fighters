import 'dart:async';
import 'dart:typed_data';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';

class PositionBloc {
  Future<void> updateKnob(double angle, double deltaX, double deltaY) async {
    final bytes = Uint8List.fromList([
      0,
      ...angle.toBytes(),
      ...deltaX.toBytes(),
      ...deltaY.toBytes(),
    ]);

    await mobileControlsWs.send(bytes);
  }

  Future<void> dash() async {
    final bytes = [1].toBytes();
    await mobileControlsWs.send(bytes);
  }
}
