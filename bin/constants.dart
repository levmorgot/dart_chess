library contstants;

import 'dart:math';

enum Course{
  up,
  down
}

enum Color {
  black,
  white
}

enum Side {
  top,
  bottom
}

enum SpaceName {
  a1,
  a2,
  a3,
  a4,
  a5,
  a6,
  a7,
  a8,

  b1,
  b2,
  b3,
  b4,
  b5,
  b6,
  b7,
  b8,

  c1,
  c2,
  c3,
  c4,
  c5,
  c6,
  c7,
  c8,

  d1,
  d2,
  d3,
  d4,
  d5,
  d6,
  d7,
  d8,

  e1,
  e2,
  e3,
  e4,
  e5,
  e6,
  e7,
  e8,

  f1,
  f2,
  f3,
  f4,
  f5,
  f6,
  f7,
  f8,

  g1,
  g2,
  g3,
  g4,
  g5,
  g6,
  g7,
  g8,

  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  h7,
  h8,
  
}

const int chessboardSizeX = 8;
const int chessboardSizeY = 8;

final Map<SpaceName, Point> chessboard = {
 SpaceName.a1: Point(0, 0),
 SpaceName.a2: Point(0, 1),
 SpaceName.a3: Point(0, 2),
 SpaceName.a4: Point(0, 3),
 SpaceName.a5: Point(0, 4),
 SpaceName.a6: Point(0, 5),
 SpaceName.a7: Point(0, 6),
 SpaceName.a8: Point(0, 7),

 SpaceName.b1: Point(1, 0),
 SpaceName.b2: Point(1, 1),
 SpaceName.b3: Point(1, 2),
 SpaceName.b4: Point(1, 3),
 SpaceName.b5: Point(1, 4),
 SpaceName.b6: Point(1, 5),
 SpaceName.b7: Point(1, 6),
 SpaceName.b8: Point(1, 7),

 SpaceName.c1: Point(2, 0),
 SpaceName.c2: Point(2, 1),
 SpaceName.c3: Point(2, 2),
 SpaceName.c4: Point(2, 3),
 SpaceName.c5: Point(2, 4),
 SpaceName.c6: Point(2, 5),
 SpaceName.c7: Point(2, 6),
 SpaceName.c8: Point(2, 7),

 SpaceName.d1: Point(3, 0),
 SpaceName.d2: Point(3, 1),
 SpaceName.d3: Point(3, 2),
 SpaceName.d4: Point(3, 3),
 SpaceName.d5: Point(3, 4),
 SpaceName.d6: Point(3, 5),
 SpaceName.d7: Point(3, 6),
 SpaceName.d8: Point(3, 7),

 SpaceName.e1: Point(4, 0),
 SpaceName.e2: Point(4, 1),
 SpaceName.e3: Point(4, 2),
 SpaceName.e4: Point(4, 3),
 SpaceName.e5: Point(4, 4),
 SpaceName.e6: Point(4, 5),
 SpaceName.e7: Point(4, 6),
 SpaceName.e8: Point(4, 7),

 SpaceName.f1: Point(5, 0),
 SpaceName.f2: Point(5, 1),
 SpaceName.f3: Point(5, 2),
 SpaceName.f4: Point(5, 3),
 SpaceName.f5: Point(5, 4),
 SpaceName.f6: Point(5, 5),
 SpaceName.f7: Point(5, 6),
 SpaceName.f8: Point(5, 7),

 SpaceName.g1: Point(6, 0),
 SpaceName.g2: Point(6, 1),
 SpaceName.g3: Point(6, 2),
 SpaceName.g4: Point(6, 3),
 SpaceName.g5: Point(6, 4),
 SpaceName.g6: Point(6, 5),
 SpaceName.g7: Point(6, 6),
 SpaceName.g8: Point(6, 7),

 SpaceName.h1: Point(7, 0),
 SpaceName.h2: Point(7, 1),
 SpaceName.h3: Point(7, 2),
 SpaceName.h4: Point(7, 3),
 SpaceName.h5: Point(7, 4),
 SpaceName.h6: Point(7, 5),
 SpaceName.h7: Point(7, 6),
 SpaceName.h8: Point(7, 7),
};
