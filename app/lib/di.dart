import 'package:uuid/uuid.dart';

import 'bloc/attack.bloc.dart';
import 'server_client.dart';
import 'service/_service.dart';
import 'ws/_ws.dart';

final serverClient = ServerClient();

final attackWs = AttackWs();
final positionWs = PositionWs();

final positionService = PositionService();

final attackBloc = AttackBloc();

const uuid = Uuid();
