import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Rail extends StatelessWidget {
  Rail({
    Key? key,
  }) : super(key: key);

  final client = GetIt.I<ServerClient>();

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      destinations: [
        NavigationRailDestination(
          icon: IconButton(
            onPressed: () => client.leaveGame(),
            icon: const Icon(Icons.logout_rounded),
          ),
          label: const Text('Leave'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.play_arrow_rounded),
          label: Text('Play'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
      // leading: CircleAvatar(
      //   child: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.login),
      //   ),
      // ),
      selectedIndex: 0,
    );
  }
}
