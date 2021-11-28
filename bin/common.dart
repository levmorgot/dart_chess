import 'constants.dart';
import 'dart:math';

List<SpaceName> pointsListToSpaceNamesList(List<Point> points) {
  return chessboard.keys
      .where((element) => points.contains(chessboard[element]))
      .toList();
}

SpaceName? stringToSpaceName(String stringPoint) {
  try {
    SpaceName point = SpaceName.values.firstWhere((element) =>
        element.toString().split('.')[1] == stringPoint.toLowerCase());
    return point;
  } catch (_) {
    print('Некорректный адрес клетки');
    return null;
  }
}

SpaceName pointToSpaceName(Point point) {
  try {
    return chessboard.keys
        .firstWhere((element) => chessboard[element] == point);
  } catch (_) {
    throw Exception('Такой клетки на поле не существует');
  }
}

Point spaceNameToPoint(SpaceName spaceName) {
  try {
    return chessboard.values
        .firstWhere((element) => chessboard[spaceName] == element);
  } catch (_) {
    throw Exception('Такой клетки на поле не существует');
  }
}

String setTextColorYellow(String text) {
  return '\x1B[33m$text\x1B[0m';
}

String setTextColorRed(String text) {
  return '\x1B[31m$text\x1B[0m';
}

String setTextColorBlue(String text) {
  return '\x1B[34m$text\x1B[0m';
}

String setTextColorGreen(String text) {
  return '\x1B[32m$text\x1B[0m';
}

String setTextColorMagenta(String text) {
  return '\x1B[35m$text\x1B[0m';
}
