import 'dart:math';

class CoordinateComputation {
  // Function to compute bearings and distances
  static List<Map<String, dynamic>> computeBearingsAndDistances(List<Map<String, dynamic>> coordinates) {
    List<Map<String, dynamic>> results = [];

    for (int i = 0; i < coordinates.length - 1; i++) {
      var from = coordinates[i];
      var to = coordinates[i + 1];

      double deltaX = to['x'] - from['x'];
      double deltaY = to['y'] - from['y'];

      double distance = sqrt(deltaX * deltaX + deltaY * deltaY);
      double bearing = atan2(deltaX, deltaY) * (180 / pi);

      if (bearing < 0) {
        bearing += 360;
      }

      results.add({
        'from': from['beacon'],
        'to': to['beacon'],
        'x_diff': deltaX.toStringAsFixed(3),
        'y_diff': deltaY.toStringAsFixed(3),
        'bearing_dms': decimalToDMS(bearing),
        'distance': distance.toStringAsFixed(3),
      });
    }

    return results;
  }

  // Function to convert decimal degrees to DMS (Degrees, Minutes, Seconds)
  static String decimalToDMS(double decimalDegrees) {
    int degrees = decimalDegrees.floor();
    double minutesDecimal = (decimalDegrees - degrees) * 60;
    int minutes = minutesDecimal.floor();
    double seconds = (minutesDecimal - minutes) * 60;

    return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }
}
