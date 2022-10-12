import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';

class NickWindow extends StatelessWidget {
  const NickWindow({
    Key? key,
    required this.nickController,
    required this.client,
  }) : super(key: key);

  final TextEditingController nickController;
  final ServerClient client;

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
