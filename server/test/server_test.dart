import 'dart:io';

import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/main.dart'],
      environment: {'PORT': '8080'},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  test("""
Create player twice with same uuid should return same id and not create one player,
Create player with new uuid should create a new player,
Get all players should return 2 players,
Leave game should work, return 200,
Get all players should return 1 player,
After leaving game, player should be removed,
""", () async {
    final createPlayerdto = await createPlayer$(100);
    final createPlayer2dto = await createPlayer$(100);

    expect(createPlayerdto.toString(), createPlayer2dto.toString());

    var players = await getPlayers$();

    expect(players.keys.length, 1);

    await createPlayer$(101);
    players = await getPlayers$();

    expect(players.keys.length, 2);

    await leaveGame$(100);

    players = await getPlayers$();

    expect(players.keys.length, 1);
  });
}