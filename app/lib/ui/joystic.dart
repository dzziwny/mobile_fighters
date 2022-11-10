import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:get_it/get_it.dart';
import 'package:vector_math/vector_math.dart';

class Joystic extends StatefulWidget {
  const Joystic({
    Key? key,
  }) : super(key: key);

  @override
  State<Joystic> createState() => _JoysticState();
}

class _JoysticState extends State<Joystic> {
  var knobPosition = const Offset(65.0, 65.0);
  final client = GetIt.I<ServerClient>();
  double angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        var offset = details.localPosition;
        updateKnob(offset);

        setState(() {
          knobPosition = details.localPosition;
        });
      },
      onTapUp: (_) {
        const offset = Offset(65.0, 65.0);
        updateKnobButAngle(offset);
        setState(() {
          knobPosition = offset;
        });
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        var offset = details.localFocalPoint;
        update(offset);
      },
      onScaleEnd: (_) {
        const offset = Offset(65.0, 65.0);
        updateKnobButAngle(offset);
        setState(() {
          knobPosition = offset;
        });
      },
      child: _Joystic(knobPosition: knobPosition),
    );
  }

  void update(Offset offset) {
    const center = Offset(65.0, 65.0);
    final relativeOffset = offset - center;
    final distance = relativeOffset.distance;
    angle = screenAngle(Vector2(relativeOffset.dx, relativeOffset.dy));
    if (distance <= 50.0) {
      setState(() {
        knobPosition = offset;
      });
      client.updateKnob(angle, relativeOffset.dx, relativeOffset.dy);
      return;
    }

    final ratio = 50.0 / distance;
    final fixedRelative = relativeOffset * ratio;
    final knob = fixedRelative + center;
    setState(() {
      knobPosition = knob;
    });

    client.updateKnob(angle, fixedRelative.dx, fixedRelative.dy);
  }

  void updateKnob(Offset offset) {
    const center = Offset(65.0, 65.0);
    final relativeOffset = offset - center;
    angle = screenAngle(Vector2(relativeOffset.dx, relativeOffset.dy));
    client.updateKnob(angle, relativeOffset.dx, relativeOffset.dy);
  }

  void updateKnobButAngle(Offset offset) {
    const center = Offset(65.0, 65.0);
    final relativeOffset = offset - center;
    client.updateKnob(angle, relativeOffset.dx, relativeOffset.dy);
  }

  double screenAngle(Vector2 x) =>
      (x.clone()..y *= -1).angleToSigned(Vector2(0.0, 1.0));
}

class _Joystic extends StatelessWidget {
  const _Joystic({
    required Offset knobPosition,
    Key? key,
  })  : knobPosition = (knobPosition - const Offset(15.0, 15.0)),
        super(key: key);

  final Offset knobPosition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 130.0,
          height: 130.0,
          child: Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
                color: Color.fromARGB(255, 85, 85, 85),
              ),
            ),
          ),
        ),
        Positioned(
          top: knobPosition.dy,
          left: knobPosition.dx,
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: const BoxDecoration(
              color: material.Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}