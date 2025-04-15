// lib/utils/unit_converter.dart
class UnitConverter {
  // Convert meters to feet
  static double metersToFeet(double meters) {
    return meters * 3.28084;
  }

  // Convert feet to meters
  static double feetToMeters(double feet) {
    return feet / 3.28084;
  }

  // Convert square meters to acres
  static double squareMetersToAcres(double squareMeters) {
    return squareMeters / 4046.85642;
  }

  // Convert square meters to hectares
  static double squareMetersToHectares(double squareMeters) {
    return squareMeters / 10000;
  }

  // Convert acres to square meters
  static double acresToSquareMeters(double acres) {
    return acres * 4046.85642;
  }

  // Convert hectares to square meters
  static double hectaresToSquareMeters(double hectares) {
    return hectares * 10000;
  }
}