import 'dart:typed_data';

import 'package:core/src/bits.dart';
import 'package:core/src/constants.dart';
import 'package:core/src/extensions.dart';
import 'package:json_annotation/json_annotation.dart';

import 'device.dart';
import 'team.dart';

part 'player.g.dart';

class PlayerViewModel {
  final int id;
  double x;
  double y;
  double angle;
  double hp;
  int isDashCooldown;
  int isBombCooldown;

  PlayerViewModel({
    required this.id,
    required this.x,
    required this.y,
    required this.angle,
    required this.hp,
    required this.isDashCooldown,
    required this.isBombCooldown,
  });

  factory PlayerViewModel.fromBytes(Uint8List bytes, int id) {
    final position = bytes.sublist(0, 4).buffer.asUint16List();
    final x = position[0];
    final y = position[1];
    return PlayerViewModel(
      id: id,
      x: x.toDouble(),
      y: y.toDouble(),
      angle: bytes.toDouble(4, 8),
      isDashCooldown: bytes[8] & Bits.dashCooldown,
      isBombCooldown: bytes[8] & Bits.bombCooldown,
      hp: bytes[9].toDouble(),
    );
  }

  factory PlayerViewModel.empty(int playerId) => PlayerViewModel(
        id: playerId,
        x: 0,
        y: 0,
        angle: 0.0,
        isBombCooldown: 0,
        isDashCooldown: 0,
        hp: 1,
      );

  static List<PlayerViewModel> manyFromBytes(Uint8List bytes) {
    final positions = <PlayerViewModel>[];
    int id = 0;
    for (var i = 0; i < bytes.length; i += Player.bytesCount) {
      final chunk = bytes.sublist(i, i + Player.bytesCount);
      final position = PlayerViewModel.fromBytes(chunk, id);
      id++;
      positions.add(position);
    }

    return positions;
  }
}

@JsonSerializable(explicitToJson: true)
class Player extends PlayerViewModel {
  double velocityX = 0.0;
  double velocityY = 0.0;
  String nick = '';
  Team team = Team.blue;
  Device device = Device.iphone;
  bool isActive = false;

  /// Proportionality constant that relates the friction force to the velocity
  /// of the object. Its value is determined by the properties of the materials
  /// in contact, such as the surface roughness, and the density of the fluid
  /// or gas
  // double k = 0.1;

  /// depends on the nature of the surfaces in contact, and it can be different
  /// for different materials. For example, when an object moves through a
  /// fluid, the value of "n" can be different for laminar and turbulent
  /// flows. Also can be different for different types of materials,
  /// such as rubber or steel.
  // double n = 0.25;

  Player({
    required super.id,
    super.x = 0.0,
    super.y = 0.0,
    super.angle = 0.0,
    super.hp = startHp,
    super.isDashCooldown = 0,
    super.isBombCooldown = 0,
  });

  factory Player.empty(int id) => Player(id: id);

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  static int bytesCount = Player.empty(0).toBytes().length;
  static int allBytesCount = bytesCount * maxPlayers;

  Uint8List toBytes() {
    final x = (ByteData(2)..setInt16(0, this.x.toInt(), Endian.little))
        .buffer
        .asUint8List();
    final y = (ByteData(2)..setInt16(0, this.y.toInt(), Endian.little))
        .buffer
        .asUint8List();

    final builder = BytesBuilder();
    builder
      ..add(x)
      ..add(y)
      ..add(angle.toBytes())
      ..addByte(isDashCooldown | isBombCooldown)
      ..addByte(hp.toInt());

    return builder.toBytes();
  }
}

extension PlayersToBytes on List<Player> {
  Uint8List toBytes() {
    final builder = BytesBuilder();
    for (var player in this) {
      builder.add(player.toBytes());
    }

    return builder.toBytes();
  }
}
