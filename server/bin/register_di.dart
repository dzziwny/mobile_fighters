import 'package:get_it/get_it.dart';

import 'handler/channels.handler.dart';
import 'inputs/_input.dart';

registerDI() {
  GetIt.I.registerSingleton(ChannelsHandler());

  GetIt.I.registerSingleton(KnobInput());
  GetIt.I.registerSingleton(BulletInput());
}
