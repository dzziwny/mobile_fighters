import 'package:core/core.dart';
import 'package:uuid/uuid.dart';

import 'bloc/attack.bloc.dart';
import 'server_client.dart';
import 'service/_service.dart';
import 'ws.dart';

final serverClient = ServerClient();

final playersWs = Ws(Socket.playersWs, Player.parseToList);
final playerChangeWs = Ws(Socket.playerChangeWs, PlayerChangeDto.parse);
final positionWs = Ws(Socket.pushWs, Position.fromBytes);
final dashWs = Ws(Socket.dashWs, DashDto.fromBytes);
final attackWs = Ws(Socket.attackWs, AttackResponse.fromBytes);
final cooldownWs = Ws(Socket.cooldownWs, CooldownDto.fromBytes);
final hitWs = Ws(Socket.hitWs, HitDto.fromBytes);
final deadWs = Ws(Socket.deadWs, (List<int> bytes) => bytes[0]);
final teamWs = Ws(Socket.selectTeamWs, TeamsDto.parse);

final positionService = PositionService();
final cooldownService = CooldownService();
final teamService = TeamService();

final attackBloc = AttackBloc();

const uuid = Uuid();
