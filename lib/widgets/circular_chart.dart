
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CircularChart extends StatelessWidget {
  final double value;
  final String label;
  final String description;

  const CircularChart({
    super.key,
    required this.value,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80, 
            height: 80,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 25, 
                    sections: [
                      PieChartSectionData(
                        color: Colors.tealAccent,
                        value: value * 100,
                        showTitle: false,
                        radius: 12, 
                      ),
                      PieChartSectionData(
                        color: Colors.white.withOpacity(0.1),
                        value: (1 - value) * 100,
                        showTitle: false,
                        radius: 12,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    '${(value * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6), 
          Text(
            label,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 12, 
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10, 
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}