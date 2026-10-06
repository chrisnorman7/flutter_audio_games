import 'dart:math';

/// Return an angle between 0 and 359 degrees.
double normaliseAngle(double angle) {
  if (angle < 0) {
    return angle + 360;
  } else if (angle > 359) {
    return angle - 360;
  }
  return angle;
}

/// Convert an [angle] to radians.
///
/// Formula taken from
/// [this link](https://synthizer.github.io/tutorials/python.html).
double angleToRad(double angle) => angle * pi / 180.0;

/// Convert [radians] to degrees.
///
/// Function provided by Chat GPT.
double radsToDegrees(double radians) => radians * (180 / pi);
