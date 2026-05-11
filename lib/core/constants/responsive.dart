import 'package:flutter/material.dart';

class Responsive {
  static const double mobileMax = 600;
  static const double tabletMax = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMax &&
          MediaQuery.of(context).size.width < tabletMax;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double textScale(BuildContext context) {
    if (isMobile(context)) return 1.0;
    if (isTablet(context)) return 1.1;
    return 1.2;
  }

  static EdgeInsets screenPadding(BuildContext context) {
    final padding = isMobile(context) ? 12.0 : (isTablet(context) ? 20.0 : 32.0);
    return EdgeInsets.all(padding);
  }

  static double contentMaxWidth(BuildContext context) {
    return isDesktop(context) ? 1400 : double.infinity;
  }
}