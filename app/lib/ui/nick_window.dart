import 'package:bubble_fight/server_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NickWindow extends StatefulWidget {
  const NickWindow({
    Key? key,
  }) : super(key: key);

  @override
  State<NickWindow> createState() => _NickWindowState();
}

class _NickWindowState extends State<NickWindow> {
  final nickController =
      TextEditingController(text: defaultTargetPlatform.name);
  final client = GetIt.I<ServerClient>();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (_, setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nickController,
            decoration: const InputDecoration(
              labelText: 'Nick',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Colors.blue,
                ),
              ),
            ),
            onChanged: (value) => setState(() {}),
            maxLength: 10,
          ),
          const SizedBox(height: 20.0),
          MaterialButton(
            color: Colors.blue,
            onPressed: nickController.text == ''
                ? null
                : () {
                    client.createPlayer(nickController.text);
                  },
            child: const Text('Enter the game'),
          ),
        ],
      );
    });
  }
}
