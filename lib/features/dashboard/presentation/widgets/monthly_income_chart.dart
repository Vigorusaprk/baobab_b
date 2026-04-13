import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyIncomeChart extends StatelessWidget {
  final List<double> monthlyData;
  final Color lineColor;
  final Gradient? gradientColor;

  const MonthlyIncomeChart({
    super.key,
    required this.monthlyData,
    this.lineColor = Colors.green,
    this.gradientColor,
  });

  @override
  Widget build(BuildContext context) {
    // Vérification : s'assurer d'avoir 12 valeurs (un par mois)
    final data = monthlyData.length == 12 ? monthlyData : List.filled(12, 0.0);
    final spots = List.generate(12, (index) => FlSpot(index.toDouble(), data[index]));

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenus mensuels (€)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: lineColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: gradientColor ??
                            LinearGradient(
                              colors: [Colors.green.withOpacity(0.3), Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(months[value.toInt()], style: const TextStyle(fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}