import 'figure_factories.dart';
import 'figures.dart';

class Player {
  final int id;
  List<Figure> figures = [];

  Player(this.id, FigureFactory factory) {
    figures = factory.create();
  }
}
