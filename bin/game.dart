import 'dart:math';

import 'common.dart';
import 'constants.dart';
import 'figure_factories.dart';
import 'figures.dart';
import 'player.dart';

class Game {
  Map<SpaceName, Figure?> gameBoard = {};
  late Player player1;
  late Player player2;
  late Player activePlayer;

  Game(player1Id, player2Id) {
    player1 = Player(player1Id, ChessFigureFactory(Color.black, Side.bottom));
    player2 = Player(player1Id, ChessFigureFactory(Color.white, Side.top));
    activePlayer = player2;

    chessboard.forEach((k, v) {
      gameBoard[k] = player1.getFigureByPosition(k);
      if (gameBoard[k] == null) {
        gameBoard[k] = player2.getFigureByPosition(k);
      }
    });
  }

  void printBoard() {
    print([
      '   ',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
    ].join(' '));
    print('___________________');
    for (int x = chessboardSizeX - 1; x >= 0; x--) {
      List<String> lineFigures = [];
      for (int y = 0; y < chessboardSizeX; y++) {
        var type = gameBoard[SpaceName.values[y * 8 + x]].runtimeType;
        if (type != Null) {
          lineFigures.add(type.toString()[0]);
        } else {
          lineFigures.add('-');
        }
      }
      lineFigures.insert(0, '${x + 1} |');
      print(lineFigures.join(' '));
    }
    print('___________________');
    print([
      '   ',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
    ].join(' '));
  }

  void _switchActivePlayer() {
    activePlayer = activePlayer == player1 ? player2 : player1;
  }

  Figure? chooseFigure(SpaceName point) {
    try {
      Figure figure = gameBoard[point]!;
      try {
        return activePlayer.figures.firstWhere((element) => element == figure);
      } catch (_) {
        print('Вы не можете играть фигурами другого игрока');
        return null;
      }
    } catch (_) {
      print('В клетке нет фигуры');
      return null;
    }
  }

  bool _isFriendFigure(SpaceName point) {
    return activePlayer.figures.contains(gameBoard[point]);
  }

  bool _isEmptyPoint(SpaceName point) {
    return gameBoard[point] == null;
  }

  bool _isEnemyFigure(SpaceName point) {
    return gameBoard[point] != null &&
        !activePlayer.figures.contains(gameBoard[point]);
  }

  void _editPossibilityPointsFromStartToCenter(
      List<SpaceName> list, SpaceName name) {
    if (_isEmptyPoint(name)) {
      list.add(name);
    } else {
      list.clear();
      if (_isEnemyFigure(name)) {
        list.add(name);
      }
    }
  }

  void _editPossibilityPointsFromCenterToEnd(
      List<SpaceName> list, SpaceName name) {
    if (list.isEmpty || _isEmptyPoint(list.last)) {
      list.add(name);
    }
  }

  void _removeFriendFigure(List<SpaceName> list) {
    if (list.isNotEmpty && _isFriendFigure(list.last)) {
      list.removeLast();
    }
  }

  List<SpaceName> _getPossibilityPointsDiagonal(Figure figure) {
    List<SpaceName> names = figure.getPointsToMove();
    final Point currentPoint = spaceNameToPoint(figure.currentPosition);
    List<SpaceName> namesUpRight = [];
    List<SpaceName> namesUpLeft = [];
    List<SpaceName> namesDownRight = [];
    List<SpaceName> namesDownLeft = [];
    for (int i = 0; i < names.length; i++) {
      final SpaceName name = names[i];
      final Point point = spaceNameToPoint(names[i]);
      if (point.x < currentPoint.x) {
        if (point.y < currentPoint.y) {
          // namesUpLeft
          _editPossibilityPointsFromStartToCenter(namesUpLeft, name);
        }
        if (point.y > currentPoint.y) {
          // namesDownLeft
          _editPossibilityPointsFromStartToCenter(namesDownLeft, name);
        }
      } else {
        if (point.y < currentPoint.y) {
          // namesUpRight
          _editPossibilityPointsFromCenterToEnd(namesUpRight, name);
        }
        if (point.y > currentPoint.y) {
          // namesDownRight
          _editPossibilityPointsFromCenterToEnd(namesDownRight, name);
        }
      }
    }
    _removeFriendFigure(namesUpRight);
    _removeFriendFigure(namesDownRight);
    return namesUpRight + namesDownRight + namesUpLeft + namesDownLeft;
  }

  List<SpaceName> _getPossibilityPointsStraight(Figure figure) {
    List<SpaceName> names = figure.getPointsToMove();
    final Point currentPoint = spaceNameToPoint(figure.currentPosition);
    List<SpaceName> namesUp = [];
    List<SpaceName> namesLeft = [];
    List<SpaceName> namesDown = [];
    List<SpaceName> namesRight = [];
    for (int i = 0; i < names.length; i++) {
      final SpaceName name = names[i];
      final Point point = spaceNameToPoint(names[i]);
      if (point.y < currentPoint.y) {
        // namesUpLeft
        _editPossibilityPointsFromStartToCenter(namesDown, name);
      }
      if (point.y > currentPoint.y) {
        // namesDownLeft
        _editPossibilityPointsFromCenterToEnd(namesUp, name);
      }
      if (point.x < currentPoint.x) {
        // namesUpRight
        _editPossibilityPointsFromStartToCenter(namesLeft, name);
      }
      if (point.x > currentPoint.x) {
        // namesDownRight
        _editPossibilityPointsFromCenterToEnd(namesRight, name);
      }
    }
    _removeFriendFigure(namesUp);
    _removeFriendFigure(namesRight);
    return namesDown + namesUp + namesLeft + namesRight;
  }

  List<SpaceName> getPossibilityPoints(Figure figure) {
    List<SpaceName> wayPoints = [];
    if (figure.runtimeType == Pawn) {
      wayPoints = figure
          .getPointsToMove()
          .where((element) => gameBoard[element] == null)
          .toList();
      wayPoints += figure
          .getPointsToAttack()
          .where((element) => _isEnemyFigure(element))
          .toList();
      return wayPoints;
    }
    wayPoints = figure
        .getPointsToMove()
        .where((element) => !_isFriendFigure(element))
        .toList();
    if (figure.canJump) {
      return wayPoints;
    }
    if (figure.runtimeType == King) {
      return wayPoints;
    }
    if (figure.runtimeType == Queen) {
      wayPoints = _getPossibilityPointsDiagonal(figure) + _getPossibilityPointsStraight(figure);
      return wayPoints;
    }
    if (figure.runtimeType == Bishop) {
      wayPoints = _getPossibilityPointsDiagonal(figure);
      return wayPoints;
    }
    if (figure.runtimeType == Castle) {
      wayPoints = _getPossibilityPointsStraight(figure);
      return wayPoints;
    }
    return wayPoints;
  }

  bool checkPossibilityToMove(Figure figure, SpaceName nameAimPoint) {
    List<SpaceName> wayPoints = getPossibilityPoints(figure);
    return wayPoints.contains(nameAimPoint);
  }

  void move(Figure figure, SpaceName aimPoint) {
    gameBoard[figure.currentPosition] = null;
    if (gameBoard[aimPoint] != null) {
      gameBoard[aimPoint]!.toDeath();
    }
    figure.gambit(aimPoint);
    gameBoard[figure.currentPosition] = figure;
    _switchActivePlayer();
  }
}
