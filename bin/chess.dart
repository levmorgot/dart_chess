import 'dart:math';
import 'figures.dart';
import 'constants.dart';

List<Point> cells = [];

void main() {


  Figure pawn = Pawn(Color.black, Side.bottom, SpaceName.b2);
  Figure horse = Horse(Color.black, Side.bottom, SpaceName.e4);
  Figure king = King(Color.black, Side.bottom, SpaceName.e4);
  Figure queen = Queen(Color.black, Side.bottom, SpaceName.e4);
  Figure bishop = Bishop(Color.black, Side.bottom, SpaceName.e4);
  Figure castle = Castle(Color.black, Side.bottom, SpaceName.e4);

  // print(pawn.runtimeType);
  // print(pawn.currentPosition);
  // print(pawn.getPointsToMove());
  // print(pawn.getPointsToAttack());
  // pawn.gambit(pawn.getPointsToMove()[0]);

  // print(horse.runtimeType);
  // print(horse.currentPosition);
  // print(horse.getPointsToMove());
  // print(horse.getPointsToAttack());
  // horse.gambit(horse.getPointsToMove()[0]);

  // print(king.runtimeType);
  // print(king.currentPosition);
  // print(king.getPointsToMove());
  // print(king.getPointsToAttack());
  // king.gambit(king.getPointsToMove()[0]);

  // print(queen.runtimeType);
  // print(queen.currentPosition);
  // print(queen.getPointsToMove());
  // print(queen.getPointsToAttack());
  // queen.gambit(queen.getPointsToMove()[0]);

  print(bishop.runtimeType);
  print(bishop.currentPosition);
  print(bishop.getPointsToMove());
  print(bishop.getPointsToAttack());
  bishop.gambit(queen.getPointsToMove()[0]);

  print(castle.runtimeType);
  print(castle.currentPosition);
  print(castle.getPointsToMove());
  print(castle.getPointsToAttack());
  castle.gambit(castle.getPointsToMove()[0]);
}
