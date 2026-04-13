class VariationData {
  final double percent;
  final bool isPositive;
  final String formatted;
  VariationData({required this.percent, required this.isPositive, required this.formatted});
}

VariationData computeVariation(num current, num previous) {
  if (previous == 0) {
    return VariationData(percent: 0, isPositive: false, formatted: '0%');
  }
  final percent = ((current - previous) / previous) * 100;
  final isPositive = percent >= 0;
  final absPercent = percent.abs();
  final formatted = '${isPositive ? '+' : '-'}${absPercent.toStringAsFixed(1)}%';
  return VariationData(percent: absPercent, isPositive: isPositive, formatted: formatted);
}