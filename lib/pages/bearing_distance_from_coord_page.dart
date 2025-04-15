import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this line
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:math'; // For mathematical operations
import '../models/coordinate.dart'; // Import Coordinate from the correct location

class BearingDistanceFromCoordPage extends StatelessWidget {
  final List<Coordinate> coordinates;
  final String selectedUnit;

  BearingDistanceFromCoordPage({required this.coordinates, required this.selectedUnit});

  List<Map<String, dynamic>> _calculateSheetData() {
    List<Map<String, dynamic>> data = [];

    // Calculate bearings and distances for consecutive points
    for (int i = 0; i < coordinates.length - 1; i++) { // Stop at the second last point
      Coordinate from = coordinates[i];
      Coordinate to = coordinates[i + 1]; // Do not wrap around to the first coordinate

      double xDiff = to.x - from.x;
      double yDiff = to.y - from.y;

      double distance = _calculateDistance(xDiff, yDiff);
      double bearing = _calculateCorrectBearing(xDiff, yDiff);
      String bearingDMS = _decimalToDMS(bearing);

      data.add({
        'fromPoint': from.beacon,
        'toPoint': to.beacon,
        'xa': from.x.toStringAsFixed(2),
        'ya': from.y.toStringAsFixed(2),
        'xb': to.x.toStringAsFixed(2),
        'yb': to.y.toStringAsFixed(2),
        'xDiff': xDiff.toStringAsFixed(2),
        'yDiff': yDiff.toStringAsFixed(2),
        'bearing': bearingDMS,
        'distance': distance.toStringAsFixed(2),
      });
    }

    // Calculate bearing and distance from last but one row to second row
    if (coordinates.length >= 3) {
      Coordinate from = coordinates[coordinates.length - 2]; // Last but one row
      Coordinate to = coordinates[1]; // Second row

      double xDiff = to.x - from.x;
      double yDiff = to.y - from.y;

      double distance = _calculateDistance(xDiff, yDiff);
      double bearing = _calculateCorrectBearing(xDiff, yDiff);
      String bearingDMS = _decimalToDMS(bearing);

      data.add({
        'fromPoint': from.beacon,
        'toPoint': to.beacon,
        'xa': from.x.toStringAsFixed(2),
        'ya': from.y.toStringAsFixed(2),
        'xb': to.x.toStringAsFixed(2),
        'yb': to.y.toStringAsFixed(2),
        'xDiff': xDiff.toStringAsFixed(2),
        'yDiff': yDiff.toStringAsFixed(2),
        'bearing': bearingDMS,
        'distance': distance.toStringAsFixed(2),
      });
    }

    return data;
  }

  double _calculateDistance(double xDiff, double yDiff) {
    double distance = sqrt(pow(xDiff, 2) + pow(yDiff, 2)); // Euclidean distance
    if (selectedUnit == 'Feet') {
      distance *= 3.28084; // Convert meters to feet
    }
    return distance;
  }

  double _calculateCorrectBearing(double dX, double dY) {
    if (dX == 0 && dY > 0) {
      return 90;
    } else if (dX == 0 && dY < 0) {
      return 270;
    } else if (dX < 0 && dY == 0) {
      return 180;
    } else if (dX > 0 && dY > 0) {
      return atan(dY / dX) * (180 / pi);
    } else if (dX < 0 && dY > 0) {
      return atan(dY / dX) * (180 / pi) + 180;
    } else if (dX < 0 && dY < 0) {
      return atan(dY / dX) * (180 / pi) + 180;
    } else {
      return atan(dY / dX) * (180 / pi) + 360;
    }
  }

  String _decimalToDMS(double decimalDegree) {
    int degrees = decimalDegree.floor();
    double remaining = decimalDegree - degrees;
    int minutes = (remaining * 60).floor();
    double seconds = (remaining * 3600) % 60;

    // Format degrees to 3 digits (e.g., 001°)
    return '${degrees.toString().padLeft(3, '0')}° ${minutes.toString().padLeft(2, '0')}\' ${seconds.floor().toString().padLeft(2, '0')}"';
  }

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();

    try {
      // Load the custom fonts
      final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final boldFontData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

      final font = pw.Font.ttf(fontData);
      final boldFont = pw.Font.ttf(boldFontData);

      // Retrieve sheet data
      List<Map<String, dynamic>> sheetData = _calculateSheetData();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4, // Standard A4 page
          margin: pw.EdgeInsets.all(20), // Page margins
          build: (pw.Context context) {
            List<pw.Widget> pdfContent = [];

            // Add Title at the top of the first page only
            pdfContent.add(
              pw.Center(
                child: pw.Text(
                  'BEARING AND DISTANCE FROM COORDINATES',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: boldFont),
                ),
              ),
            );
            pdfContent.add(pw.SizedBox(height: 20));

            // Generate tables for each row
            for (var row in sheetData) {
              pdfContent.add(
                pw.Container(
                  padding: pw.EdgeInsets.symmetric(vertical: 10), // Add vertical padding
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Column with Added Padding
                      pw.Expanded(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.only(left: 8), // Left padding to move text away from the border
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("From Point ${row['fromPoint']} (A)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldFont)),
                              pw.SizedBox(height: 5),
                              pw.Text("Xa = ${row['xa']}", style: pw.TextStyle(font: font)),
                              pw.Text("Ya = ${row['ya']}", style: pw.TextStyle(font: font)),
                              pw.Text("ΔX = ${row['xDiff']}", style: pw.TextStyle(font: font)),
                              pw.Text("Actual Bearing = ${row['bearing']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldFont)),
                            ],
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 10),

                      // Right Column with Added Padding
                      pw.Expanded(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.only(left: 8), // Left padding for better spacing
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("To Point ${row['toPoint']} (B)", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldFont)),
                              pw.SizedBox(height: 5),
                              pw.Text("Xb = ${row['xb']}", style: pw.TextStyle(font: font)),
                              pw.Text("Yb = ${row['yb']}", style: pw.TextStyle(font: font)),
                              pw.Text("ΔY = ${row['yDiff']}", style: pw.TextStyle(font: font)),
                              pw.Text("DISTANCE = ${row['distance']} Feet", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldFont)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              pdfContent.add(pw.SizedBox(height: 10)); // Spacing between rows
            }

            return pdfContent; // Ensures full-page utilization before moving to the next
          },
        ),
      );
    } catch (e) {
      print('Error generating PDF: $e');
      throw Exception('Failed to generate PDF: $e');
    }

    return pdf;
  }

  void _printPage(BuildContext context) async {
    final pdf = await _generatePdf();
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sheetData = _calculateSheetData();

    // Determine if the app is in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Use grey[800] for dark mode and grey[200] for light mode as background colors
    final cellColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!; // Use non-nullable colors
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text("B&D From Coord"),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printPage(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Heading
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                "BEARING AND DISTANCE FROM COORDINATES",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Dynamic text color for light/dark mode
                ),
              ),
            ),
            // Sheet Content
            _buildSheet(sheetData, cellColor, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSheet(List<Map<String, dynamic>> sheetData, Color cellColor, Color textColor) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var row in sheetData)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 600, // Set a fixed width for the table
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Add border for the container
                  ),
                  child: Table(
                    // Remove the border from here
                    columnWidths: {
                      0: FlexColumnWidth(3),
                      1: FixedColumnWidth(20), // Width for the space column
                      2: FlexColumnWidth(3),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: cellColor),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("From Point ${row['fromPoint']} (A)", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                  SizedBox(height: 5),
                                  Text("Xa = ${row['xa']}", style: TextStyle(color: textColor)),
                                  SizedBox(height: 5),
                                  Text("Ya = ${row['ya']}", style: TextStyle(color: textColor)),
                                  SizedBox(height: 5),
                                  Text("ΔX = ${row['xDiff']}", style: TextStyle(color: textColor)),
                                  SizedBox(height: 5),
                                  Text("Actual Bearing = ${row['bearing']}", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: SizedBox.shrink(), // Empty space column
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("To Point ${row['toPoint']} (B)", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                  SizedBox(height: 5),
                                  Text("Xb = ${row['xb']}", style: TextStyle(color: textColor)),
                                  SizedBox(height: 5),
                                  Text("Yb = ${row['yb']}", style: TextStyle(color: textColor)),
                                  SizedBox(height: 5),
                                  Text("ΔY = ${row['yDiff']}", style: TextStyle(color: textColor)),
                                  SizedBox(height: 5),
                                  Text("DISTANCE = ${row['distance']} Feet", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add spacing between sections
              ],
            ),
        ],
      ),
    );
  }
}
