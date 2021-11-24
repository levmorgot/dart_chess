library figures;

import 'dart:math';
import 'constants.dart';

mixin StraightRunner {
  //Move to horizontal
  List<Point> getPointsToStraightMove(Point figurePosition) {
    List<Point> points = [];
    for (var x = 0; x < xLineName.length; x++) {
      final Point movePoint = Point(x, figurePosition.y);
      if (movePoint != figurePosition) {
        points.add(movePoint);
      }
    }
    //Move to vertical
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
    var x = figurePosition.x + 1;
    var y = figurePosition.y + 1;
    //Move to up
    while (x <= xLineName.length - 1 && y <= yLineName.length - 1) {
      points.add(Point(x, y));
      x++;
      y++;
    }

    x = figurePosition.x - 1;
    y = figurePosition.y - 1;
    //Move to down
    while (x >= 0 && y >= 0) {
      points.add(Point(x, y));
      x--;
      y--;
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

  Point get currentPosition {
    return _position;
  }

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

  Pawn(Color color, Side startSide, Point position)
      : super(color, startSide, position) {
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
  Horse(Color color, Side startSide, Point position)
      : super(color, startSide, position);

  @override
  bool get canJump {
    return true;
  }

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

class King extends Figure {
  King(Color color, Side startSide, Point position)
      : super(color, startSide, position);

  @override
  List<Point> getPointsToMove() {
    var x = _position.x;
    var y = _position.y;
    List<Point> points = [
      Point(x + 1, y + 1),
      Point(x + 1, y - 1),
      Point(x - 1, y + 1),
      Point(x - 1, y - 1),
      Point(x + 1, y),
      Point(x - 1, y),
      Point(x, y + 1),
      Point(x, y - 1),
    ];
    return points;
  }
}

class Queen extends Figure with StraightRunner, DiagonalRunner {
  Queen(Color color, Side startSide, Point position)
      : super(color, startSide, position);

  @override
  List<Point> getPointsToMove() {
    return getPointsToStraightMove(_position) +
        getPointsToDiagonalMove(_position);
  }
}

class Bishop extends Figure with DiagonalRunner {
  Bishop(Color color, Side startSide, Point position)
      : super(color, startSide, position);

  @override
  List<Point> getPointsToMove() {
    return getPointsToDiagonalMove(_position);
  }
}

class Castle extends Figure with StraightRunner {
  Castle(Color color, Side startSide, Point position)
      : super(color, startSide, position);

  @override
  List<Point> getPointsToMove() {
    return getPointsToStraightMove(_position);
  }
}
