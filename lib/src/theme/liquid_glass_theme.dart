import 'package:flutter/material.dart';

/// Theme data for Liquid Glass effects.
///
/// Contains all configurable properties for the glass effect including
/// blur intensity, opacity, colors, and animation settings.
@immutable
class LiquidGlassThemeData {
  /// Creates a Liquid Glass theme with the specified properties.
  const LiquidGlassThemeData({
    this.blurSigma = 10.0,
    this.opacity = 0.15,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.tintColor = Colors.white,
    this.reflectionColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableReflection = true,
    this.enableShadow = true,
    this.borderWidth = 0.5,
    this.borderColor,
    this.shadows,
  });

  /// Linearly interpolate between two themes.
  factory LiquidGlassThemeData.lerp(
    LiquidGlassThemeData a,
    LiquidGlassThemeData b,
    double t,
  ) {
    return LiquidGlassThemeData(
      blurSigma: lerpDouble(a.blurSigma, b.blurSigma, t) ?? b.blurSigma,
      opacity: lerpDouble(a.opacity, b.opacity, t) ?? b.opacity,
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t) ??
          b.borderRadius,
      tintColor: Color.lerp(a.tintColor, b.tintColor, t) ?? b.tintColor,
      reflectionColor: Color.lerp(a.reflectionColor, b.reflectionColor, t) ??
          b.reflectionColor,
      animationDuration: t < 0.5 ? a.animationDuration : b.animationDuration,
      enableReflection: t < 0.5 ? a.enableReflection : b.enableReflection,
      enableShadow: t < 0.5 ? a.enableShadow : b.enableShadow,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t) ?? b.borderWidth,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      shadows: t < 0.5 ? a.shadows : b.shadows,
    );
  }

  /// Blur intensity for the BackdropFilter.
  ///
  /// Higher values create stronger blur. Typical range: 5.0 - 25.0
  final double blurSigma;

  /// Opacity of the glass surface (0.0 to 1.0).
  ///
  /// Lower values create more transparent glass.
  final double opacity;

  /// Border radius for rounded corners.
  final BorderRadius borderRadius;

  /// Primary tint color for the glass surface.
  final Color tintColor;

  /// Color used for reflection/highlight effects.
  final Color reflectionColor;

  /// Duration of animations (hover, press, etc.).
  final Duration animationDuration;

  /// Whether to show reflection/highlight gradient.
  final bool enableReflection;

  /// Whether to apply shadow for depth.
  final bool enableShadow;

  /// Width of the subtle border around glass elements.
  final double borderWidth;

  /// Custom border color. If null, uses tintColor with opacity.
  final Color? borderColor;

  /// Custom shadows for depth effect.
  ///
  /// If null, uses default glass shadows.
  final List<BoxShadow>? shadows;

  /// Default shadows that create the Liquid Glass depth effect.
  List<BoxShadow> get defaultShadows => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  /// Gets the effective shadows to use.
  List<BoxShadow> get effectiveShadows => shadows ?? defaultShadows;

  /// Gets the effective border color.
  Color get effectiveBorderColor =>
      borderColor ?? tintColor.withValues(alpha: 0.3);

  /// Creates a copy with the given fields replaced.
  LiquidGlassThemeData copyWith({
    double? blurSigma,
    double? opacity,
    BorderRadius? borderRadius,
    Color? tintColor,
    Color? reflectionColor,
    Duration? animationDuration,
    bool? enableReflection,
    bool? enableShadow,
    double? borderWidth,
    Color? borderColor,
    List<BoxShadow>? shadows,
  }) {
    return LiquidGlassThemeData(
      blurSigma: blurSigma ?? this.blurSigma,
      opacity: opacity ?? this.opacity,
      borderRadius: borderRadius ?? this.borderRadius,
      tintColor: tintColor ?? this.tintColor,
      reflectionColor: reflectionColor ?? this.reflectionColor,
      animationDuration: animationDuration ?? this.animationDuration,
      enableReflection: enableReflection ?? this.enableReflection,
      enableShadow: enableShadow ?? this.enableShadow,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      shadows: shadows ?? this.shadows,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is LiquidGlassThemeData &&
        other.blurSigma == blurSigma &&
        other.opacity == opacity &&
        other.borderRadius == borderRadius &&
        other.tintColor == tintColor &&
        other.reflectionColor == reflectionColor &&
        other.animationDuration == animationDuration &&
        other.enableReflection == enableReflection &&
        other.enableShadow == enableShadow &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor;
  }

  @override
  int get hashCode => Object.hash(
        blurSigma,
        opacity,
        borderRadius,
        tintColor,
        reflectionColor,
        animationDuration,
        enableReflection,
        enableShadow,
        borderWidth,
        borderColor,
      );
}

/// Helper function for double interpolation.
double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  final aValue = a ?? 0.0;
  final bValue = b ?? 0.0;
  return aValue + (bValue - aValue) * t;
}

/// InheritedWidget that provides Liquid Glass theming.
class LiquidGlassTheme extends InheritedWidget {
  /// Creates a Liquid Glass theme provider.
  const LiquidGlassTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// The theme data to provide to descendants.
  final LiquidGlassThemeData data;

  /// Gets the nearest LiquidGlassThemeData from the widget tree.
  ///
  /// Returns default theme if no ancestor is found.
  static LiquidGlassThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<LiquidGlassTheme>();
    return theme?.data ?? const LiquidGlassThemeData();
  }

  /// Gets the theme without establishing a dependency.
  static LiquidGlassThemeData? maybeOf(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<LiquidGlassTheme>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(LiquidGlassTheme oldWidget) {
    return data != oldWidget.data;
  }
}
