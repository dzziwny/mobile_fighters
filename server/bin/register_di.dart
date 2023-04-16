import 'package:get_it/get_it.dart';

import 'handler/channels.handler.dart';
import 'handler/knob.input.dart';

registerDI() {
  GetIt.I.registerSingleton(ChannelsHandler());

  GetIt.I.registerSingleton(KnobInput());
}
