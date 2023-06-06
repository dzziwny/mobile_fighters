import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class ControlsBloc implements Disposable {
  int _w = 0;
  int _s = 0;
  int _a = 0;
  int _d = 0;

  RawKeyEvent? lastMovementEvent;

  final gameBoardFocusNode = FocusNode();

  ControlsBloc() {
    gameBoardFocusNode.onKey = (node, event) {
      if (event.physicalKey == lastMovementEvent?.physicalKey &&
          event.runtimeType == lastMovementEvent?.runtimeType) {
        return KeyEventResult.handled;
      }

      lastMovementEvent = event;

      /*
      * Resolve actions
      */
      if (event.physicalKey == PhysicalKeyboardKey.space &&
          event is RawKeyDownEvent) {
        bombsWs.send(AttackRequest.bomb);
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.keyP) {
        if (event is RawKeyDownEvent) {
          bulletWs.send([1].toBytes());
        } else {
          bulletWs.send([0].toBytes());
        }

        return KeyEventResult.handled;
      }

      /*
      * Resolve movement
      */

      if (event.physicalKey == PhysicalKeyboardKey.keyW) {
        if (event is RawKeyDownEvent) {
          // 0x1000
          _w = 0x8;
        } else {
          _w = 0;
        }

        _sendKnob();
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.keyS) {
        if (event is RawKeyDownEvent) {
          // 0x0100
          _s = 0x4;
        } else {
          _s = 0;
        }

        _sendKnob();
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.keyA) {
        if (event is RawKeyDownEvent) {
          // 0x0010
          _a = 0x2;
        } else {
          _a = 0;
        }

        _sendKnob();
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.keyD) {
        if (event is RawKeyDownEvent) {
          // 0x0001
          _d = 0x1;
        } else {
          _d = 0;
        }

        _sendKnob();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    };
  }

  Future<void> _sendKnob() async {
    final state = _w | _s | _a | _d;
    final bytes = Uint8List.fromList([state]);
    await keyboardWs.send(bytes);
  }

  @override
  Future onDispose() async {}
}
