import 'package:flutter/material.dart';

/// Screen size and responsive layout helper utilities for Lotus AI.
class Responsive {
  const Responsive._();

  static const double mobileBreakpoint = 720.0;
  static const double tabletBreakpoint = 1024.0;
  static const double maxContentWidth = 900.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileBreakpoint;
}
