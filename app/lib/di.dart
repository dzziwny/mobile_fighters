import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'bloc/_bloc.dart';
import 'server_client.dart';
import 'service/_service.dart';
import 'ws.dart';

final serverClient = ServerClient();

final playersWs = Ws(Socket.playersWs, Player.parseToMap);
final playerChangeWs = Ws(Socket.playerChangeWs, PlayerChangeDto.parse);
final positionsWs = Ws(Socket.pushWs, PlayerPosition.positionsFromBytes);
final keyboardWs = Ws(Socket.movementKeyboardhWs, MovementKeyboard.fromBytes);
final rotateWs = Ws(Socket.rotateWs, PlayerAngle.fromBytes);
final dashWs = Ws(Socket.dashWs, DashDto.fromBytes);
final bombsWs = Ws(Socket.attackWs, BombAttackResponse.attacksFromBytes);
final bulletWs = Ws(Socket.bulletWs, BulletResponse.bulletsFromBytes);
final cooldownWs = Ws(Socket.cooldownWs, CooldownDto.fromBytes);
final hitWs = Ws(Socket.hitWs, HitDto.hitsFromBytes);
final fragWs = Ws(Socket.fragWs, FragDto.parse);
final teamWs = Ws(Socket.selectTeamWs, TeamsDto.parse);
final gameStateWs = Ws(Socket.gameStateWs, GameState.fromBytes);

final cooldownService = CooldownService();
final teamService = TeamService();

final attackBloc = AttackBloc();
final fragBloc = FragBloc();
final hpBloc = HpBloc();
final controlsBloc = ControlsBloc();
final positionBloc = PositionBloc();

const uuid = Uuid();

final isMobile = defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;
