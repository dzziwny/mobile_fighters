import 'dart:io';

const multicastPort = 4545;
const toServerSocketPort = 49305;
const toHttpServerPort = 40705;
final toHttpServerAddress = InternetAddress.anyIPv4;
final multicastAddress = InternetAddress('239.10.10.100');
