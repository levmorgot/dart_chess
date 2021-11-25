import 'figure_factories.dart';
import 'constants.dart';
import 'figures.dart';
import 'player.dart';

void main() {
  Player player1 = Player(1, ChessFigureFactory(Color.black, Side.bottom));
  // for (var figure in player1.figures) {
  //   print('${figure.runtimeType.toString()[0]}, ${figure.currentPosition}');
  // }
  // print("_______________________________");
  Player player2 = Player(2, ChessFigureFactory(Color.white, Side.top));
  // for (var figure in player2.figures) {
  //   print('${figure.runtimeType.toString()[0]}, ${figure.currentPosition}');
  // }

  final Map<SpaceName, Figure?> gameBoard = {};

  chessboard.forEach((k, v) {
    gameBoard[k] = player1.getFigureByPosition(k);
    if (gameBoard[k] == null) {
      gameBoard[k] = player2.getFigureByPosition(k);
    }
  });

  for (int x = 0; x < chessboardSizeX; x++) {
    List<String> lineFigures = [];
    for (int y = 0; y < chessboardSizeX; y++) {
      var type = gameBoard[SpaceName.values[y * 8 + x]].runtimeType;
      if (type != Null) {
        lineFigures.add(type.toString()[0]);
      } else {
        lineFigures.add('_');
      }
    }
    print(lineFigures.join(' '));
  }
}
