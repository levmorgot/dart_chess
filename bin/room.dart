import 'dart:io';

import 'common/utils.dart';
import 'common/constants.dart';
import 'figures/figure_factories.dart';
import 'figures/figure.dart';
import 'games/game.dart';
import 'player.dart';

class Room {
  late int id;
  late Player player1;
  late Player player2;
  late Game game;

  Player? winPlayer;

  Room(this.id, player1Id, player2Id) {
    player1 = Player(player1Id, ChessFigureFactory(Color.white, Side.bottom));
    player2 = Player(player2Id, ChessFigureFactory(Color.black, Side.top));
    game = ChessGame(player1, player2);
  }

  void play() {
    SpaceName? namePointWithFigure;
    SpaceName? nameAimPoint;
    Figure figure;
    bool canMove = false;

    Figure f = game.chooseFigure(SpaceName.f2);
    game.move(f, SpaceName.f4);

    f = game.chooseFigure(SpaceName.e7);
    game.move(f, SpaceName.e6);

    f = game.chooseFigure(SpaceName.f4);
    game.move(f, SpaceName.f5);

    f = game.chooseFigure(SpaceName.e6);
    game.move(f, SpaceName.f5);

    f = game.chooseFigure(SpaceName.e2);
    game.move(f, SpaceName.e4);

    f = game.chooseFigure(SpaceName.d8);
    game.move(f, SpaceName.e7);

    f = game.chooseFigure(SpaceName.e4);
    game.move(f, SpaceName.f5);

    f = game.chooseFigure(SpaceName.e7);
    game.move(f, SpaceName.e6);

    f = game.chooseFigure(SpaceName.h1);
    game.move(f, SpaceName.e2);


    f = game.chooseFigure(SpaceName.e6);
    game.move(f, SpaceName.e5);

    Figure nullFigure = NullFigure();

    while (winPlayer == null) {
      namePointWithFigure = null;
      nameAimPoint = null;
      figure = nullFigure;
      canMove = false;

      while (figure == nullFigure) {
        namePointWithFigure = null;
        figure = nullFigure;
        game.printBoardColor();
        while (namePointWithFigure == null) {
          stdout.write("Введите адресс клетки со своей фигурой (a1): ");
          String line = stdin.readLineSync()!;
          namePointWithFigure = stringToSpaceName(line);
        }
        figure = game.chooseFigure(namePointWithFigure);

        if (figure != nullFigure && !game.canMove(figure)) {
          namePointWithFigure = null;
          figure = nullFigure;
          print('Эта фигура сейчас не может двигаться');
        }
      }
      game.activeFigure = figure;
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
}
