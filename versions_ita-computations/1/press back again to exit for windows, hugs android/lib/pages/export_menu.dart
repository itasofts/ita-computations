// lib/pages/export_menu.dart
import 'package:flutter/material.dart';

class ExportMenu extends StatefulWidget {
  @override
  _ExportMenuState createState() => _ExportMenuState();
}

class _ExportMenuState extends State<ExportMenu> {
  Map<String, bool> pages = {
    'Enter Coordinates Page': false,
    'Area Computation Page': false,
    'Bearing and Distance Page': false,
    'Beacon Index Page': false,
    'Plan Data Page': false,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Pages to Export"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: pages.keys.map((key) {
          return CheckboxListTile(
            title: Text(key),
            value: pages[key],
            onChanged: (value) {
              setState(() {
                pages[key] = value!;
              });
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _exportToPdf,
          child: Text("Export to PDF"),
        ),
      ],
    );
  }

  void _exportToPdf() {
    List<String> selectedPages = pages.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedPages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one page to export.")),
      );
      return;
    }

    // Call the PDF generation function
    _generatePdf(selectedPages);
    Navigator.pop(context);
  }

  void _generatePdf(List<String> selectedPages) {
    // Implement PDF generation logic here
    // Use the `pdf` package to create a PDF file
  }
}