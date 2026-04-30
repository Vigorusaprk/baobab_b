import 'package:flutter/material.dart';
import 'package:baobab_business/core/until/variation_helper.dart'; // Import nécessaire

class AnimatedTrendIndicator extends StatefulWidget {
  final VariationData variation;
  final bool isTablet;

  const AnimatedTrendIndicator({
    super.key,
    required this.variation,
    this.isTablet = false,
  });

  @override
  State<AnimatedTrendIndicator> createState() => _AnimatedTrendIndicatorState();
}

class _AnimatedTrendIndicatorState extends State<AnimatedTrendIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedTrendIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Relance l'animation si la valeur formatée ou le signe change
    if (oldWidget.variation.formatted != widget.variation.formatted ||
        oldWidget.variation.isPositive != widget.variation.isPositive) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.variation.isPositive ? Colors.green : Colors.red;
    final backgroundColor = widget.variation.isPositive
        ? Colors.green.shade100
        : Colors.red.shade100;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isTablet ? 8 : 6,
            vertical: widget.isTablet ? 4 : 3,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.variation.isPositive
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: widget.isTablet ? 14 : 12,
                color: color,
              ),
              const SizedBox(width: 3),
              Text(
                widget.variation.formatted,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.isTablet ? 12 : 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}