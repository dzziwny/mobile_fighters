import 'package:flutter/material.dart';

class Rail extends StatelessWidget {
  const Rail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.play_arrow),
          label: Text('Play'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
      leading: CircleAvatar(
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.login),
        ),
      ),
      selectedIndex: 0,
    );
  }
}
