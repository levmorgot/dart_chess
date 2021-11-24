library figures;

import 'dart:math';
import 'constants.dart';

mixin StraightRunner {
  List<Point> getPointsToStraightMove(Point figurePosition) {
    List<Point> points = [];
    for (var x = 0; x < xLineName.length; x++) {
      final Point movePoint = Point(x, figurePosition.y);
      if (movePoint != figurePosition) {
        points.add(movePoint);
      }
    }

    for (var y = 0; y < yLineName.length; y++) {
      final Point movePoint = Point(figurePosition.x, y);
      if (movePoint != figurePosition) {
        points.add(movePoint);
      }
    }
    return points;
  }
}
mixin DiagonalRunner {
  List<Point> getPointsToDiagonalMove(Point figurePosition) {
    List<Point> points = [];
    for (var x = 0; x < xLineName.length; x++) {
      final Point movePoint = Point(x, figurePosition.y);
      if (movePoint != figurePosition) {
        points.add(movePoint);
      }
    }

    for (var y = 0; y < yLineName.length; y++) {
      final Point movePoint = Point(figurePosition.x, y);
      if (movePoint != figurePosition) {
        points.add(movePoint);
      }
    }
    return points;
  }
}

abstract class Figure {
  final Side _startSide;
  final Color _color;
  Point _position;
  bool _death = false;

  Figure(this._color, this._startSide, this._position);

  void toDeath() {
    _death = true;
  }

  bool get deathStatus {
    return _death;
  }

  bool get canJump {
    return false;
  }

  void gambit(Point point) {
    _position = point;
    print(
        "${_color} ${this.runtimeType} на ${xLineName[point.x.toInt()]}${yLineName[point.y.toInt()]}");
  }

  List<Point> getPointsToMove();

  List<Point> getPointsToAttack() {
    return getPointsToMove();
  }
}

class Pawn extends Figure {
  Course _course = Course.up;

  Pawn(color, startSide, point) : super(color, startSide, point) {
    _startSide == Side.top ? _course = Course.down : _course = Course.up;
  }

  @override
  List<Point> getPointsToMove() {
    var x = _position.x;
    var y = _position.y;
    var newYCoord = _course == Course.up ? y + 1 : y - 1;
    List<Point> points = [Point(x, newYCoord)];
    print(_course);
    return points;
  }

  @override
  List<Point> getPointsToAttack() {
    var x = _position.x;
    var y = _position.y;
    var newYCoord = _course == Course.up ? y + 1 : y - 1;
    List<Point> points = [Point(x - 1, newYCoord), Point(x + 1, newYCoord)];
    return points;
  }
}

class Horse extends Figure {
  @override
  bool get canJump {
    return true;
  }

  Horse(color, _startSide, _position) : super(color, _startSide, _position);

  @override
  List<Point> getPointsToMove() {
    var x = _position.x;
    var y = _position.y;
    List<Point> points = [
      Point(x + 2, y + 1),
      Point(x + 2, y - 1),
      Point(x - 2, y + 1),
      Point(x - 2, y - 1),
      Point(x + 1, y + 2),
      Point(x + 1, y - 2),
      Point(x - 1, y + 2),
      Point(x - 1, y - 2),
    ];
    return points;
  }
}
