import 'package:core/core.dart';
import 'package:uuid/uuid.dart';

import 'bloc/attack.bloc.dart';
import 'endpoints.dart';
import 'server_client.dart';
import 'service/_service.dart';
import 'ws.dart';

final serverClient = ServerClient();

final playersWs = Ws(Route.playersWs, Player.parseToList);
final positionWs = Ws(Route.pushWs, Position.fromBytes);
final attackWs = Ws(Route.attackWs, AttackResponse.fromBytes);
final cooldownWs = Ws(Route.cooldownWs, CooldownDto.fromBytes);
final deadWs = Ws(Route.deadWs, (List<int> bytes) => bytes[0]);

final positionService = PositionService();
final cooldownService = CooldownService();

final attackBloc = AttackBloc();

const uuid = Uuid();
