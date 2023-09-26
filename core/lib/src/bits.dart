class Bits {
  // ---------------- KEYBOARD STATE ----------------

  // 0x10000000
  static const int w = 0x80;
  // 0x01000000
  static const int s = 0x40;
  // 0x00100000
  static const int a = 0x20;
  // 0x00010000
  static const int d = 0x10;

  // 0x00001000
  static const int bullet = 0x08;

  // ---------------- ATTACKS ----------------

  // 0x00000100
  static const int bomb = 0x04;
  // 0x00000100
  static const int dash = 0x02;

  static const int x = a | d;
  static const int y = w | s;

  // TODO try to imporve this frags logic to have a bigger const map
  static const List<int> frags = [
    0x0000000001,
    0x0000000010,
    0x0000000100,
    0x0000001000,
    0x0000010000,
    0x0000100000,
    0x0001000000,
    0x0010000000,
    0x0100000000,
    0x1000000000,
  ];

  // ---------------- PLAYER BOARD STATE ----------------
  // 0x1000
  static const int dashCooldown = 0x8;
  // 0x0100
  static const int bombCooldown = 0x4;
}

extension LogicOperations on int {
  bool on(int state) => this & state == state;
}
