import 'dart:typed_data';

extension DoubleToBytes on double {
  Uint8List toBytes() =>
      (ByteData(4)..setFloat32(0, this)).buffer.asUint8List();
}

extension ToBytesOnInts on List<int> {
  Uint8List toBytes() => Uint8List.fromList(this);
}

extension BytesToDouble on Uint8List {
  double toDouble(start, end) =>
      ByteData.sublistView(this, start, end).getFloat32(0);
}
