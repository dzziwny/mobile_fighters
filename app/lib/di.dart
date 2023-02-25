import 'package:core/core.dart';
import 'package:uuid/uuid.dart';

import 'bloc/attack.bloc.dart';
import 'server_client.dart';
import 'service/_service.dart';
import 'ws.dart';

final serverClient = ServerClient();

final playersWs = Ws(Endpoint.playersWs, Player.parseToList);
final playerChangeWs = Ws(Endpoint.playerChangeWs, PlayerChangeDto.parse);
final positionWs = Ws(Endpoint.pushWs, Position.fromBytes);
final dashWs = Ws(Endpoint.dashWs, DashDto.fromBytes);
final attackWs = Ws(Endpoint.attackWs, AttackResponse.fromBytes);
final cooldownWs = Ws(Endpoint.cooldownWs, CooldownDto.fromBytes);
final hitWs = Ws(Endpoint.hitWs, HitDto.fromBytes);
final deadWs = Ws(Endpoint.deadWs, (List<int> bytes) => bytes[0]);
final teamWs = Ws(Endpoint.selectTeamWs, TeamsDto.parse);

final positionService = PositionService();
final cooldownService = CooldownService();
final teamService = TeamService();

final attackBloc = AttackBloc();

const uuid = Uuid();
