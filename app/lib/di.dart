import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'bloc/attack.bloc.dart';
import 'server_client.dart';
import 'service/_service.dart';
import 'ws.dart';

final serverClient = ServerClient();

final attackWs = Ws(Endpoint.attackWs, AttackResponse.fromBytes);
final positionWs = Ws(
  kIsWeb ? Endpoint.pushWsWeb : Endpoint.pushWs,
  Position.fromBytes,
);

final positionService = PositionService();

final attackBloc = AttackBloc();

const uuid = Uuid();
