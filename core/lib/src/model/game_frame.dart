import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_frame.freezed.dart';
part 'game_frame.g.dart';

@freezed
class GameFrame with _$GameFrame {
  const factory GameFrame({
    required int sizex,
    required int sizey,
  }) = _GameFrame;

  factory GameFrame.fromJson(Map<String, dynamic> json) =>
      _$GameFrameFromJson(json);
}
