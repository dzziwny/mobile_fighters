import 'package:web_socket_channel/web_socket_channel.dart';

final players = <int, int>{};

/*
* key   ->  playerId
* value ->  [x, y, angle]
*/
final playerPositions = <int, List<double>>{};

final playerPositionUpdates = <int, List<int>>{};

final playerKnobs = <int, List<double>>{};

int ids = 0;

List<WebSocketChannel> channels = [];

double maxSpeed = 0.00001;
double maxX = 750;
double minX = 50;
double maxY = 550;
double minY = 50;
