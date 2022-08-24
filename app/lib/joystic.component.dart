import 'package:flame/input.dart';

class MyJoysticComponent extends JoystickComponent {
  MyJoysticComponent({
    super.knob,
    super.background,
    super.margin,
    void Function(double, Vector2)? updateFunc,
  }) : updateFunc = updateFunc ?? ((_, __) {});

  void Function(double, Vector2) updateFunc;
  void Function(double, Vector2) runner = (_, __) {};

  @override
  bool onDragStart(DragStartInfo info) {
    final start = super.onDragStart(info);
    runner = updateFunc;
    return start;
  }

  @override
  bool onDragCancel() {
    runner = (_, __) {};
    updateFunc(
      screenAngle(delta),
      Vector2(0, 0),
    );
    return super.onDragCancel();
  }

  @override
  void update(double dt) {
    super.update(dt);
    runner(screenAngle(delta), delta);
  }

  double screenAngle(Vector2 x) =>
      (x.clone()..y *= -1).angleToSigned(Vector2(0.0, 1.0));
}
