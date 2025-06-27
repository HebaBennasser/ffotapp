
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/animated_star_field.dart';
import '../widgets/glass_card_container.dart';
import '../widgets/circular_chart.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, String?> answers;
  final double calculatedFootprint;
  
  const ResultsScreen({
    super.key,
    required this.answers,
    required this.calculatedFootprint,
  });

  Map<String, double> _calculateCategoryBreakdown() {
    final breakdown = <String, double>{};
    
    switch (answers['q1']) {
      case 'أبداً (نباتي صرف)':
        breakdown['النظام الغذائي'] = 1.5;
        break;
      case 'نادراً (نباتي)':
        breakdown['النظام الغذائي'] = 2.5;
        break;
      case 'بضع مرات في الأسبوع':
        breakdown['النظام الغذائي'] = 4.0;
        break;
      case 'يومياً':
        breakdown['النظام الغذائي'] = 6.0;
        break;
      case 'عدة مرات يومياً':
        breakdown['النظام الغذائي'] = 8.0;
        break;
      default:
        breakdown['النظام الغذائي'] = 4.0;
    }

    switch (answers['q2']) {
      case 'المشي أو ركوب الدراجة':
        breakdown['المواصلات'] = 0.5;
        break;
      case 'المواصلات العامة':
        breakdown['المواصلات'] = 2.0;
        break;
      case 'مركبة كهربائية':
        breakdown['المواصلات'] = 3.0;
        break;
      case 'مركبة هجينة':
        breakdown['المواصلات'] = 4.5;
        break;
      case 'مركبة بنزين':
        breakdown['المواصلات'] = 7.0;
        break;
      default:
        breakdown['المواصلات'] = 3.5;
    }

    switch (answers['q3']) {
      case 'شخص واحد':
        breakdown['السكن'] = 3.0;
        break;
      case 'شخصان':
        breakdown['السكن'] = 2.5;
        break;
      case '3-4 أشخاص':
        breakdown['السكن'] = 2.0;
        break;
      case '5-6 أشخاص':
        breakdown['السكن'] = 1.8;
        break;
      case 'أكثر من 6 أشخاص':
        breakdown['السكن'] = 1.5;
        break;
      default:
        breakdown['السكن'] = 2.0;
    }

    switch (answers['q4']) {
      case 'نادراً (عند الحاجة فقط)':
        breakdown['التسوق'] = 0.5;
        break;
      case 'بضع مرات في السنة':
        breakdown['التسوق'] = 1.0;
        break;
      case 'شهرياً':
        breakdown['التسوق'] = 2.0;
        break;
      case 'كل بضعة أسابيع':
        breakdown['التسوق'] = 3.0;
        break;
      case 'أسبوعياً أو أكثر':
        breakdown['التسوق'] = 4.0;
        break;
      default:
        breakdown['التسوق'] = 1.5;
    }

    return breakdown;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final averageFootprint = 12.5;
    final percentile = ((1 - (calculatedFootprint / averageFootprint)) * 100)
        .clamp(0, 100)
        .round();
    final improvementPotential = (100 - percentile) / 100;
    final categoryBreakdown = _calculateCategoryBreakdown();
    
    String category;
    if (calculatedFootprint < 5) {
      category = "تأثير منخفض";
    } else if (calculatedFootprint < 10) {
      category = "تأثير متوسط";
    } else {
      category = "تأثير عالي";
    }

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedStarField(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.teal.withOpacity(0.1),
                  Colors.greenAccent.withOpacity(0.2),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: 20,
              top: MediaQuery.of(context).padding.top + 10,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: GlassCardContainer(
                      height: isSmallScreen ? screenHeight * 0.4 : screenHeight * 0.35,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.insights,
                              size: 36,
                              color: Colors.tealAccent,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'بصمتك الكربونية',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Flexible(
                              child: FittedBox(
                                child: Text(
                                  '$calculatedFootprint',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.tealAccent,
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              'طن CO₂ سنوياً',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.tealAccent,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(show: false),
                                    titlesData: FlTitlesData(show: false),
                                    borderData: FlBorderData(show: false),
                                    minX: 0,
                                    maxX: 11,
                                    minY: 0,
                                    maxY: 20,
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: [
                                          FlSpot(0, 5),
                                          FlSpot(2, 7),
                                          FlSpot(4, 6),
                                          FlSpot(6, calculatedFootprint),
                                          FlSpot(8, 9),
                                          FlSpot(10, 8),
                                        ],
                                        isCurved: true,
                                        color: Colors.tealAccent,
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.tealAccent.withOpacity(0.3),
                                              Colors.tealAccent.withOpacity(0.1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                      LineChartBarData(
                                        spots: [
                                          FlSpot(0, averageFootprint),
                                          FlSpot(10, averageFootprint),
                                        ],
                                        isCurved: false,
                                        color: Colors.white.withOpacity(0.5),
                                        barWidth: 1,
                                        dashArray: [5, 5],
                                        dotData: FlDotData(show: false),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'المعدل: $averageFootprint طن CO₂ سنوياً',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 170,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.42,
                            child: GlassCardContainer(
                              height: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircularChart(
                                  value: percentile / 100,
                                  label: 'النسبة المئوية',
                                  description: 'أفضل من $percentile%',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: screenWidth * 0.42,
                            child: GlassCardContainer(
                              height: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircularChart(
                                  value: improvementPotential,
                                  label: 'تحسين',
                                  description: 'إمكانية تحسين ${(improvementPotential * 100).round()}%',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GlassCardContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'التفصيل حسب الفئة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._buildCategoryRows(categoryBreakdown),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent.withOpacity(0.9),
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.tealAccent.withOpacity(0.5),
                      ),
                      child: const Text(
                        'عرض التوصيات',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryRows(Map<String, double> breakdown) {
    final colors = [
      Colors.tealAccent,
      Colors.lightGreenAccent,
      Colors.greenAccent,
      Colors.teal,
    ];
    int colorIndex = 0;
    
    return breakdown.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  '${entry.value} طن',
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: entry.value / 12.5,
              backgroundColor: Colors.white.withOpacity(0.1),
              color: color,
              minHeight: 3,
              borderRadius: BorderRadius.circular(1),
            ),
          ],
        ),
      );
    }).toList();
  }
}