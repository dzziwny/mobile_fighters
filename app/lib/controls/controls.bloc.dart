import 'package:bubble_fight/config.dart';

import 'desktop_controls.bloc.dart';
import 'mobile_controls.bloc.dart';

abstract class ControlsBloc {
  void startBullet();
  void stopBullet();
  void rotate(double angle);
  void startDash();
  void stopDash();
  void startBomb();
  void stopBomb();
}

final controlsBloc = isMobile ? MobileControlsBloc() : DesktopControlsBloc();
