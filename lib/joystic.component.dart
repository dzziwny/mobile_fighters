import 'package:flame/input.dart';

class MyJoysticComponent extends JoystickComponent {
  MyJoysticComponent({
    super.knob,
    super.background,
    super.margin,
    void Function(double, Vector2, Vector2)? updateFunc,
  }) : updateFunc = updateFunc ?? ((_, __, ___) {});

  void Function(double, Vector2, Vector2) updateFunc;
  void Function(double, Vector2, Vector2) runner = (_, __, ___) {};

  @override
  bool onDragStart(DragStartInfo info) {
    runner = updateFunc;
    return super.onDragStart(info);
  }

  @override
  bool onDragCancel() {
    runner = (_, __, ___) {};
    return super.onDragCancel();
  }

  @override
  void update(double dt) {
    runner(dt, relativeDelta, delta);
    super.update(dt);
  }
}
