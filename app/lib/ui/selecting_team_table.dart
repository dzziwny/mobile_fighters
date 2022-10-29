import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SelectingTeamTable extends StatelessWidget {
  SelectingTeamTable({
    Key? key,
  }) : super(key: key);

  final client = GetIt.I<ServerClient>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: client.isSelectingTeam$(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox();
        }

        return Center(
          child: Opacity(
            opacity: 0.9,
            child: Container(
              height: 500.0,
              width: 500.0,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.blue,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder<List<String>>(
                            stream: client.materialTeam$(),
                            builder: (context, snapshot) {
                              final players = snapshot.data ?? [];
                              return Column(
                                children: players
                                    .map<Widget>(
                                      (player) => Text(
                                        player,
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    )
                                    .toList()
                                  ..insert(
                                    0,
                                    const Divider(),
                                  )
                                  ..insert(
                                    0,
                                    const Text(
                                      'Material',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              );
                            }),
                        StreamBuilder<List<String>>(
                            stream: client.fluentTeam$(),
                            builder: (context, snapshot) {
                              final players = snapshot.data ?? [];
                              return Column(
                                children: players
                                    .map<Widget>(
                                      (player) => Text(
                                        player,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )
                                    .toList()
                                  ..insert(
                                    0,
                                    const Divider(),
                                  )
                                  ..insert(
                                    0,
                                    const Text(
                                      'Fluent',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              );
                            }),
                        StreamBuilder<List<String>>(
                            stream: client.cupertinoTeam$(),
                            builder: (context, snapshot) {
                              final players = snapshot.data ?? [];
                              return Column(
                                children: players
                                    .map<Widget>(
                                      (player) => Text(
                                        player,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    )
                                    .toList()
                                  ..insert(
                                    0,
                                    const Divider(),
                                  )
                                  ..insert(
                                    0,
                                    const Text(
                                      'Cupertino',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              );
                            }),
                        StreamBuilder<List<String>>(
                            stream: client.spectatorsTeam$(),
                            builder: (context, snapshot) {
                              final players = snapshot.data ?? [];
                              return Column(
                                children: players
                                    .map<Widget>(
                                      (player) => Text(
                                        player,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                    .toList()
                                  ..insert(
                                    0,
                                    const Divider(),
                                  )
                                  ..insert(
                                    0,
                                    const Text(
                                      'Spectators',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              );
                            }),
                      ],
                    ),
                  ),
                  // Flexible(
                  //   flex: 1,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       MaterialButton(
                  //         onPressed: () => client.selectBlueTeam(),
                  //         child: const Text(
                  //           '<',
                  //           style: TextStyle(
                  //             fontSize: 20.0,
                  //             color: Colors.blue,
                  //           ),
                  //         ),
                  //       ),
                  //       MaterialButton(
                  //         onPressed: () => client.selectRedTeam(),
                  //         child: const Text(
                  //           '>',
                  //           style: TextStyle(
                  //             color: Colors.red,
                  //             fontSize: 20.0,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
