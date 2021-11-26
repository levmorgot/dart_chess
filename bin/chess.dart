import 'constants.dart';
import 'game.dart';

void main() {
  Game game = Game(1,2);
  game.printBoard();
  game.move(game.player1.figures[0], SpaceName.a3);
  game.printBoard();
  game.move(game.player2.figures[3], SpaceName.a4);
  game.printBoard();
}
