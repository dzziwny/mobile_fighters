import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';

class TeamService {
  // TODO
  Stream<bool> isSelectingTeam$() => Stream.value(true);

  Stream<List<String>> fluentTeam$() =>
      teamWs.data().map((teams) => teams.fluent);

  Stream<List<String>> cupertinoTeam$() =>
      teamWs.data().map((teams) => teams.cupertino);

  Stream<List<String>> materialTeam$() =>
      teamWs.data().map((teams) => teams.material);

  Stream<List<String>> spectatorsTeam$() =>
      teamWs.data().map((teams) => teams.spectators);

  Future<void> selectBlueTeam() => teamWs.send([0, 0].toBytes());
  Future<void> selectRedTeam() => teamWs.send([0, 1].toBytes());
}
