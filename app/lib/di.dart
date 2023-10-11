import 'package:bubble_fight/ui/nick_window.controller.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'bloc/_bloc.dart';
import 'server_client.dart';
import 'ws.dart';

final client = ServerClient();
const kDebug = kDebugMode;

final mobileControlsWs =
    Ws(Socket.mobilePlayerStateWs, PlayerViewModel.manyFromBytes);
final desktopControlsWs =
    Ws(Socket.desktopPlayerStateWs, MovementKeyboard.fromBytes);
final acitionsWs = Ws(Socket.actionsWs, (_) => Object());

final gameDataWs = Ws(Socket.gameDataWs, GameData.fromString);
final gameStateWs = Ws(Socket.gameStateWs, GameState.fromBytes);

final gameService = GameService();

final fragBloc = FragBloc();
final controlsBloc = isMobile ? MobileControlsBloc() : DesktopControlsBloc();
final positionBloc = PositionBloc();

const uuid = Uuid();

final gameBoardFocusNode = FocusNode();

final isMobile = defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

final nickWindowController = NickWindowController();
