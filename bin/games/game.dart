import 'dart:math';

import '../common/utils.dart';
import '../common/constants.dart';
import '../figures/figure.dart';
import '../player.dart';

abstract class Game {
  Map<SpaceName, Figure> gameBoard = {};
  late Player player1;
  late Player player2;
  late Player activePlayer;
  Figure activeFigure = NullFigure();

  Game(this.player1, this.player2);

  void _switchActivePlayer() {
    activePlayer = activePlayer == player1 ? player2 : player1;
  }

  void nextStep(){
    _switchActivePlayer();
  }

  Player _chooseActivePlayer() {
    return player1.color == Color.white ? player1 : player2;
  }

  Figure chooseFigure(SpaceName point) {
    try {
      Figure figure = gameBoard[point]!;
      if (_isFriendFigure(point)) {
        return figure;
      } else if (_isEnemyFigure(point)) {
        print('Вы не можете играть фигурами другого игрока');
      } else {
        print('Эта клетка пуста');
      }
      return NullFigure();
    } catch (_) {
      throw Exception('На поле оказался null вместо NullFigure');
    }
  }

  Figure _getFigure(SpaceName point) {
    try {
      return gameBoard[point]!;
    } catch (_) {
      throw Exception('На поле оказался null вместо NullFigure');
    }
  }

  bool _isFriendFigure(SpaceName point) {
    return activePlayer.figures.contains(gameBoard[point]);
  }

  bool _isEmptyPoint(SpaceName point) {
    return gameBoard[point] == NullFigure();
  }

  bool _isEnemyFigure(SpaceName point) {
    return !_isEmptyPoint(point) &&
        !_isFriendFigure(point);
  }

  List<SpaceName> getPossibilityPoints(Figure figure);

  bool checkPossibilityToMove(Figure figure, SpaceName nameAimPoint) {
    List<SpaceName> wayPoints = getPossibilityPoints(figure);
    return wayPoints.contains(nameAimPoint);
  }

  void move(Figure figure, SpaceName aimPoint);

  void printBoardColor() {
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
    Figure nullFigure = NullFigure();
    List<SpaceName> possibilityPoints =
        activeFigure != nullFigure ? getPossibilityPoints(activeFigure) : [];
    for (int x = chessboardSizeX - 1; x >= 0; x--) {
      List<String> lineFigures = [];
      for (int y = 0; y < chessboardSizeX; y++) {
        var point = SpaceName.values[y * 8 + x];
        var valuePoint = gameBoard[point];
        var type = valuePoint.runtimeType;
        if (activeFigure != nullFigure) {
          if (type != NullFigure) {
            if (possibilityPoints.contains(point)) {
              lineFigures.add(setTextColorMagenta(type.toString()[0]));
            } else if (activeFigure.currentPosition == point) {
              lineFigures.add(setTextColorYellow(type.toString()[0]));
            } else {
              lineFigures.add(_isFriendFigure(point)
                  ? setTextColorGreen(type.toString()[0])
                  : setTextColorRed(type.toString()[0]));
            }
          } else {
            if (possibilityPoints.contains(point)) {
              lineFigures.add(setTextColorBlue('-'));
            } else {
              lineFigures.add('-');
            }
          }
        } else {
          if (type != NullFigure) {
            lineFigures.add(_isFriendFigure(point)
                ? setTextColorGreen(type.toString()[0])
                : setTextColorRed(type.toString()[0]));
          } else {
            lineFigures.add('-');
          }
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
}

class ChessGame extends Game {
  bool _isCheck = false;
  Player? _playerWithCheck;
  List<Figure> _attackingFigures = [];
  List<Figure> _closedAttackingFigures = [];
  Map<Figure, Figure> _coveringFigures = {};

  ChessGame(player1, player2) : super(player1, player2) {
    activePlayer = _chooseActivePlayer();

    chessboard.forEach((k, v) {
      gameBoard[k] = player1.getFigureByPosition(k);
      if (gameBoard[k] == NullFigure()) {
        gameBoard[k] = player2.getFigureByPosition(k);
      }
    });
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

  Figure _getEnemyOnStraightWayToPoint(Figure figure, SpaceName pointName) {
    final Point currentPoint = spaceNameToPoint(figure.currentPosition);
    final Point point = spaceNameToPoint(pointName);
    List<SpaceName> pointsForAttack = getPossibilityPoints(figure);

    for (var element in pointsForAttack) {
      Point attackPoint = spaceNameToPoint(element);
      bool isNeededWay = false;
      if (point.x == currentPoint.x && point.y < currentPoint.y) {
        isNeededWay =
            attackPoint.x == currentPoint.x && attackPoint.y < currentPoint.y;
      } else if (point.x == currentPoint.x && point.y > currentPoint.y) {
        isNeededWay =
            attackPoint.x == currentPoint.x && attackPoint.y > currentPoint.y;
      } else if (point.x > currentPoint.x && point.y == currentPoint.y) {
        isNeededWay =
            attackPoint.x > currentPoint.x && attackPoint.y == currentPoint.y;
      } else if (point.x < currentPoint.x && point.y == currentPoint.y) {
        isNeededWay =
            attackPoint.x < currentPoint.x && attackPoint.y == currentPoint.y;
      }

      if (isNeededWay && _isEnemyFigure(element)) {
        return _getFigure(element);
      }
    }
    return NullFigure();
  }

  Figure _getEnemyOnDiagonalWayToPoint(Figure figure, SpaceName pointName) {
    final Point currentPoint = spaceNameToPoint(figure.currentPosition);
    final Point point = spaceNameToPoint(pointName);
    List<SpaceName> pointsForAttack = getPossibilityPoints(figure);

    for (var element in pointsForAttack) {
      Point attackPoint = spaceNameToPoint(element);
      bool isNeededWay = false;
      if (point.x < currentPoint.x && point.y < currentPoint.y) {
        isNeededWay =
            attackPoint.x < currentPoint.x && attackPoint.y < currentPoint.y;
      } else if (point.x < currentPoint.x && point.y > currentPoint.y) {
        isNeededWay =
            attackPoint.x < currentPoint.x && attackPoint.y > currentPoint.y;
      } else if (point.x > currentPoint.x && point.y < currentPoint.y) {
        isNeededWay =
            attackPoint.x > currentPoint.x && attackPoint.y < currentPoint.y;
      } else if (point.x > currentPoint.x && point.y > currentPoint.y) {
        isNeededWay =
            attackPoint.x > currentPoint.x && attackPoint.y > currentPoint.y;
      }

      if (isNeededWay && _isEnemyFigure(element)) {
        return _getFigure(element);
      }
    }
    return NullFigure();
  }

  List<SpaceName> _getPossibilityPointsDiagonal(Figure figure) {
    List<SpaceName> names = figure.getPointsToMove();
    final Point currentPoint = spaceNameToPoint(figure.currentPosition);
    if (figure.moveToDiagonal && figure.moveToStraight) {
      names = names
          .where((element) =>
              spaceNameToPoint(element).x != currentPoint.x &&
              spaceNameToPoint(element).y != currentPoint.y)
          .toList();
    }
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
    if (figure.moveToDiagonal && figure.moveToStraight) {
      names = names
          .where((element) =>
              spaceNameToPoint(element).x == currentPoint.x ||
              spaceNameToPoint(element).y == currentPoint.y)
          .toList();
    }
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

  @override
  List<SpaceName> getPossibilityPoints(Figure figure) {
    List<SpaceName> wayPoints = [];
    if (_isCheck && _playerWithCheck == activePlayer) {
      wayPoints = [];
    }
    if (figure.runtimeType == Pawn) {
      wayPoints = figure
          .getPointsToMove()
          .where((element) => gameBoard[element] == null)
          .toList();
      wayPoints += figure
          .getPointsToAttack()
          .where((element) => _isEnemyFigure(element))
          .toList();
    } else if (figure.canJump || figure.moveAround) {
      wayPoints = figure
          .getPointsToMove()
          .where((element) => !_isFriendFigure(element))
          .toList();
    } else if (figure.moveToDiagonal && figure.moveToStraight) {
      wayPoints = _getPossibilityPointsDiagonal(figure) +
          _getPossibilityPointsStraight(figure);
    } else if (figure.moveToDiagonal) {
      wayPoints = _getPossibilityPointsDiagonal(figure);
    } else if (figure.moveToStraight) {
      wayPoints = _getPossibilityPointsStraight(figure);
    }
    if (_coveringFigures.containsKey(figure)) {
      if (wayPoints.contains(_coveringFigures[figure]!.currentPosition)) {
        wayPoints = [_coveringFigures[figure]!.currentPosition];
      } else {
        wayPoints = [];
      }
    }
    return wayPoints;
  }

  void _checkCheck() {
    Figure king = activePlayer.figures.firstWhere((element) => element.isKing);
    Player enemyPlayer = activePlayer == player1 ? player2 : player1;
    _switchActivePlayer();
    List<Figure> enemyFigures =
        enemyPlayer.figures.where((element) => !element.deathStatus).toList();

    for (var figure in enemyFigures) {
      if (getPossibilityPoints(figure).contains(king.currentPosition)) {
        _attackingFigures.add(figure);
      } else if (figure.getPointsToAttack().contains(king.currentPosition)) {
        if (figure.moveToDiagonal) {
          var enemyOnDiagonalWay =
              _getEnemyOnDiagonalWayToPoint(figure, king.currentPosition);
          if (enemyOnDiagonalWay != NullFigure()) {
            _coveringFigures[enemyOnDiagonalWay] = figure;
          }
        }
        if (figure.moveToStraight) {
          var enemyOnStraightWay =
              _getEnemyOnStraightWayToPoint(figure, king.currentPosition);
          if (enemyOnStraightWay != NullFigure()) {
            _coveringFigures[enemyOnStraightWay] = figure;
          }
        }
        if (_coveringFigures.isNotEmpty) {
          _closedAttackingFigures.add(figure);
        }
      }
    }
    _switchActivePlayer();
    _isCheck = _attackingFigures.isNotEmpty;
    if (_isCheck) {
      _playerWithCheck = activePlayer;
    } else {
      _playerWithCheck = null;
    }
  }

  bool checkCheckmate() {
    _checkCheck();
    if (_isCheck) {
      print(_isCheck);
      Figure king =
          activePlayer.figures.firstWhere((element) => element.isKing);
      if (_attackingFigures.length > 1 && getPossibilityPoints(king).isEmpty) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  @override
  void nextStep(){
    _switchActivePlayer();
    checkCheckmate();
  }

  @override
  void move(Figure figure, SpaceName aimPoint) {
    Figure nullFigure = NullFigure();
    _isCheck = false;
    _playerWithCheck = null;
    _attackingFigures.clear();
    _closedAttackingFigures.clear();
    _coveringFigures.clear();
    gameBoard[figure.currentPosition] = nullFigure;
    if (gameBoard[aimPoint] != nullFigure) {
      gameBoard[aimPoint]!.toDeath();
    }
    figure.gambit(aimPoint);
    gameBoard[figure.currentPosition] = figure;
    activeFigure = nullFigure;
    nextStep();
  }
}
