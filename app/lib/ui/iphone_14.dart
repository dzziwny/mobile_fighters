import 'package:flutter/cupertino.dart';

class IPhone14 extends StatelessWidget {
  const IPhone14({super.key});

  @override
  Widget build(BuildContext context) {
    const deviceHeight = 720.0;
    const deviceWidth = 332.7;
    const deviceRadius = 36.0;

    const frameThickness = 11.0;
    const frameHeight = deviceHeight + frameThickness * 2;
    const frameWidth = deviceWidth + frameThickness * 2;
    const frameRadius = deviceRadius + frameThickness;
    const frameColor = CupertinoColors.systemGrey5;

    const topLineHeight = 3.0;
    const topLineWidth = deviceWidth / 6.5;
    const topLineTop = 4.0;
    const topLineLeft = frameWidth / 2.0 - topLineWidth / 2.0;
    const topLineRadius = 2.0;
    const topLineColor = Color.fromARGB(255, 142, 142, 147);

    const notchTop = frameThickness - 1.0;
    const notchWidth = frameWidth / 2.7;
    const notchHeight = 27.0;
    const notchLeft = frameWidth / 2.0 - notchWidth / 2.0;
    const notchRadius = 20.0;
    const notchColor = frameColor;

    const externalFrameThickness = 5.0;
    const externalFrameHeight = frameHeight + externalFrameThickness * 2;
    const externalFrameWidth = frameWidth + externalFrameThickness * 2;
    const externalFrameRadius = frameRadius + externalFrameThickness;
    const externalFrameColor = Color.fromARGB(255, 72, 72, 74);

    const cameraSize = 15.0;
    const cameraRadius = cameraSize / 2;
    const cameraLensSize = cameraSize / 2.2;
    const cameraLensRadius = cameraLensSize / 2;

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
        child: Stack(
          children: [
            SizedBox(
              height: frameHeight,
              width: frameWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(frameRadius)),
                  color: frameColor,
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(deviceRadius),
                    ),
                    child: SizedBox(
                      height: deviceHeight,
                      width: deviceWidth,
                      child: Stack(
                        children: [
                          CupertinoApp(
                            debugShowCheckedModeBanner: false,
                            theme: CupertinoThemeData(
                              // brightness: Brightness.dark,
                              brightness: Brightness.light,
                            ),
                            home: CupertinoPageScaffold(
                              navigationBar: CupertinoNavigationBar(),
                              child: SizedBox(),
                              // child: CupertinoTabScaffold(
                              //   tabBar: CupertinoTabBar(
                              //     iconSize: 24.0,
                              //     items: const <BottomNavigationBarItem>[
                              //       BottomNavigationBarItem(
                              //         icon: Icon(CupertinoIcons.star_fill),
                              //         label: 'Favourites',
                              //       ),
                              //       BottomNavigationBarItem(
                              //         icon: Icon(CupertinoIcons.clock_solid),
                              //         label: 'Recents',
                              //       ),
                              //       BottomNavigationBarItem(
                              //         icon: Icon(CupertinoIcons
                              //             .person_alt_circle_fill),
                              //         label: 'Contacts',
                              //       ),
                              //       BottomNavigationBarItem(
                              //         icon: Icon(CupertinoIcons
                              //             .circle_grid_3x3_fill),
                              //         label: 'Keypad',
                              //       ),
                              //     ],
                              //   ),
                              //   tabBuilder:
                              //       (BuildContext context, int index) {
                              //     return Container();
                              //   },
                              // ),
                            ),
                          ),
                          // Positioned(
                          //   top: 10.0,
                          //   left: 155.0,
                          //   child: Container(
                          //     width: 14,
                          //     height: 14,
                          //     decoration: const BoxDecoration(
                          //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: topLineTop,
              left: topLineLeft,
              child: SizedBox(
                width: topLineWidth,
                height: topLineHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(topLineRadius),
                    ),
                    color: topLineColor,
                  ),
                ),
              ),
            ),
            Positioned(
              top: notchTop,
              left: notchLeft,
              child: SizedBox(
                width: notchWidth,
                height: notchHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: notchColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(notchRadius),
                      bottomRight: Radius.circular(notchRadius),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: cameraSize),
                      SizedBox(
                        width: cameraSize,
                        height: cameraSize,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(cameraRadius),
                            ),
                            color: CupertinoColors.systemGrey3,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: cameraLensSize,
                              height: cameraLensSize,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(cameraLensRadius),
                                  ),
                                  color: Color.fromARGB(255, 72, 72, 74),
                                ),
                              ),
                            ),
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
    );
  }
}
