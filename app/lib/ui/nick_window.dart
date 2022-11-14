import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/theme.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import 'google_pixel_7.dart';
import 'iphone_14.dart';
import 'player_widget.dart';

class NickWindow extends StatefulWidget {
  const NickWindow({
    Key? key,
  }) : super(key: key);

  @override
  State<NickWindow> createState() => _NickWindowState();
}

class _NickWindowState extends State<NickWindow> {
  // final nickController = TextEditingController(
  //   text: kDebugMode ? defaultTargetPlatform.name : null,
  // );
  final nickController = TextEditingController();
  final client = GetIt.I<ServerClient>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      // can be used with joystic
      // shape: CircleBorder(),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nickController,
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => setState(() {}),
                  maxLength: 15,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Text('Select a character'),
                      // ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FittedBox(child: GooglePixel7()),
                            const FittedBox(child: IPhone14()),
                            // CharacterCard(
                            //   name: 'HIG',
                            //   icon: SvgPicture.asset(
                            //     'assets/material-design.svg',
                            //   ),
                            //   description: 'Description',
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton.icon(
              label: const Text('Play'),
              onPressed: nickController.text == ''
                  ? null
                  : () {
                      client.createPlayer(nickController.text);
                    },
              icon: const Icon(Icons.play_arrow_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    required this.name,
    required this.icon,
    required this.description,
    Key? key,
  }) : super(key: key);

  final String name;
  final Widget icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(name),
              icon,
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
