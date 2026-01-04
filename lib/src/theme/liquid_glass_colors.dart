import 'package:flutter/material.dart';

/// Preset color schemes for Liquid Glass effects.
///
/// Provides ready-to-use color combinations that work well with the glass
/// effect across different themes and backgrounds.
class LiquidGlassColors {
  LiquidGlassColors._();

  // Light theme glass colors
  static const Color lightGlass = Color(0xFFFFFFFF);
  static const Color lightGlassReflection = Color(0xFFF8F9FA);
  static const Color lightGlassBorder = Color(0x4DFFFFFF);

  // Dark theme glass colors
  static const Color darkGlass = Color(0xFF1C1C1E);
  static const Color darkGlassReflection = Color(0xFF2C2C2E);
  static const Color darkGlassBorder = Color(0x33FFFFFF);

  // Frosted variants
  static const Color frostedLight = Color(0xFFF5F5F7);
  static const Color frostedDark = Color(0xFF28282A);

  // Accent-tinted glass colors
  static const Color blueGlass = Color(0xFF007AFF);
  static const Color greenGlass = Color(0xFF34C759);
  static const Color orangeGlass = Color(0xFFFF9500);
  static const Color pinkGlass = Color(0xFFFF2D55);
  static const Color purpleGlass = Color(0xFFAF52DE);
  static const Color tealGlass = Color(0xFF5AC8FA);

  /// Returns the appropriate glass color for the given brightness.
  static Color glassColor(Brightness brightness) {
    return brightness == Brightness.light ? lightGlass : darkGlass;
  }

  /// Returns the appropriate reflection color for the given brightness.
  static Color reflectionColor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightGlassReflection
        : darkGlassReflection;
  }

  /// Returns the appropriate border color for the given brightness.
  static Color borderColor(Brightness brightness) {
    return brightness == Brightness.light ? lightGlassBorder : darkGlassBorder;
  }

  /// Creates a gradient for the glass reflection effect.
  static LinearGradient reflectionGradient({
    Color? baseColor,
    double beginOpacity = 0.4,
    double endOpacity = 0.1,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    final color = baseColor ?? lightGlassReflection;
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        color.withValues(alpha: beginOpacity),
        color.withValues(alpha: endOpacity),
      ],
    );
  }

  /// Creates a shadow list for the glass depth effect.
  static List<BoxShadow> glassShadows({
    Color? shadowColor,
    double baseOpacity = 0.1,
    double blurRadius = 20.0,
    Offset offset = const Offset(0, 10),
  }) {
    final color = shadowColor ?? Colors.black;
    return [
      BoxShadow(
        color: color.withValues(alpha: baseOpacity),
        blurRadius: blurRadius,
        offset: offset,
      ),
      BoxShadow(
        color: color.withValues(alpha: baseOpacity * 0.5),
        blurRadius: blurRadius * 0.5,
        offset: Offset(offset.dx * 0.4, offset.dy * 0.4),
      ),
    ];
  }
}
