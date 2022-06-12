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
    runner = updateFunc;
    return super.onDragStart(info);
  }

  @override
  bool onDragCancel() {
    runner = (_, __) {};
    updateFunc(
      0.0,
      delta,
    );
    return super.onDragCancel();
  }

  @override
  void update(double dt) {
    runner(dt, delta);
    super.update(dt);
  }
}
