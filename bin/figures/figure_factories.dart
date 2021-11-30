import '../common/constants.dart';
import 'figure.dart';

abstract class FigureFactory {
  final Side _startSide;
  final Color _color;

  FigureFactory(this._color, this._startSide);

  List<Figure> create();
}

class ChessFigureFactory extends FigureFactory {
  ChessFigureFactory(Color color, Side startSide) : super(color, startSide);

  @override
  List<Figure> create() {
    int yPawnsStartPosition = _startSide == Side.top ? 6 : 1;
    int yStartPosition = _startSide == Side.top ? 7 : 0;
    List<Figure> figures = [];
    for (int x = yPawnsStartPosition;
        x < chessboardSizeX * chessboardSizeY;
        x += 8) {
      figures.add(Pawn(_color, _startSide, SpaceName.values.toList()[x]));
      if (x ~/ 8 == 0 || x ~/ 8 == 7) {
        figures.add(Castle(
            _color, _startSide, SpaceName.values.toList()[yStartPosition]));
      }
      if (x ~/ 8 == 1 || x ~/ 8 == 6) {
        figures.add(Horse(
            _color, _startSide, SpaceName.values.toList()[yStartPosition]));
      }
      if (x ~/ 8 == 2 || x ~/ 8 == 5) {
        figures.add(Bishop(
            _color, _startSide, SpaceName.values.toList()[yStartPosition]));
      }
      if (x ~/ 8 == 3) {
        figures.add(Queen(
            _color, _startSide, SpaceName.values.toList()[yStartPosition]));
      }
      if (x ~/ 8 == 4) {
        figures.add(King(
            _color, _startSide, SpaceName.values.toList()[yStartPosition]));
      }
      yStartPosition += 8;
    }
    return figures;
  }
}
