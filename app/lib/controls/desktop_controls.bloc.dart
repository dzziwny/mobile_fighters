import 'dart:typed_data';

import 'package:bubble_fight/60hz_refreshable_playground/playground_controls_wrapper.dart';
import 'package:bubble_fight/ws.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'controls.bloc.dart';

class DesktopControlsBloc extends ControlsBloc implements Disposable {
  int _keys = 0;
  Uint8List _angle = [0, 0, 0, 0].toBytes();

  final _bytesBuilder = BytesBuilder();

  final desktopControlsWs =
      Ws(Socket.desktopControlsWs, MovementKeyboard.fromBytes);

  final statesMap = {
    PhysicalKeyboardKey.keyW: Bits.w,
    PhysicalKeyboardKey.keyS: Bits.s,
    PhysicalKeyboardKey.keyA: Bits.a,
    PhysicalKeyboardKey.keyD: Bits.d,
    PhysicalKeyboardKey.keyP: Bits.bullet,
    PhysicalKeyboardKey.keyB: Bits.bomb,
    PhysicalKeyboardKey.space: Bits.dash,
  };

  DesktopControlsBloc() {
    playgroundFocusNode.onKey = (_, event) => handleState(event);
  }

  KeyEventResult handleState(RawKeyEvent event) {
    final bit = statesMap[event.physicalKey];
    if (bit == null) {
      return KeyEventResult.ignored;
    }

    _keys = event is RawKeyDownEvent ? _keys | bit : _keys & ~bit;

    _sendPlayerState();
    return KeyEventResult.handled;
  }

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
    _angle = angle.toBytes();
    _sendPlayerState();
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

  void _sendPlayerState() {
    _bytesBuilder.addByte(_keys);
    _bytesBuilder.add(_angle);
    final bytes = _bytesBuilder.takeBytes();
    desktopControlsWs.send(bytes);
  }

  @override
  Future onDispose() async {
    playgroundFocusNode.dispose();
  }
}
