import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class AutoRefreshState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin<T> {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => setState(() {}));
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
