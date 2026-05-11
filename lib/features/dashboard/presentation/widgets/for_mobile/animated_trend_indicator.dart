import 'package:flutter/material.dart';
import '../../../../../core/until/variation_helper.dart';

// Votre AnimatedTrendIndicator actuel, sans condition isNew
class AnimatedTrendIndicator extends StatelessWidget {
  final VariationData variation;
  final bool isTablet;

  const AnimatedTrendIndicator({super.key, required this.variation, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: variation.isPositive ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            variation.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: variation.isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 3),
          Text(
            variation.formatted,
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              fontWeight: FontWeight.bold,
              color: variation.isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}