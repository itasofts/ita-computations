import 'package:flutter/material.dart';
import 'package:printing/printing.dart'; // For printing functionality
import 'package:pdf/pdf.dart'; // For PDF generation
import 'package:pdf/widgets.dart' as pw; // For PDF widgets
import 'dart:math'; // For math functions like atan2, pi, sqrt
import '../models/coordinate.dart'; // Import the Coordinate model

class PlanDataPage extends StatelessWidget {
  final List<Coordinate> coordinates;
  final String selectedUnit;

  PlanDataPage({required this.coordinates, required this.selectedUnit});

  // Calculate area using the Shoelace Formula
  double _calculateArea(List<Coordinate> coordinates) {
    double sum1 = 0, sum2 = 0;
    for (int i = 0; i < coordinates.length; i++) {
      Coordinate current = coordinates[i];
      Coordinate next = coordinates[(i + 1) % coordinates.length]; // Wrap around to the first coordinate
      sum1 += current.y * next.x;
      sum2 += current.x * next.y;
    }
    return (sum1 - sum2).abs() / 2; // Absolute value of the difference divided by 2
  }

  // Convert area to different units
  Map<String, double> _convertArea(double areaSqFt) {
    return {
      'Sq.ft': areaSqFt,
      'Acres': areaSqFt / 43560,
      'Ha': areaSqFt / 107639,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Exclude the first and last rows for area calculation
    List<Coordinate> filteredCoordinates = [];
    if (coordinates.length > 2) {
      filteredCoordinates = coordinates.sublist(1, coordinates.length - 1);
    } else {
      // If there are not enough coordinates, show an error message
      return Scaffold(
        appBar: AppBar(
          title: Text('PLAN DATA'),
        ),
        body: Center(
          child: Text(
            'Not enough coordinates to compute area. At least 3 coordinates are required.',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    // Calculate the area
    double areaSqFt = _calculateArea(filteredCoordinates);
    Map<String, double> areaConversions = _convertArea(areaSqFt);

    return Scaffold(
      appBar: AppBar(
        title: Text('PLAN DATA'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printPlanData(context, coordinates, areaConversions),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main Heading
            Center(
              child: Text(
                'PLAN DATA',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Table for Plan Data
            Container(
              width: 800, // Set a fixed width for the table
              child: Table(
                border: TableBorder.all(),
                children: [
                  // Table Header
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: [
                      TableCell(child: Center(child: SelectableText('FROM POINT', style: TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(child: Center(child: SelectableText('TO POINT', style: TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(child: Center(child: SelectableText('BEARING (DM)', style: TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(child: Center(child: SelectableText('DISTANCE', style: TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(child: Center(child: SelectableText('REMARKS', style: TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  // Table Rows (exclude the last row connecting back to the first point)
                  for (int i = 0; i < coordinates.length - 1; i++)
                    TableRow(
                      children: [
                        TableCell(child: Center(child: SelectableText(coordinates[i].beacon))),
                        TableCell(child: Center(child: SelectableText(coordinates[i + 1].beacon))),
                        TableCell(child: Center(child: SelectableText(_calculateBearingDM(coordinates[i], coordinates[i + 1])))),
                        TableCell(child: Center(child: SelectableText(_calculateDistance(coordinates[i], coordinates[i + 1]).toStringAsFixed(2)))),
                        TableCell(child: Center(child: SelectableText(''))), // Remarks (empty for now)
                      ],
                    ),
                  // Add bearing and distance between last but one row and second row
                  if (coordinates.length >= 3)
                    TableRow(
                      children: [
                        TableCell(child: Center(child: SelectableText(coordinates[coordinates.length - 2].beacon))),
                        TableCell(child: Center(child: SelectableText(coordinates[1].beacon))),
                        TableCell(child: Center(child: SelectableText(_calculateBearingDM(coordinates[coordinates.length - 2], coordinates[1])))),
                        TableCell(child: Center(child: SelectableText(_calculateDistance(coordinates[coordinates.length - 2], coordinates[1]).toStringAsFixed(2)))),
                        TableCell(child: Center(child: SelectableText(''))), // Remarks (empty for now)
                      ],
                    ),
                  // Add area calculation in the Remarks column after the last row
                  TableRow(
                    children: [
                      TableCell(child: Center(child: SelectableText(''))),
                      TableCell(child: Center(child: SelectableText(''))),
                      TableCell(child: Center(child: SelectableText(''))),
                      TableCell(child: Center(child: SelectableText(''))),
                      TableCell(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SelectableText(
                                'AREA = ${areaConversions['Acres']!.toStringAsFixed(3)} ACRES',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Reduced font size
                              ),
                              SizedBox(height: 5),
                              SelectableText(
                                'AREA = ${areaConversions['Ha']!.toStringAsFixed(3)} HA',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Reduced font size
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Calculate bearing between two points (in Degrees and Minutes)
  String _calculateBearingDM(Coordinate from, Coordinate to) {
    double deltaX = to.x - from.x;
    double deltaY = to.y - from.y;
    double angle = (atan2(deltaY, deltaX) * 180 / pi + 360) % 360; // Convert to degrees

    // Convert degrees to DM (Degrees and Minutes)
    int degrees = angle.floor();
    double remaining = angle - degrees;
    int minutes = (remaining * 60).floor();

    // Format degrees to 3 digits (e.g., 001°)
    return '${degrees.toString().padLeft(3, '0')}° ${minutes.toString().padLeft(2, '0')}\''; 
  }

  // Calculate distance between two points
  double _calculateDistance(Coordinate from, Coordinate to) {
    double deltaX = to.x - from.x;
    double deltaY = to.y - from.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
  }

  Future<void> _printPlanData(BuildContext context, List<Coordinate> coordinates, Map<String, double> areaConversions) async {
    final pdf = pw.Document();

    // Add a page for the Plan Data
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Main Header
              pw.Text('PLAN DATA', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              // Table for Plan Data
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(100), // FROM POINT
                  1: pw.FixedColumnWidth(100), // TO POINT
                  2: pw.FixedColumnWidth(100), // BEARING (DM)
                  3: pw.FixedColumnWidth(100), // DISTANCE
                  4: pw.FixedColumnWidth(100), // REMARKS
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Center(child: pw.Text('FROM POINT', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('TO POINT', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('BEARING (DM)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('DISTANCE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('REMARKS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  // Table Rows (exclude the last row connecting back to the first point)
                  for (int i = 0; i < coordinates.length - 1; i++)
                    pw.TableRow(
                      children: [
                        pw.Center(child: pw.Text(coordinates[i].beacon)),
                        pw.Center(child: pw.Text(coordinates[i + 1].beacon)),
                        pw.Center(child: pw.Text(_calculateBearingDM(coordinates[i], coordinates[i + 1]))),
                        pw.Center(child: pw.Text(_calculateDistance(coordinates[i], coordinates[i + 1]).toStringAsFixed(2))),
                        pw.Center(child: pw.Text('')), // Remarks (empty for now)
                      ],
                    ),
                  // Add bearing and distance between last but one row and second row
                  if (coordinates.length >= 3)
                    pw.TableRow(
                      children: [
                        pw.Center(child: pw.Text(coordinates[coordinates.length - 2].beacon)),
                        pw.Center(child: pw.Text(coordinates[1].beacon)),
                        pw.Center(child: pw.Text(_calculateBearingDM(coordinates[coordinates.length - 2], coordinates[1]))),
                        pw.Center(child: pw.Text(_calculateDistance(coordinates[coordinates.length - 2], coordinates[1]).toStringAsFixed(2))),
                        pw.Center(child: pw.Text('')), // Remarks (empty for now)
                      ],
                    ),
                  // Add area calculation in the Remarks column after the last row
                  pw.TableRow(
                    children: [
                      pw.Center(child: pw.Text('')),
                      pw.Center(child: pw.Text('')),
                      pw.Center(child: pw.Text('')),
                      pw.Center(child: pw.Text('')),
                      pw.Center(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'AREA = ${areaConversions['Acres']!.toStringAsFixed(3)} ACRES',
                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), // Reduced font size
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              'AREA = ${areaConversions['Ha']!.toStringAsFixed(3)} HA',
                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), // Reduced font size
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}