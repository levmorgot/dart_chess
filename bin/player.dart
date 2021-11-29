import 'constants.dart';
import 'figure_factories.dart';
import 'figures.dart';

class Player {
  final int id;
  List<Figure> figures = [];

  Player(this.id, FigureFactory factory) {
    figures = factory.create();
  }

  List<SpaceName> getAllFiguresPositions() {
    return figures.map((e) => e.currentPosition).toList();
  }

  Figure? getFigureByPosition(SpaceName position) {
    try {
      return figures.where((e) => e.currentPosition == position).toList().first;
    } catch (_) {
      return null;
    }
  }

  Color get color {
    return figures[0].color;
  }
}
