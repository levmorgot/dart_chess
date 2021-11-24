import 'dart:math';
import 'figures.dart';
import 'constants.dart';

List<Point> cells = [];

void main() {
  for (var y = 0; y < yLineName.length; y++) {
    for (var x = 0; x < xLineName.length; x++) {
      cells.add(Point(x, y));
    }
  }

  Figure pawn = Pawn(Color.black, Side.top, cells[2]);
  Figure horse = Horse(Color.white, Side.bottom, cells[2]);

  print(cells[2]);
  print(horse.canJump);
  print(pawn.canJump);
  horse.gambit(cells[2]);
  pawn.gambit(cells[2]);
  print(horse.getPointsToMove());
  print(pawn.getPointsToMove());
  print(pawn.getPointsToAttack());
  print(pawn.deathStatus);
  print(horse.deathStatus);
  pawn.toDeath();
  horse.toDeath();
  print(pawn.deathStatus);
  print(horse.deathStatus);
  print(pawn.getPointsToAttack());
}
