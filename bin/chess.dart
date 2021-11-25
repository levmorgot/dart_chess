import 'figure_factories.dart';
import 'constants.dart';
import 'player.dart';


void main() {
  Player player1 = Player(1, ChessFigureFactory(Color.black, Side.bottom));
  for (var figure in player1.figures) {
    print('${figure.runtimeType.toString()[0]}, ${figure.currentPosition}');
  }
  print("_______________________________");
  Player player2 = Player(2, ChessFigureFactory(Color.white, Side.top));
  for (var figure in player2.figures) {
    print('${figure.runtimeType.toString()[0]}, ${figure.currentPosition}');
  }
}
