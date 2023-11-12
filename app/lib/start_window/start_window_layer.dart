import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'start_window.controller.dart';
import 'start_window.dart';

class StartWindowLayer extends StatefulWidget {
  const StartWindowLayer({
    Key? key,
  }) : super(key: key);

  @override
  State<StartWindowLayer> createState() => _StartWindowLayerState();
}

class _StartWindowLayerState extends State<StartWindowLayer> {
  var show = true;

  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = startWindowController.show().listen((state) {
      setState(() {
        show = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SizedBox.shrink();
    }

    return const MouseRegion(
      child: Center(
        child: FittedBox(
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: SizedBox(
                height: 500.0,
                child: FittedBox(
                  child: SizedBox(
                    width: 600 * goldenRatio,
                    height: 600,
                    child: StartWindow(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}
