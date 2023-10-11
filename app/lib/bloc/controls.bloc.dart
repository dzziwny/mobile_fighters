import 'dart:typed_data';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

abstract class ControlsBloc {
  void startGun();
  void stopGun();
  void rotate(double angle);
  void dash();
  void startBomb();
  void stopBomb();
}

class MobileControlsBloc extends ControlsBloc {
  int _keys = 0;
  Uint8List _angle = [0, 0, 0, 0].toBytes();
  Uint8List _x = [0, 0, 0, 0].toBytes();
  Uint8List _y = [0, 0, 0, 0].toBytes();

  final _bytesBuilder = BytesBuilder();

  @override
  void startGun() {
    _keys = _keys | Bits.bullet;
    _sendPlayerState();
  }

  @override
  void stopGun() {
    _keys = _keys & ~Bits.bullet;
    _sendPlayerState();
  }

  @override
  void rotate(double angle) {
    throw Exception();
  }

  @override
  void dash() {
    // acitionsWs.send([Bits.dash].toBytes());
  }

  @override
  void startBomb() {
    // acitionsWs.send([Bits.bomb].toBytes());
  }

  @override
  void stopBomb() {
    // TODO: implement stopBomb
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

class DesktopControlsBloc extends ControlsBloc implements Disposable {
  int _keys = 0;
  Uint8List _angle = [0, 0, 0, 0].toBytes();

  RawKeyEvent? _lastMovementEvent;
  final _bytesBuilder = BytesBuilder();

  final statesMap = {
    PhysicalKeyboardKey.keyW: Bits.w,
    PhysicalKeyboardKey.keyS: Bits.s,
    PhysicalKeyboardKey.keyA: Bits.a,
    PhysicalKeyboardKey.keyD: Bits.d,
    PhysicalKeyboardKey.keyP: Bits.bullet,
    PhysicalKeyboardKey.keyB: Bits.bomb,
  };

  final actionsMap = {
    // PhysicalKeyboardKey.keyB: Bits.bomb,
    PhysicalKeyboardKey.space: Bits.dash,
  };

  DesktopControlsBloc() {
    gameBoardFocusNode.onKey = (_, event) {
      return handleActions(event) ?? handleState(event);
    };
  }

  KeyEventResult? handleActions(RawKeyEvent event) {
    if (event.physicalKey == _lastMovementEvent?.physicalKey &&
        event.runtimeType == _lastMovementEvent?.runtimeType) {
      return null;
    }

    _lastMovementEvent = event;

    final bit = actionsMap[event.physicalKey];
    if (bit == null) {
      return null;
    }

    acitionsWs.send([bit].toBytes());
    return KeyEventResult.handled;
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
  void startGun() {
    _keys = _keys | Bits.bullet;
    _sendPlayerState();
  }

  @override
  void stopGun() {
    _keys = _keys & ~Bits.bullet;
    _sendPlayerState();
  }

  @override
  void rotate(double angle) {
    _angle = angle.toBytes();
    _sendPlayerState();
  }

  @override
  void dash() {
    acitionsWs.send([Bits.dash].toBytes());
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
    gameBoardFocusNode.dispose();
  }
}
