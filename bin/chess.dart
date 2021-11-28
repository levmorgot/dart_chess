import 'dart:io';

import 'common.dart';
import 'constants.dart';
import 'figures.dart';
import 'game.dart';

void main() {
  Game game = Game(1, 2);

  SpaceName? namePointWithFigure;
  SpaceName? nameAimPoint;
  Figure? figure;
  bool canMove = false;
  while (true) {
    game.printBoardColor();
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
      if (game.getPossibilityPoints(figure!).isEmpty){
        figure = null;
        print(Process.runSync("clear", [], runInShell: true).stdout);
        game.activeFigure = null;
        game.printBoardColor();
        print('Эта фигура сейчас не может двигаться');
      }
    }
    game.printBoardColor();
    while (!canMove) {
      nameAimPoint = null;
      print(game.getPossibilityPoints(figure));
      while (nameAimPoint == null) {
        stdout.write("Введите адресс клетки (a1): ");
        String line = stdin.readLineSync()!;
        nameAimPoint = stringToSpaceName(line);
      }
      canMove = true;
      canMove = game.checkPossibilityToMove(figure, nameAimPoint);
      if (!canMove) {
        print(Process.runSync("clear", [], runInShell: true).stdout);
        game.printBoardColor();
        print('Эта фигура не может сходить на эту клетку');
      }
    }
    game.move(figure, nameAimPoint!);

  }
}
