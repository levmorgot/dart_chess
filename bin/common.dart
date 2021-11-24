import 'constants.dart';
import 'dart:math';

List<SpaceName> getCleanSpaceName(List<Point> points) {
  return chessboard.keys
      .where((element) =>  points.contains(chessboard[element]))
      .toList();
}