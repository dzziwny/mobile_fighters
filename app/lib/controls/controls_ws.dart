import 'package:bubble_fight/ws.dart';
import 'package:core/core.dart';

final mobileControlsWs =
    Ws(Socket.mobilePlayerStateWs, PlayerViewModel.manyFromBytes);
final desktopControlsWs =
    Ws(Socket.desktopPlayerStateWs, MovementKeyboard.fromBytes);
