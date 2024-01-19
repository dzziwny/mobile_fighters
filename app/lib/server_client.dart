import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'shared_preferences.dart';

part 'server_client.freezed.dart';

@freezed
class ServerClientState with _$ServerClientState {
  const factory ServerClientState({
    String? lastIp,
    @Default(0) int id,
    @Default(false) bool isInitialized,
    @Default(false) bool isConnecting,
    @Default(false) bool isPreparingToplay,
  }) = _ServerClientState;
}

class ServerClient implements Disposable {
  final String uuid;

  final state = ValueNotifier(const ServerClientState());
  final _stateController = StreamController<ServerClientState>();

  late final _stateStream = _stateController.stream.asBroadcastStream();
  late final StreamSubscription positionsSubscription;
  late final StreamSubscription myPositionSubscription;

  ServerClient({required this.uuid}) {
    state.addListener(() {
      _stateController.add(state.value);
    });
  }

  Future<bool> tryReconnect(String uuid, String base) async {
    state.value = state.value.copyWith(isConnecting: true);
    final response = await connect$(uuid, base);

    final id = response.id;
    if (id == null) {
      state.value = state.value.copyWith(
        isConnecting: false,
        isInitialized: true,
      );

      return false;
    }

    state.value = state.value.copyWith(
      id: id,
      lastIp: base,
      isConnecting: false,
      isInitialized: true,
    );

    return true;
  }

  Future<void> play(String ip, String nick, Device device) async {
    state.value = state.value.copyWith(isPreparingToplay: true);
    final response = await play$(uuid, 'http://$ip', nick, device);
    prefs.setString('previousIp', ip);
    state.value = state.value.copyWith(
      id: response.id,
      lastIp: ip,
      isPreparingToplay: false,
      isInitialized: true,
    );
  }

  Future<void> leaveGame() async {
    await leaveGame$(uuid, state.value.id, 'http://${state.value.lastIp}');
  }

  Future<void> setGameSettings(GameSettings settings) =>
      setGameSettings$(settings, 'http://${state.value.lastIp}');

  Stream<WebSocketChannel> channel(Socket socket) {
    return _stateStream
        .where(
      (state) =>
          state.isInitialized &&
          !state.isConnecting &&
          !state.isPreparingToplay &&
          state.lastIp != null,
    )
        .switchMap((state) {
      final id = state.id;
      final ip = state.lastIp;
      final uri = Uri.parse('ws://$ip${socket.route(id: id)}');
      var channel = WebSocketChannel.connect(uri);
      return Stream.periodic(const Duration(seconds: 2)).map(
        (_) {
          if (channel.closeCode != null || channel.closeReason != null) {
            final uri = Uri.parse('ws://$ip${socket.route(id: id)}');
            channel = WebSocketChannel.connect(uri);
          }

          return channel;
        },
      ).distinct();
    });
  }

  @override
  Future onDispose() async {
    await Future.wait([
      positionsSubscription.cancel(),
      myPositionSubscription.cancel(),
    ]);
  }
}

late final ServerClient serverClient;
