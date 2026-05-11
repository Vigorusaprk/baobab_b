import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ProductSalesData {
  final String productName;
  final double salesAmount;

  ProductSalesData({required this.productName, required this.salesAmount});
}

class SalesPieChart extends StatefulWidget {
  final List<ProductSalesData> data;
  final double totalSales;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool isTablet;

  const SalesPieChart({
    super.key,
    required this.data,
    required this.totalSales,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.isTablet = false,
  });

  @override
  State<SalesPieChart> createState() => _SalesPieChartState();
}

class _SalesPieChartState extends State<SalesPieChart> {
  int? _touchedIndex;
  late final NumberFormat _currencyFormat;

  @override
  void initState() {
    super.initState();
    _currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
  }

  @override
  Widget build(BuildContext context) {
    print('Données reçues : \\${widget.data}');
    print('Total des ventes : \\${widget.totalSales}');
    if (widget.isLoading) return _buildLoading();
    if (widget.errorMessage != null) return _buildError();
    if (widget.data.isEmpty || widget.totalSales == 0) return _buildEmpty();

    return Container(
      padding: EdgeInsets.all(widget.isTablet ? 20 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Répartition des ventes',
                style: TextStyle(
                  fontSize: widget.isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Total: ${_currencyFormat.format(widget.totalSales)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: widget.isTablet ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.touchedSection == null) {
                                _touchedIndex = null;
                                return;
                              }
                              _touchedIndex =
                                  response.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        sectionsSpace: 2,
                        centerSpaceRadius: widget.isTablet ? 50 : 40,
                        startDegreeOffset: 180,
                        sections: _buildSections(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _buildLegend(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    // Protection contre la division par zéro
    if (widget.totalSales == 0) return [];

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.pink,
    ];

    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percentage = (item.salesAmount / widget.totalSales) * 100;
      final isTouched = index == _touchedIndex;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: item.salesAmount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: isTouched ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 2)],
        ),
        badgeWidget: isTouched
            ? Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${item.salesAmount.toStringAsFixed(0)}€',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        )
            : null,
        badgePositionPercentageOffset: 0.8,
      );
    }).toList();
  }

  Widget _buildLegend() {
    if (widget.totalSales == 0) return const SizedBox.shrink();

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.pink,
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Empêche le scroll inutile
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final item = widget.data[index];
        final percentage = (item.salesAmount / widget.totalSales * 100).toStringAsFixed(1);
        final color = colors[index % colors.length];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () {
              setState(() {
                _touchedIndex = _touchedIndex == index ? null : index;
              });
            },
            child: Row(
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      fontWeight: _touchedIndex == index ? FontWeight.bold : FontWeight.normal,
                      fontSize: widget.isTablet ? 14 : 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontWeight: _touchedIndex == index ? FontWeight.bold : FontWeight.normal,
                    fontSize: widget.isTablet ? 14 : 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() => Container(
    height: widget.isTablet ? 300 : 250,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Center(child: CircularProgressIndicator()),
  );

  Widget _buildError() => Container(
    height: widget.isTablet ? 300 : 250,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(widget.errorMessage ?? 'Erreur', style: const TextStyle(color: Colors.red)),
          if (widget.onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: widget.onRetry, child: const Text('Réessayer')),
          ],
        ],
      ),
    ),
  );

  Widget _buildEmpty() => Container(
    height: widget.isTablet ? 300 : 250,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pie_chart_outline, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('Aucune donnée de vente', style: TextStyle(color: Colors.grey)),
        ],
      ),
    ),
  );
}