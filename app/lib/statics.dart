import 'dart:io';

const multicastPort = 4545;
const toServerSocketPort = 49305;
const toHttpServerPort = 40705;
final toHttpServerAddress = InternetAddress.anyIPv4;
final multicastAddress = InternetAddress('239.10.10.100');
const borderHorizontalPadding = 40.0;
const borderVerticalPadding = 10.0;
// Ultra HD xddd
const boardScreenRatio = 0.5625;
const borderWidth = 1000.0;
const borderHeight = borderWidth * boardScreenRatio;
