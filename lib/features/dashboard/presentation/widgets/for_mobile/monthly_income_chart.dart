import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyIncomeChart extends StatelessWidget {
  final List<dynamic> monthlyData;
  final Gradient? lineGradient;
  final Gradient? areaGradient;

  const MonthlyIncomeChart({
    super.key,
    required this.monthlyData,
    this.lineGradient,
    this.areaGradient,
  });

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final List<double> convertedData = monthlyData.map((e) => _toDouble(e)).toList();
    final List<double> filledData = List.generate(12, (index) => index < convertedData.length ? convertedData[index] : 0.0);
    final spots = List.generate(12, (index) => FlSpot(index.toDouble(), filledData[index]));

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenus mensuels (€)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 350,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: lineGradient ?? LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.primaryLight],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: areaGradient ?? LinearGradient(
                          colors: [AppColors.primaryLight.withOpacity(0.3), Colors.transparent],
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
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
                          final int index = value.toInt();
                          if (index < 0 || index >= 12) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 25, right: 15),
                            child: Text(months[index], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()} €', style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1, dashArray: [4, 4]),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y.toStringAsFixed(2)} €',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}