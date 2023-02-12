import 'package:uuid/uuid.dart';

import 'bloc/attack.bloc.dart';
import 'server_client.dart';
import 'service/_service.dart';

final serverClient = ServerClient();

final attackService = AttackService();
final positionService = PositionService();

final attackBloc = AttackBloc();

const uuid = Uuid();
