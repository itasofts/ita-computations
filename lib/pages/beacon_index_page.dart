import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BeaconIndexPage extends StatelessWidget {
  final List<Map<String, dynamic>> coordinates;

  BeaconIndexPage({required this.coordinates});

  @override
  Widget build(BuildContext context) {
    // Determine if the app is in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Heading (Centered and Styled)
            Center(
              child: Text(
                'BEACON INDEX',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Dynamic text color for light/dark mode
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _buildTable(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cellColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Table(
          border: TableBorder.all(),
          columnWidths: {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
            3: IntrinsicColumnWidth(),
            4: IntrinsicColumnWidth(),
            5: IntrinsicColumnWidth(),
            6: IntrinsicColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(color: cellColor),
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SelectableText(
                        'Beacon',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SelectableText(
                        'Coordinates (X)',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SelectableText(
                        'Coordinates (Y)',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SelectableText(
                        'Computn. Sheet No.',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SelectableText(
                        'Record Book No.',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SelectableText(
                        'Record Book Page',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SelectableText(
                        'Remarks',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Data Rows
            for (var coord in coordinates)
              TableRow(
                decoration: BoxDecoration(color: cellColor),
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SelectableText(
                          coord['Beacon'] ?? '',
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SelectableText(
                          coord['X'].toString(),
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SelectableText(
                          coord['Y'].toString(),
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SelectableText(
                          '',
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SelectableText(
                          '',
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SelectableText(
                          '',
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SelectableText(
                          '',
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
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
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),

              // Table with Data and Borders
              pw.Table(
                border: pw.TableBorder.all(), // Add borders to the entire table
                columnWidths: {
                  0: const pw.FixedColumnWidth(80),
                  1: const pw.FixedColumnWidth(80),
                  2: const pw.FixedColumnWidth(80),
                  3: const pw.FixedColumnWidth(80),
                  4: const pw.FixedColumnWidth(80),
                  5: const pw.FixedColumnWidth(80),
                  6: const pw.FixedColumnWidth(80),
                },
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey200),
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
