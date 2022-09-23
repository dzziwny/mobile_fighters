import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/*
* key   ->  guid
* value ->  id
*/
final guids = <int, int>{};
/*
* key   ->  id
* value ->  Player
*/
final players = <int, Player>{};

/*
* key   ->  playerId
* value ->  [x, y, angle]
*/
final playerPositions = <int, List<double>>{};

final playerSpeed = <int, double>{};

final playerPositionUpdates = <int, List<int>>{};

final playerKnobs = <int, List<double>>{};

/*
* Game events. First value indicates, what event came.
* 0 - position update
* 1 - attack
*/
final gameUpdates = <List<int>>[];

/*
* Game draws. First value indicates, what event came.
* 0 - position update
* 1 - attack
*/
final gameDraws = <void Function()>[];

int ids = 0;

List<WebSocketChannel> rawDataWSChannels = [];
List<WebSocketChannel> playersWSChannels = [];
List<WebSocketChannel> playerChangeWSChannels = [];
List<WebSocketChannel> attackWSChannels = [];

// If there are lags, try make sliceTime smaller
const int sliceTime = 5000;

const double normalSpeed = 0.00001;
const double dashSpeed = 0.00005;
const double maxX = 750;
const double minX = 50;
const double maxY = 550;
const double minY = 50;
