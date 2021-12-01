import 'dart:io';
import 'dart:math';

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

    Figure nullFigure = NullFigure();

    while (game.winPlayer == null) {
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
      computerStep();
    }
  }

  void autoPlay() {

    while (game.winPlayer == null) {
      computerStep();
    }
  }

  void computerStep() {
    SpaceName? nameAimPoint;
    Figure nullFigure = NullFigure();
    Figure figure = nullFigure;
    bool canMove = false;


    while (figure == nullFigure) {
      figure = nullFigure;
      game.printBoardColor();
      var figures = game.activePlayer.figures.where((element) => !element.deathStatus).toList();
      int rand = Random(DateTime.now().microsecond).nextInt(figures.length);
      figure = figures[rand];

      if (figure != nullFigure && !game.canMove(figure)) {
        figure = nullFigure;
        print('Эта фигура сейчас не может двигаться');
      }
    }
    game.activeFigure = figure;
    game.printBoardColor();
    var points = game.getPossibilityPoints(figure);
    if (points.isNotEmpty) {
      int rand = Random(DateTime.now().microsecond).nextInt(points.length);
      nameAimPoint = points[rand];
      canMove = game.checkPossibilityToMove(figure, nameAimPoint);
      if (!canMove) {
        print(Process.runSync("clear", [], runInShell: true).stdout);
        game.printBoardColor();
        print('Эта фигура не может сходить на эту клетку');
      } else {
        game.move(figure, nameAimPoint);
      }
    } else {
      figure = nullFigure;
    }
  }
}
