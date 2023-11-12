import 'package:flutter/material.dart';

class GooglePixel7 extends StatelessWidget {
  const GooglePixel7({super.key});

  @override
  Widget build(BuildContext context) {
    const deviceHeight = 720.0;
    const deviceWidth = 324.0;
    const deviceRadius = 16.0;

    const frameThickness = 8.0;
    const frameHeight = deviceHeight + frameThickness * 3;
    const frameWidth = deviceWidth + frameThickness * 2;
    const frameRadius = deviceRadius + frameThickness;
    const frameColor = Color.fromARGB(255, 20, 20, 20);

    const externalFrameThickness = 2.0;
    const externalFrameHeight = frameHeight + externalFrameThickness * 2;
    const externalFrameWidth = frameWidth + externalFrameThickness * 2;
    const externalFrameRadius = deviceRadius;
    const externalFrameColor = Colors.black;

    return const SizedBox(
      height: externalFrameHeight,
      width: externalFrameWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(externalFrameRadius),
            topRight: Radius.circular(externalFrameRadius),
            bottomRight: Radius.circular(externalFrameRadius),
            bottomLeft: Radius.circular(externalFrameRadius * 1.2),
          ),
          color: externalFrameColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: frameHeight,
              width: frameWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(frameRadius)),
                  color: frameColor,
                ),
                child: Column(
                  children: [
                    SizedBox(height: frameThickness),
                    SizedBox(
                      height: deviceHeight,
                      width: deviceWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(deviceRadius)),
                        ),
                        child: ClipPath(
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            children: [
                              Scaffold(
                                  // TODO
                                  // appBar: AppBar(
                                  //   leading: IconButton(
                                  //     onPressed: () {},
                                  //     icon: const Icon(Icons.menu),
                                  //   ),
                                  // ),
                                  // bottomNavigationBar: Padding(
                                  //   padding: const EdgeInsets.only(bottom: 16.0),
                                  //   child: BottomNavigationBar(
                                  //     type: BottomNavigationBarType.fixed,
                                  //     items: const [
                                  //       BottomNavigationBarItem(
                                  //         icon: Icon(Icons.mail),
                                  //         label: 'Mail',
                                  //       ),
                                  //       BottomNavigationBarItem(
                                  //         icon: Icon(Icons.chat_bubble_outline),
                                  //         label: 'Chat',
                                  //       ),
                                  //       BottomNavigationBarItem(
                                  //         icon: Icon(Icons.people_outline),
                                  //         label: 'Rooms',
                                  //       ),
                                  //       BottomNavigationBarItem(
                                  //         icon: Icon(Icons.videocam_outlined),
                                  //         label: 'Meet',
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  ),
                              Positioned(
                                top: 11.0,
                                left: 155.0,
                                width: 19,
                                height: 19,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.5)),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 7.0,
                                left: 162.0 - 40.5,
                                width: 2 * 40.5,
                                height: 3,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7.0)),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
