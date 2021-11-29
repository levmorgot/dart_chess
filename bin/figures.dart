library figures;

import 'dart:math';
import 'common.dart';
import 'constants.dart';

mixin StraightRunner {
  //Move to horizontal
  List<SpaceName> getPointsToStraightMove(SpaceName currentSpaceName) {
    List<Point> newPoints = [];
    final Point figurePosition = chessboard[currentSpaceName]!;
    for (var x = 0; x < chessboardSizeX; x++) {
      final Point movePoint = Point(x, figurePosition.y);
      if (movePoint != figurePosition) {
        newPoints.add(movePoint);
      }
    }
    //Move to vertical
    for (var y = 0; y < chessboardSizeY; y++) {
      final Point movePoint = Point(figurePosition.x, y);
      if (movePoint != figurePosition) {
        newPoints.add(movePoint);
      }
    }
    return pointsListToSpaceNamesList(newPoints);
  }
}

mixin DiagonalRunner {
  List<SpaceName> getPointsToDiagonalMove(SpaceName currentSpaceName) {
    List<Point> newPoints = [];
    final Point figurePosition = chessboard[currentSpaceName]!;
    var x = figurePosition.x + 1;
    var y = figurePosition.y + 1;
    //Move to left up
    while (x <= chessboardSizeX - 1 && y <= chessboardSizeY - 1) {
      newPoints.add(Point(x, y));
      x++;
      y++;
    }

    x = figurePosition.x - 1;
    y = figurePosition.y + 1;
    //Move to right up
    while (x <= chessboardSizeX - 1 && y <= chessboardSizeY - 1) {
      newPoints.add(Point(x, y));
      x--;
      y++;
    }

    x = figurePosition.x - 1;
    y = figurePosition.y - 1;
    //Move to right down
    while (x >= 0 && y >= 0) {
      newPoints.add(Point(x, y));
      x--;
      y--;
    }

    x = figurePosition.x + 1;
    y = figurePosition.y - 1;
    //Move to left down
    while (x >= 0 && y >= 0) {
      newPoints.add(Point(x, y));
      x++;
      y--;
    }
    return pointsListToSpaceNamesList(newPoints);
  }
}

abstract class Figure {
  final Side _startSide;
  final Color _color;
  SpaceName _position;
  bool _death = false;

  bool _moved = false;

  Figure(this._color, this._startSide, this._position);

  SpaceName get currentPosition {
    return _position;
  }

  void toDeath() {
    _death = true;
  }

  Color get color {
    return _color;
  }

  bool  get moved {
    return _moved;
  }

  bool get deathStatus {
    return _death;
  }

  bool get canJump {
    return false;
  }

  bool get moveToDiagonal {
    return false;
  }

  bool get moveToStraight {
    return false;
  }

  bool get moveAround {
    return false;
  }

  bool get isKing {
    return false;
  }

  void gambit(SpaceName point) {
    _position = point;
    if (!_moved) {
      _moved = true;
    }
    print("$_color $runtimeType на $_position");
  }

  List<SpaceName> getPointsToMove();

  List<SpaceName> getPointsToAttack() {
    return getPointsToMove();
  }
}

class Pawn extends Figure {
  Course _course = Course.up;
  bool _moved = false;

  Pawn(Color color, Side startSide, SpaceName position)
      : super(color, startSide, position) {
    _startSide == Side.top ? _course = Course.down : _course = Course.up;
  }

  @override
  List<SpaceName> getPointsToMove() {
    var x = chessboard[_position]!.x;
    var y = chessboard[_position]!.y;
    var newYCoord = _course == Course.up ? y + 1 : y - 1;
    List<Point> newPoints = [Point(x, newYCoord)];
    if (!_moved) {
      var newYCoordForDoubleCells = _course == Course.up ? y + 2 : y - 2;
      newPoints.add(Point(x, newYCoordForDoubleCells));
    }
    return pointsListToSpaceNamesList(newPoints);
  }

  @override
  List<SpaceName> getPointsToAttack() {
    var x = chessboard[_position]!.x;
    var y = chessboard[_position]!.y;
    var newYCoord = _course == Course.up ? y + 1 : y - 1;
    List<Point> newPoints = [Point(x - 1, newYCoord), Point(x + 1, newYCoord)];
    return pointsListToSpaceNamesList(newPoints);
  }
}

class Horse extends Figure {
  Horse(Color color, Side startSide, SpaceName position)
      : super(color, startSide, position);

  @override
  bool get canJump {
    return true;
  }

  @override
  List<SpaceName> getPointsToMove() {
    var x = chessboard[_position]!.x;
    var y = chessboard[_position]!.y;
    List<Point> newPoints = [
      Point(x + 2, y + 1),
      Point(x + 2, y - 1),
      Point(x - 2, y + 1),
      Point(x - 2, y - 1),
      Point(x + 1, y + 2),
      Point(x + 1, y - 2),
      Point(x - 1, y + 2),
      Point(x - 1, y - 2),
    ];
    return pointsListToSpaceNamesList(newPoints);
  }
}

class King extends Figure {
  King(Color color, Side startSide, SpaceName position)
      : super(color, startSide, position);

  @override
  bool get moveAround {
    return true;
  }

  @override
  bool get isKing {
    return true;
  }

  @override
  List<SpaceName> getPointsToMove() {
    var x = chessboard[_position]!.x;
    var y = chessboard[_position]!.y;
    List<Point> newPoints = [
      Point(x + 1, y + 1),
      Point(x + 1, y - 1),
      Point(x - 1, y + 1),
      Point(x - 1, y - 1),
      Point(x + 1, y),
      Point(x - 1, y),
      Point(x, y + 1),
      Point(x, y - 1),
    ];
    return pointsListToSpaceNamesList(newPoints);
  }
}

class Queen extends Figure with StraightRunner, DiagonalRunner {
  Queen(Color color, Side startSide, SpaceName position)
      : super(color, startSide, position);

  @override
  bool get moveToDiagonal {
    return true;
  }

  @override
  bool get moveToStraight {
    return true;
  }

  @override
  List<SpaceName> getPointsToMove() {
    return getPointsToStraightMove(_position) +
        getPointsToDiagonalMove(_position);
  }
}

class Bishop extends Figure with DiagonalRunner {
  Bishop(Color color, Side startSide, SpaceName position)
      : super(color, startSide, position);

  @override
  bool get moveToDiagonal {
    return true;
  }

  @override
  List<SpaceName> getPointsToMove() {
    return getPointsToDiagonalMove(_position);
  }
}

class Castle extends Figure with StraightRunner {
  Castle(Color color, Side startSide, SpaceName position)
      : super(color, startSide, position);

  @override
  bool get moveToStraight {
    return true;
  }

  @override
  List<SpaceName> getPointsToMove() {
    return getPointsToStraightMove(_position);
  }
}
