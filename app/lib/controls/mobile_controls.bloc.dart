import 'dart:typed_data';

import 'package:bubble_fight/ws.dart';
import 'package:core/core.dart';

import 'controls.bloc.dart';

class MobileControlsBloc extends ControlsBloc {
  int _keys = 0;
  Uint8List _angle = [0, 0, 0, 0].toBytes();
  Uint8List _x = [0, 0, 0, 0].toBytes();
  Uint8List _y = [0, 0, 0, 0].toBytes();

  final _bytesBuilder = BytesBuilder();

  final mobileControlsWs =
      Ws(Socket.mobileControlsWs, PlayerViewModel.manyFromBytes);

  @override
  void startBullet() {
    _keys = _keys | Bits.bullet;
    _sendPlayerState();
  }

  @override
  void stopBullet() {
    _keys = _keys & ~Bits.bullet;
    _sendPlayerState();
  }

  @override
  void rotate(double angle) {
    throw Exception();
  }

  @override
  void startDash() {
    _keys = _keys | Bits.dash;
    _sendPlayerState();
  }

  @override
  void stopDash() {
    _keys = _keys & ~Bits.dash;
    _sendPlayerState();
  }

  @override
  void startBomb() {
    _keys = _keys | Bits.bomb;
    _sendPlayerState();
  }

  @override
  void stopBomb() {
    _keys = _keys & ~Bits.bomb;
    _sendPlayerState();
  }

  // TODO use int's
  void updateKnob(double x, double y, double angle) {
    _x = x.toBytes();
    _y = y.toBytes();
    _angle = angle.toBytes();
    _sendPlayerState();
  }

  void _sendPlayerState() {
    _bytesBuilder.addByte(_keys);
    _bytesBuilder.add(_x);
    _bytesBuilder.add(_y);
    _bytesBuilder.add(_angle);
    final bytes = _bytesBuilder.takeBytes();
    mobileControlsWs.send(bytes);
  }
}
