import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BeaconIndexPage extends StatelessWidget {
  final List<Map<String, dynamic>> coordinates;

  BeaconIndexPage({required this.coordinates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BEACON INDEX'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printBeaconIndex(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to ensure the table is not clipped
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Header with Underline
            Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2, color: Colors.black),
                  ),
                ),
                child: Text(
                  'BEACON INDEX',
                  style: TextStyle(
                    fontSize: 18, // Adjusted to match AreaComputationPage
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _buildTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(), // Add borders to the entire table
      columnWidths: const {
        0: FixedColumnWidth(150), // Beacon
        1: FixedColumnWidth(120),  // X
        2: FixedColumnWidth(120),  // Y
        3: FixedColumnWidth(120),  // Sheet No.
        4: FixedColumnWidth(120),  // No.
        5: FixedColumnWidth(120),  // Page
        6: FixedColumnWidth(120), // Remarks
      },
      children: [
        // Header Row
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]), // Adjusted to match AreaComputationPage
          children: const [
            TableCell(child: Center(child: SelectableText('Beacon', style: TextStyle(fontWeight: FontWeight.bold)))),
            TableCell(child: Center(child: SelectableText('Coordinates (X)', style: TextStyle(fontWeight: FontWeight.bold)))),
            TableCell(child: Center(child: SelectableText('Coordinates (Y)', style: TextStyle(fontWeight: FontWeight.bold)))),
            TableCell(child: Center(child: SelectableText('Computn. Sheet No.', style: TextStyle(fontWeight: FontWeight.bold)))),
            TableCell(child: Center(child: SelectableText('Record Book No.', style: TextStyle(fontWeight: FontWeight.bold)))),
            TableCell(child: Center(child: SelectableText('Record Book Page', style: TextStyle(fontWeight: FontWeight.bold)))),
            TableCell(child: Center(child: SelectableText('Remarks', style: TextStyle(fontWeight: FontWeight.bold)))),
          ],
        ),
        // Data Rows
        for (var coord in coordinates)
          TableRow(
            children: [
              TableCell(child: Center(child: SelectableText(coord['Beacon'] ?? ''))),
              TableCell(child: Center(child: SelectableText(coord['X'].toString()))),
              TableCell(child: Center(child: SelectableText(coord['Y'].toString()))),
              TableCell(child: Center(child: SelectableText(''))), // Placeholder for Sheet No.
              TableCell(child: Center(child: SelectableText(''))), // Placeholder for No.
              TableCell(child: Center(child: SelectableText(''))), // Placeholder for Page
              TableCell(child: Center(child: SelectableText(''))), // Placeholder for Remarks
            ],
          ),
      ],
    );
  }

  Future<void> _printBeaconIndex(BuildContext context) async {
    final pdf = pw.Document();

    // Add a page for the Beacon Index
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Main Header (No underline in the printed page)
              pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Text(
                  'BEACON INDEX',
                  style: pw.TextStyle(
                    fontSize: 18, // Adjusted to match AreaComputationPage
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // Table with Data and Borders
              pw.Table(
                border: pw.TableBorder.all(), // Add borders to the entire table
                columnWidths: {
                  0: pw.FixedColumnWidth(150), // Beacon
                  1: pw.FixedColumnWidth(120),  // X
                  2: pw.FixedColumnWidth(120),  // Y
                  3: pw.FixedColumnWidth(120),  // Sheet No.
                  4: pw.FixedColumnWidth(120),  // No.
                  5: pw.FixedColumnWidth(120),  // Page
                  6: pw.FixedColumnWidth(120), // Remarks
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey200), // Adjusted to match AreaComputationPage
                    children: [
                      pw.Center(child: pw.Text('Beacon', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('Coordinates (X)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('Coordinates (Y)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('Computn. Sheet No.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('Record Book No.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('Record Book Page', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Center(child: pw.Text('Remarks', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  // Data Rows
                  for (var coord in coordinates)
                    pw.TableRow(
                      children: [
                        pw.Center(child: pw.Text(coord['Beacon'] ?? '')),
                        pw.Center(child: pw.Text(coord['X'].toString())),
                        pw.Center(child: pw.Text(coord['Y'].toString())),
                        pw.Center(child: pw.Text('')), // Placeholder for Sheet No.
                        pw.Center(child: pw.Text('')), // Placeholder for No.
                        pw.Center(child: pw.Text('')), // Placeholder for Page
                        pw.Center(child: pw.Text('')), // Placeholder for Remarks
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