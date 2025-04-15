import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:math'; // Import the math library for mathematical functions
import '../models/coordinate.dart'; // Import the Coordinate model

class BearingDistancePage extends StatelessWidget {
  final List<Coordinate> coordinates;
  final String selectedUnit;

  BearingDistancePage({required this.coordinates, required this.selectedUnit});

  List<Map<String, dynamic>> _calculateTableData() {
    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < coordinates.length; i++) {
      Coordinate from = coordinates[i];
      Coordinate to = coordinates[(i + 1) % coordinates.length]; // Wrap around to first coordinate

      double xDiff = to.x - from.x;
      double yDiff = to.y - from.y;

      double distance = _calculateDistance(xDiff, yDiff);
      double bearing = _calculateCorrectBearing(xDiff, yDiff);
      String bearingDMS = _decimalToDMS(bearing);

      data.add({
        'from': from.beacon,
        'to': to.beacon,
        'xDiff': xDiff.toStringAsFixed(2),
        'yDiff': yDiff.toStringAsFixed(2),
        'bearing': bearingDMS,
        'distance': distance.toStringAsFixed(2),
      });
    }

    if (coordinates.length >= 3) {
      Coordinate from = coordinates[coordinates.length - 2];
      Coordinate to = coordinates[1];

      double xDiff = to.x - from.x;
      double yDiff = to.y - from.y;

      double distance = _calculateDistance(xDiff, yDiff);
      double bearing = _calculateCorrectBearing(xDiff, yDiff);
      String bearingDMS = _decimalToDMS(bearing);

      data.add({
        'from': from.beacon,
        'to': to.beacon,
        'xDiff': xDiff.toStringAsFixed(2),
        'yDiff': yDiff.toStringAsFixed(2),
        'bearing': bearingDMS,
        'distance': distance.toStringAsFixed(2),
      });
    }

    return data;
  }

  double _calculateDistance(double xDiff, double yDiff) {
    double distance = sqrt(pow(xDiff, 2) + pow(yDiff, 2));
    if (selectedUnit == 'Feet') {
      distance *= 3.28084;
    }
    return distance;
  }

  double _calculateCorrectBearing(double dX, double dY) {
    if (dX == 0 && dY > 0) return 90;
    if (dX == 0 && dY < 0) return 270;
    if (dX < 0 && dY == 0) return 180;
    if (dX > 0 && dY > 0) return atan(dY / dX) * (180 / pi);
    if (dX < 0 && dY > 0) return atan(dY / dX) * (180 / pi) + 180;
    if (dX < 0 && dY < 0) return atan(dY / dX) * (180 / pi) + 180;
    return atan(dY / dX) * (180 / pi) + 360;
  }

  String _decimalToDMS(double decimalDegree) {
    int degrees = decimalDegree.floor();
    double minutesDecimal = (decimalDegree - degrees) * 60;
    int minutes = minutesDecimal.floor();
    double seconds = (minutesDecimal - minutes) * 60;
    return '${degrees.toString().padLeft(3, '0')}° ${minutes.toString().padLeft(2, '0')}\' ${seconds.floor().toString().padLeft(2, '0')}"';
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tableData = _calculateTableData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Bearing and Distance"),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              final pdf = await _generatePdf();
              await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => pdf.save(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  "BEARING AND DISTANCE FROM COORDINATES",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: _buildTable(context, tableData),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Map<String, dynamic>> tableData) {
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).dividerColor,
      ),
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          children: [
            _buildHeaderCell(context, "FROM POINT"),
            _buildHeaderCell(context, "TO POINT"),
            _buildHeaderCell(context, "X-COORD DIFF"),
            _buildHeaderCell(context, "Y-COORD DIFF"),
            _buildHeaderCell(context, "BEARING (DMS)"),
            _buildHeaderCell(context, "DISTANCE (FEET)"),
          ],
        ),
        for (var row in tableData)
          TableRow(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            children: [
              _buildDataCell(context, row['from']),
              _buildDataCell(context, row['to']),
              _buildDataCell(context, row['xDiff']),
              _buildDataCell(context, row['yDiff']),
              _buildDataCell(context, row['bearing']),
              _buildDataCell(context, row['distance']),
            ],
          ),
      ],
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: SelectableText(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          showCursor: true,
        ),
      ),
    );
  }

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('BEARING AND DISTANCE FROM COORDINATES',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(),
              headers:
                  ["FROM POINT", "TO POINT", "X-COORD DIFF", "Y-COORD DIFF", "BEARING (DMS)", "DISTANCE (FEET)"],
              data:
                  _calculateTableData().map((row) {
                return [
                  row['from'],
                  row['to'],
                  row['xDiff'],
                  row['yDiff'],
                  row['bearing'],
                  row['distance']
                ];
              }).toList(),
            ),
          ],
        ),
      ),
    );
    return pdf;
  }
}
