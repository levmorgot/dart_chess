import 'dart:io';

import 'common.dart';
import 'constants.dart';
import 'figure_factories.dart';
import 'figures.dart';
import 'game.dart';
import 'player.dart';

class Room {
  late int id;
  late Player player1;
  late Player player2;
  late Game game;

  Player? winPlayer;

  Room(this.id, player1Id, player2Id) {
    player1 = Player(player1Id, ChessFigureFactory(Color.black, Side.bottom));
    player2 = Player(player1Id, ChessFigureFactory(Color.white, Side.top));
    Player activePlayer = _chooseActivePlayer();
    game = ChessGame(activePlayer, player1, player2);
  }

  Player _chooseActivePlayer() {
    return player1.color == Color.white ? player1 : player2;
  }

  void _switchActivePlayer() {
    game.activePlayer = game.activePlayer == player1 ? player2 : player1;
  }

  void play() {
    SpaceName? namePointWithFigure;
    SpaceName? nameAimPoint;
    Figure? figure;
    bool canMove = false;
    while (winPlayer == null) {
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
        if (game.getPossibilityPoints(figure!).isEmpty) {
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
      _switchActivePlayer();
    }
  }
}
