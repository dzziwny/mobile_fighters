import 'package:flutter/material.dart';

class PlaygroundTabletFrame extends StatelessWidget {
  const PlaygroundTabletFrame({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tablet frame home button
          Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          // Tablet frame camera
          Container(
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            alignment: Alignment.center,
            child: Container(
              height: 5.0,
              width: 5.0,
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: const BorderRadius.all(Radius.circular(2.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
