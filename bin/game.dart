import 'constants.dart';
import 'figure_factories.dart';
import 'figures.dart';
import 'player.dart';

class Game {
  Map<SpaceName, Figure?> gameBoard = {};
  late Player player1;
  late Player player2;

  Game(player1Id, player2Id) {
    player1 = Player(player1Id, ChessFigureFactory(Color.black, Side.bottom));
    player2 = Player(player1Id, ChessFigureFactory(Color.white, Side.top));

    chessboard.forEach((k, v) {
      gameBoard[k] = player1.getFigureByPosition(k);
      if (gameBoard[k] == null) {
        gameBoard[k] = player2.getFigureByPosition(k);
      }
    });
  }

  void printBoard() {
    print([
      '   ',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
    ].join(' '));
    print('___________________');
    for (int x = chessboardSizeX - 1; x >= 0; x--) {
      List<String> lineFigures = [];
      for (int y = 0; y < chessboardSizeX; y++) {
        var type = gameBoard[SpaceName.values[y * 8 + x]].runtimeType;
        if (type != Null) {
          lineFigures.add(type.toString()[0]);
        } else {
          lineFigures.add('-');
        }
      }
      lineFigures.insert(0, '${x + 1} |');
      print(lineFigures.join(' '));
    }
    print('___________________');
    print([
      '   ',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
    ].join(' '));
  }

  void move(Figure figure, SpaceName aimPoint) {
    gameBoard[figure.currentPosition] = null;
    figure.gambit(aimPoint);
    gameBoard[figure.currentPosition] = figure;
  }
}
