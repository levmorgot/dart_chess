import 'common/constants.dart';
import 'figures/figure_factories.dart';
import 'figures/figure.dart';

class Player {
  final int id;
  List<Figure> figures = [];

  Player(this.id, FigureFactory factory) {
    figures = factory.create();
  }

  List<SpaceName> getAllFiguresPositions() {
    return figures.map((e) => e.currentPosition).toList();
  }

  Figure getFigureByPosition(SpaceName position) {
    try {
      return figures.where((e) => e.currentPosition == position).toList().first;
    } catch (_) {
      return NullFigure();
    }
  }

  Color get color {
    return figures[0].color;
  }
}
