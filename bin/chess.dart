import 'dart:math';
import 'figures.dart';
import 'constants.dart';

List<Point> cells = [];

void main() {


  Figure pawn = Pawn(Color.black, Side.top, chessboard[SpaceName.a1]!);
  Figure horse = Horse(Color.white, Side.bottom, chessboard[SpaceName.a1]!);

  print(horse.currentPosition);
  print(horse.getPointsToMove());
}
