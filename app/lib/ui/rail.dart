import 'package:bubble_fight/di.dart';
import 'package:flutter/material.dart';

class Rail extends StatelessWidget {
  const Rail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      destinations: [
        NavigationRailDestination(
          icon: IconButton(
            onPressed: () => serverClient.leaveGame(),
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
