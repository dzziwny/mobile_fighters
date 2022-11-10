import 'package:core/core.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  const PlayerWidget({
    required this.player,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144.0,
      width: 89.0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //   border: Border.all(width: 4.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: FittedBox(
        child: SizedBox(
          height: 144.0 * 3,
          width: 89.0 * 3,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1.0,
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
              ),
            ),
            // body: Column(),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail),
                  label: 'Mail',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  label: 'Rooms',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.videocam_outlined),
                  label: 'Meet',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
