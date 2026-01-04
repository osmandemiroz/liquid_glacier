import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled Drawer.
///
/// Provides a translucent, blurred drawer that follows
/// Apple's Liquid Glass design language.
class LiquidGlassDrawer extends StatelessWidget {
  /// Creates a Liquid Glass drawer.
  const LiquidGlassDrawer({
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.width,
    this.child,
    this.semanticLabel,
    this.clipBehavior,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
    this.borderColor,
    this.showRightBorder = true,
  });

  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final double? width;
  final Widget? child;
  final String? semanticLabel;
  final Clip? clipBehavior;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? tintColor;
  final Color? borderColor;
  final bool showRightBorder;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma;
    final effectiveOpacity = glassOpacity ?? theme.opacity;
    final effectiveTintColor = tintColor ??
        (brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF1C1C1E));
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;
    final effectiveWidth = width ?? 304.0;

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticLabel ?? MaterialLocalizations.of(context).drawerLabel,
      child: SizedBox(
        width: effectiveWidth,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: effectiveBlurSigma,
              sigmaY: effectiveBlurSigma,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: effectiveTintColor.withValues(alpha: effectiveOpacity),
                border: showRightBorder
                    ? Border(
                        right: BorderSide(
                          color: effectiveBorderColor,
                          width: 0.5,
                        ),
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(4, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A Liquid Glass styled EndDrawer variant.
class LiquidGlassEndDrawer extends StatelessWidget {
  /// Creates a Liquid Glass end drawer.
  const LiquidGlassEndDrawer({
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.width,
    this.child,
    this.semanticLabel,
    this.clipBehavior,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
    this.borderColor,
    this.showLeftBorder = true,
  });

  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final double? width;
  final Widget? child;
  final String? semanticLabel;
  final Clip? clipBehavior;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? tintColor;
  final Color? borderColor;
  final bool showLeftBorder;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma;
    final effectiveOpacity = glassOpacity ?? theme.opacity;
    final effectiveTintColor = tintColor ??
        (brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF1C1C1E));
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;
    final effectiveWidth = width ?? 304.0;

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticLabel ?? MaterialLocalizations.of(context).drawerLabel,
      child: SizedBox(
        width: effectiveWidth,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: effectiveBlurSigma,
              sigmaY: effectiveBlurSigma,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: effectiveTintColor.withValues(alpha: effectiveOpacity),
                border: showLeftBorder
                    ? Border(
                        left: BorderSide(
                          color: effectiveBorderColor,
                          width: 0.5,
                        ),
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(-4, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A Liquid Glass styled drawer header.
class LiquidGlassDrawerHeader extends StatelessWidget {
  /// Creates a Liquid Glass drawer header.
  const LiquidGlassDrawerHeader({
    required this.child,
    super.key,
    this.decoration,
    this.margin,
    this.padding,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.fastOutSlowIn,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
    this.borderColor,
  });

  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Duration duration;
  final Curve curve;
  final Widget child;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? tintColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma * 0.5;
    final effectiveOpacity = glassOpacity ?? theme.opacity * 0.5;
    final effectiveTintColor = tintColor ?? colorScheme.primaryContainer;
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;

    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlurSigma,
            sigmaY: effectiveBlurSigma,
          ),
          child: AnimatedContainer(
            duration: duration,
            curve: curve,
            padding: padding ??
                EdgeInsets.fromLTRB(
                  16,
                  16.0 + MediaQuery.of(context).padding.top,
                  16,
                  16,
                ),
            decoration: decoration ??
                BoxDecoration(
                  color: effectiveTintColor.withValues(alpha: effectiveOpacity),
                  border: Border(
                    bottom: BorderSide(
                      color: effectiveBorderColor,
                      width: 0.5,
                    ),
                  ),
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}
