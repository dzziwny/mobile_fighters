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

    return Container(
      height: externalFrameHeight,
      width: externalFrameWidth,
      decoration: const BoxDecoration(
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
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(frameRadius)),
              color: frameColor,
            ),
            height: frameHeight,
            width: frameWidth,
            child: Column(
              children: [
                const SizedBox(height: frameThickness),
                Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(deviceRadius)),
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
                        // body: Builder(builder: (context) {
                        //   return const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }),
                        bottomNavigationBar: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: BottomNavigationBar(
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
                      Positioned(
                        top: 11.0,
                        left: 155.0,
                        child: Container(
                          width: 19,
                          height: 19,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.5)),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 7.0,
                        left: 162.0 - 40.5,
                        child: Container(
                          width: 2 * 40.5,
                          height: 3,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
