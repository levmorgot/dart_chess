import 'dart:io';

import 'common.dart';
import 'constants.dart';
import 'figures.dart';
import 'game.dart';

void main() {
  Game game = Game(1, 2);
  game.printBoard();


  SpaceName? namePointWithFigure;
  SpaceName? nameAimPoint;
  Figure? figure;
  bool canMove = false;
  while (true) {
    namePointWithFigure = null;
    nameAimPoint = null;
    figure = null;
    canMove = false;

    while (figure == null) {
      namePointWithFigure = null;
      while (namePointWithFigure == null) {
        stdout.write("Введите адресс клетки со своей фигурой (a1): ");
        String line = stdin.readLineSync()!;
        namePointWithFigure = stringToSpaceName(line);
      }
      figure = game.chooseFigure(namePointWithFigure);
    }

    while (!canMove) {
      nameAimPoint = null;
      print(game.getPossibilityPoints(figure));
      print(figure);
      while (nameAimPoint == null) {
        stdout.write("Введите адресс клетки (a1): ");
        String line = stdin.readLineSync()!;
        nameAimPoint = stringToSpaceName(line);
      }
      canMove = true;
      canMove = game.checkPossibilityToMove(figure, nameAimPoint);
      if (!canMove) {
        print('Эта фигура не может сходить на эту клетку');
      }
    }
    game.move(figure, nameAimPoint!);

    game.printBoard();
  }
}
