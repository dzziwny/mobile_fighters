import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:vector_math/vector_math.dart';

class MovementBloc implements Disposable {
  var _wDown = false;
  var _aDown = false;
  var _sDown = false;
  var _dDown = false;
  var _x = 0.0;
  var _y = 0.0;
  var _angle = 0.0;
  RawKeyEvent? lastMovementEvent;

  final gameBoardFocusNode = FocusNode();

  MovementBloc() {
    gameBoardFocusNode.onKey = (node, event) {
      /*
      * Resolve actions
      */
      if (event.physicalKey == PhysicalKeyboardKey.space &&
          event is RawKeyDownEvent) {
        attackWs.send(Uint8List(0));
        return KeyEventResult.handled;
      }

      /*
      * Resolve movement
      */
      if (event.physicalKey == lastMovementEvent?.physicalKey &&
          event.runtimeType == lastMovementEvent?.runtimeType) {
        return KeyEventResult.handled;
      }

      lastMovementEvent = event;

      if (event.physicalKey == PhysicalKeyboardKey.keyW) {
        if (event is RawKeyDownEvent) {
          _wDown = true;
        } else {
          _wDown = false;
        }

        _sendKnob();
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.keyS) {
        if (event is RawKeyDownEvent) {
          _sDown = true;
        } else {
          _sDown = false;
        }

        _sendKnob();
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.keyA) {
        if (event is RawKeyDownEvent) {
          _aDown = true;
        } else {
          _aDown = false;
        }

        _sendKnob();
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.keyD) {
        if (event is RawKeyDownEvent) {
          _dDown = true;
        } else {
          _dDown = false;
        }

        _sendKnob();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    };
  }

  void setAngle(
    PointerHoverEvent event,
    double halfWidth,
    double halfHeight,
  ) {
    if (!gameBoardFocusNode.hasFocus) {
      return;
    }

    final x = event.position.dx - halfWidth;
    final y = event.position.dy - halfHeight;
    _angle = (Vector2(x, y).clone()..y *= -1).angleToSigned(Vector2(0.0, 1.0));
    _sendKnob();
  }

  Future<void> _sendKnob() async {
    if (_aDown) {
      if (_dDown) {
        _x = 0.0;
      } else {
        _x = -5.0;
      }
    } else {
      if (_dDown) {
        _x = 5.0;
      } else {
        _x = 0.0;
      }
    }

    if (_wDown) {
      if (_sDown) {
        _y = 0.0;
      } else {
        _y = -5.0;
      }
    } else {
      if (_sDown) {
        _y = 5.0;
      } else {
        _y = 0.0;
      }
    }

    final bytes = Uint8List.fromList([
      0,
      ..._angle.toBytes(),
      ..._x.toBytes(),
      ..._y.toBytes(),
    ]);

    await positionWs.send(bytes);
  }

  @override
  Future onDispose() async {}
}
