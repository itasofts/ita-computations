import 'package:flutter/material.dart';

class ExportMenu extends StatefulWidget {
  final Function(List<String>) onExport; // Callback function

  ExportMenu({required this.onExport});

  @override
  _ExportMenuState createState() => _ExportMenuState();
}

class _ExportMenuState extends State<ExportMenu> {
  List<String> selectedSheets = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Pages to Export"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: Text("Area Computation"),
            value: selectedSheets.contains("Area Computation"),
            onChanged: (bool? value) {
              setState(() {
                _toggleSelection("Area Computation", value);
              });
            },
          ),
          CheckboxListTile(
            title: Text("Bearing and Distance"),
            value: selectedSheets.contains("Bearing and Distance"),
            onChanged: (bool? value) {
              setState(() {
                _toggleSelection("Bearing and Distance", value);
              });
            },
          ),
          CheckboxListTile(
            title: Text("Beacon Index"),
            value: selectedSheets.contains("Beacon Index"),
            onChanged: (bool? value) {
              setState(() {
                _toggleSelection("Beacon Index", value);
              });
            },
          ),
          CheckboxListTile(
            title: Text("Plan Data"),
            value: selectedSheets.contains("Plan Data"),
            onChanged: (bool? value) {
              setState(() {
                _toggleSelection("Plan Data", value);
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onExport(selectedSheets); // Call the callback function
            Navigator.of(context).pop();
          },
          child: Text("Export"),
        ),
      ],
    );
  }

  void _toggleSelection(String sheetName, bool? value) {
    if (value == true) {
      selectedSheets.add(sheetName);
    } else {
      selectedSheets.remove(sheetName);
    }
  }
}
