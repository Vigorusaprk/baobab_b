class VariationData {
  final double percent;
  final bool isPositive;
  final String formatted;

  VariationData({required this.percent, required this.isPositive, required this.formatted});
}

VariationData computeVariation(num current, num previous) {
  // Cas où il n'y a aucune valeur précédente
  if (previous == 0) {
    if (current == 0) {
      return VariationData(percent: 0, isPositive: false, formatted: '0%');
    } else {
      // Hausse de 100% (ou vous pouvez mettre '+∞%' mais +100% est plus propre)
      return VariationData(percent: 100, isPositive: true, formatted: '+100%');
    }
  }

  // Cas normal : variation relative
  final percent = ((current - previous) / previous) * 100;
  final isPositive = percent >= 0;
  final absPercent = percent.abs();
  return VariationData(
    percent: absPercent,
    isPositive: isPositive,
    formatted: '${isPositive ? '+' : '-'}${absPercent.toStringAsFixed(1)}%',
  );
}