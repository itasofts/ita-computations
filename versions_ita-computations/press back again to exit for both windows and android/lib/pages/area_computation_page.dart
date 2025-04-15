import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/coordinate.dart'; // Import the Coordinate model

class AreaComputationPage extends StatelessWidget {
  final List<Coordinate> coordinates;
  final String selectedUnit;

  // Move these variables to the class level
  late List<Coordinate> filteredCoordinates;
  late double areaSqFt;
  late Map<String, double> areaConversions;

  AreaComputationPage({required this.coordinates, required this.selectedUnit}) {
    // Initialize filteredCoordinates, areaSqFt, and areaConversions in the constructor
    if (coordinates.length > 2) {
      filteredCoordinates = coordinates.sublist(1, coordinates.length - 1); // Exclude the first and last coordinates
    } else {
      filteredCoordinates = [];
    }

    if (filteredCoordinates.isNotEmpty) {
      areaSqFt = _calculateArea(filteredCoordinates);
      areaConversions = _convertArea(areaSqFt);
    }
  }

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

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();

    // Create a list of widgets to add to the PDF
    final List<pw.Widget> pdfWidgets = [];

    // Add the main heading
    pdfWidgets.add(
      pw.Text(
        'AREA COMPUTATION',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
    );
    pdfWidgets.add(pw.SizedBox(height: 20));

    // Add the table
    pdfWidgets.add(
      pw.Table(
        border: pw.TableBorder.all(),
        children: [
          // Table header
          pw.TableRow(
            decoration: pw.BoxDecoration(color: PdfColors.grey200),
            children: [
              pw.Center(child: pw.Text('BEACON')),
              pw.Center(child: pw.Text('X-Coordinates')),
              pw.Center(child: pw.Text('Y-Coordinates')),
              pw.Center(child: pw.Text('Y(I)*(X(I+1)-X(I))')),
              pw.Center(child: pw.Text('X(I)*(Y(I+1)-Y(I))')),
            ],
          ),
          // Table rows
          for (int i = 0; i < filteredCoordinates.length; i++)
            pw.TableRow(
              children: [
                pw.Center(child: pw.Text(filteredCoordinates[i].beacon)),
                pw.Center(child: pw.Text(filteredCoordinates[i].x.toStringAsFixed(2))),
                pw.Center(child: pw.Text(filteredCoordinates[i].y.toStringAsFixed(2))),
                pw.Center(
                  child: pw.Text(
                    (filteredCoordinates[i].y * (filteredCoordinates[(i + 1) % filteredCoordinates.length].x - filteredCoordinates[i].x)).toStringAsFixed(2),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    (filteredCoordinates[i].x * (filteredCoordinates[(i + 1) % filteredCoordinates.length].y - filteredCoordinates[i].y)).toStringAsFixed(2),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
    pdfWidgets.add(pw.SizedBox(height: 20));

    // Add the area computation results
    pdfWidgets.add(
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DOUBLE AREA = ${(areaSqFt * 2).toStringAsFixed(2)} Sq.ft',
            style: pw.TextStyle(fontSize: 16),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'AREA = ${areaConversions['Acres']!.toStringAsFixed(3)} Acres',
            style: pw.TextStyle(fontSize: 16),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'AREA = ${areaConversions['Ha']!.toStringAsFixed(3)} Ha',
            style: pw.TextStyle(fontSize: 16),
          ),
        ],
      ),
    );

    // Add the widgets to the PDF, splitting into multiple pages if necessary
    final double pageHeight = PdfPageFormat.a4.height; // A4 page height
    double currentHeight = 0;

    List<pw.Widget> currentPageWidgets = [];

    for (final widget in pdfWidgets) {
      // Estimate the height of the widget
      final widgetHeight = _estimateWidgetHeight(widget);

      // If adding the widget exceeds the page height, start a new page
      if (currentHeight + widgetHeight > pageHeight) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(children: currentPageWidgets);
            },
          ),
        );

        // Reset for the new page
        currentPageWidgets = [];
        currentHeight = 0;
      }

      // Add the widget to the current page
      currentPageWidgets.add(widget);
      currentHeight += widgetHeight;
    }

    // Add the remaining widgets to the last page
    if (currentPageWidgets.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(children: currentPageWidgets);
          },
        ),
      );
    }

    return pdf;
  }

  // Helper function to estimate the height of a widget
  double _estimateWidgetHeight(pw.Widget widget) {
    if (widget is pw.Text) {
      // Estimate text height based on font size and line count
      return 16 * 1.2; // Assume 16 font size and 1.2 line height multiplier
    } else if (widget is pw.Table) {
      // Estimate table height based on row count
      return widget.children.length * 20; // Assume 20 units per row
    } else if (widget is pw.SizedBox) {
      // Return the height of the SizedBox
      return widget.height ?? 0;
    } else if (widget is pw.Column) {
      // Estimate the height of a Column by summing its children's heights
      double height = 0;
      for (final child in widget.children) {
        height += _estimateWidgetHeight(child);
      }
      return height;
    }
    return 0; // Default height for unknown widgets
  }

  void _printPage(BuildContext context) async {
    final pdf = await _generatePdf();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (filteredCoordinates.isEmpty) {
      // If there are not enough coordinates, show an error message
      return Scaffold(
        appBar: AppBar(
          title: Text('Area Computation'),
        ),
        body: Center(
          child: Text(
            'Not enough coordinates to compute area. At least 3 coordinates are required.',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Area Computation'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printPage(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main Heading
            Text(
              'AREA COMPUTATION',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Table for intermediate calculations
            Container(
              width: 800, // Set a fixed width for the table
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: [
                      TableCell(child: Center(child: SelectableText('BEACON'))),
                      TableCell(child: Center(child: SelectableText('X-Coordinates'))),
                      TableCell(child: Center(child: SelectableText('Y-Coordinates'))),
                      TableCell(child: Center(child: SelectableText('Y(I)*(X(I+1)-X(I))'))),
                      TableCell(child: Center(child: SelectableText('X(I)*(Y(I+1)-Y(I))'))),
                    ],
                  ),
                  for (int i = 0; i < filteredCoordinates.length; i++)
                    TableRow(
                      children: [
                        TableCell(child: Center(child: SelectableText(filteredCoordinates[i].beacon))),
                        TableCell(child: Center(child: SelectableText(filteredCoordinates[i].x.toStringAsFixed(2)))),
                        TableCell(child: Center(child: SelectableText(filteredCoordinates[i].y.toStringAsFixed(2)))),
                        TableCell(
                          child: Center(
                            child: SelectableText(
                              (filteredCoordinates[i].y * (filteredCoordinates[(i + 1) % filteredCoordinates.length].x - filteredCoordinates[i].x)).toStringAsFixed(2),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: SelectableText(
                              (filteredCoordinates[i].x * (filteredCoordinates[(i + 1) % filteredCoordinates.length].y - filteredCoordinates[i].y)).toStringAsFixed(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Display the final area (centered and without a heading)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'DOUBLE AREA = ${(areaSqFt * 2).toStringAsFixed(2)} Sq.ft',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'AREA = ${areaConversions['Acres']!.toStringAsFixed(3)} Acres',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'AREA = ${areaConversions['Ha']!.toStringAsFixed(3)} Ha',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
