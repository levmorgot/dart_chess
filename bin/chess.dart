import 'dart:math';
import 'figure_factories.dart';
import 'constants.dart';
import 'player.dart';

List<Point> cells = [];

void main() {
  Player player1 = Player(1, ChessFigureFactory(Color.black, Side.bottom));
  for (var figure in player1.figures) {
    print('${figure.runtimeType}, ${figure.currentPosition}');
  }
  print("_______________________________");
  Player player2 = Player(2, ChessFigureFactory(Color.white, Side.top));
  for (var figure in player2.figures) {
    print('${figure.runtimeType}, ${figure.currentPosition}');
  }

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

  // print(bishop.runtimeType);
  // print(bishop.currentPosition);
  // print(bishop.getPointsToMove());
  // print(bishop.getPointsToAttack());
  // bishop.gambit(queen.getPointsToMove()[0]);
  //
  // print(castle.runtimeType);
  // print(castle.currentPosition);
  // print(castle.getPointsToMove());
  // print(castle.getPointsToAttack());
  // castle.gambit(castle.getPointsToMove()[0]);
}
