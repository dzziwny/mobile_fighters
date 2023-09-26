import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'nick_window.dart';

class NickWindowLayer extends StatefulWidget {
  const NickWindowLayer({
    Key? key,
  }) : super(key: key);

  @override
  State<NickWindowLayer> createState() => _NickWindowLayerState();
}

class _NickWindowLayerState extends State<NickWindowLayer> {
  var show = true;

  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = nickWindowController.show().listen((state) {
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
            width: borderWidth,
            height: borderHeight,
            child: Center(
              child: SizedBox(
                height: 500.0,
                child: FittedBox(
                  child: SizedBox(
                    width: 600 * goldenRatio,
                    height: 600,
                    child: NickWindow(),
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
