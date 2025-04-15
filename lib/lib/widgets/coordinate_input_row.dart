// lib/widgets/coordinate_input_row.dart
import 'package:flutter/material.dart';

class CoordinateInputRow extends StatelessWidget {
  final TextEditingController xController;
  final TextEditingController yController;
  final TextEditingController beaconController;

  CoordinateInputRow({
    required this.xController,
    required this.yController,
    required this.beaconController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: xController,
            decoration: InputDecoration(labelText: "X"),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: yController,
            decoration: InputDecoration(labelText: "Y"),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: beaconController,
            decoration: InputDecoration(labelText: "Beacon"),
          ),
        ),
      ],
    );
  }
}