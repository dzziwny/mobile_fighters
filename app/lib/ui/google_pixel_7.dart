import 'package:flutter/material.dart';

class GooglePixel7 extends StatelessWidget {
  const GooglePixel7({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        color: Colors.black,
      ),
      height: 740,
      width: 344,
      child: Center(
        child: Container(
          height: 720,
          width: 324,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
          ),
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                ),
                body: Builder(builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
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
              Positioned(
                top: 10.0,
                left: 155.0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
