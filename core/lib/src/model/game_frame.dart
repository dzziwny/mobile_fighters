// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_frame.freezed.dart';
part 'game_frame.g.dart';

@freezed
class GameFrame with _$GameFrame {
  @JsonSerializable(explicitToJson: true)
  const factory GameFrame({
    required double sizex,
    required double sizey,
    required double positionx,
    required double positiony,
  }) = _GameFrame;

  factory GameFrame.fromJson(Map<String, dynamic> json) =>
      _$GameFrameFromJson(json);
}
