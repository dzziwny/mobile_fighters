import 'package:bubble_fight/di.dart';
import 'package:flutter/material.dart';

import 'nick_window.dart';

class NickWindowLayer extends StatelessWidget {
  const NickWindowLayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: serverClient.isInGame(),
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
