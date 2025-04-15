import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/coordinate.dart';

Future<void> generatePdf(String outputPath, List<Coordinate> coordinates) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('ITA Computations', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Beacon', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('X-Coordinate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Y-Coordinate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                ...coordinates.map(
                  (coord) => pw.TableRow(
                    children: [
                      pw.Text(coord.beacon.toString()),
                      pw.Text(coord.x.toStringAsFixed(2)),
                      pw.Text(coord.y.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  final file = File(outputPath);
  await file.writeAsBytes(await pdf.save());
}
