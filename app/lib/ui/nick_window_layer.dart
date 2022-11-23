import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'nick_window.dart';

class NickWindowLayer extends StatelessWidget {
  NickWindowLayer({
    Key? key,
  }) : super(key: key);

  final client = GetIt.I<ServerClient>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: client.isInGame(),
      builder: (context, snapshot) {
        final isInGame = snapshot.data;
        if (isInGame == true) {
          return const SizedBox.shrink();
        }
        return const NickWindow();
      },
    );
  }
}
