import 'constants.dart';
import 'game.dart';

void main() {
  Game game = Game(1,2);
  game.printBoard();
  game.move(SpaceName.a2, SpaceName.a3);
  game.printBoard();
  game.move(SpaceName.a5, SpaceName.a3);
  game.printBoard();
}
