import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';

class TeamService {
  Stream<bool> isSelectingTeam$() => Stream.value(true);

  Stream<List<String>> blueTeam$() => teamWs.data().map((teams) => teams.blue);
  Stream<List<String>> redTeam$() => teamWs.data().map((teams) => teams.red);

  Future<void> selectBlueTeam() => teamWs.send([0, 0].toBytes());
  Future<void> selectRedTeam() => teamWs.send([0, 1].toBytes());
}
