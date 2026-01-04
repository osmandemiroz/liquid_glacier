import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A container widget that applies the Liquid Glass effect.
///
/// This is the core building block for all Liquid Glass widgets.
/// It combines [ClipRRect], [BackdropFilter], and layered decorations
/// to create Apple's Liquid Glass aesthetic.
class LiquidGlassContainer extends StatelessWidget {
  /// Creates a Liquid Glass container.
  const LiquidGlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.blurSigma,
    this.opacity,
    this.borderRadius,
    this.tintColor,
    this.reflectionColor,
    this.enableReflection,
    this.enableShadow,
    this.borderWidth,
    this.borderColor,
    this.shadows,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The child widget to display inside the glass container.
  final Widget? child;

  /// Width of the container.
  final double? width;

  /// Height of the container.
  final double? height;

  /// Additional constraints for the container.
  final BoxConstraints? constraints;

  /// Padding inside the glass container.
  final EdgeInsetsGeometry? padding;

  /// Margin outside the glass container.
  final EdgeInsetsGeometry? margin;

  /// Override blur sigma from theme.
  final double? blurSigma;

  /// Override opacity from theme.
  final double? opacity;

  /// Override border radius from theme.
  final BorderRadius? borderRadius;

  /// Override tint color from theme.
  final Color? tintColor;

  /// Override reflection color from theme.
  final Color? reflectionColor;

  /// Override enable reflection from theme.
  final bool? enableReflection;

  /// Override enable shadow from theme.
  final bool? enableShadow;

  /// Override border width from theme.
  final double? borderWidth;

  /// Override border color from theme.
  final Color? borderColor;

  /// Override shadows from theme.
  final List<BoxShadow>? shadows;

  /// Alignment of the child within the container.
  final AlignmentGeometry? alignment;

  /// How to clip the container.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma;
    final effectiveOpacity = opacity ?? theme.opacity;
    final effectiveBorderRadius = borderRadius ?? theme.borderRadius;
    final effectiveTintColor = tintColor ?? theme.tintColor;
    final effectiveReflectionColor = reflectionColor ?? theme.reflectionColor;
    final effectiveEnableReflection =
        enableReflection ?? theme.enableReflection;
    final effectiveEnableShadow = enableShadow ?? theme.enableShadow;
    final effectiveBorderWidth = borderWidth ?? theme.borderWidth;
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;
    final effectiveShadows = shadows ?? theme.effectiveShadows;

    Widget container = ClipRRect(
      borderRadius: effectiveBorderRadius,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: Container(
          width: width,
          height: height,
          constraints: constraints,
          padding: padding,
          alignment: alignment,
          decoration: BoxDecoration(
            color: effectiveTintColor.withValues(alpha: effectiveOpacity),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: effectiveBorderColor,
              width: effectiveBorderWidth,
            ),
            gradient: effectiveEnableReflection
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      effectiveReflectionColor.withValues(alpha: 0.2),
                      effectiveReflectionColor.withValues(alpha: 0.05),
                    ],
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );

    // Apply shadow wrapper if enabled
    if (effectiveEnableShadow) {
      container = Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          boxShadow: effectiveShadows,
        ),
        child: container,
      );
    } else if (margin != null) {
      container = Container(
        margin: margin,
        child: container,
      );
    }

    return container;
  }
}

/// An animated version of [LiquidGlassContainer] that animates changes.
class AnimatedLiquidGlassContainer extends ImplicitlyAnimatedWidget {
  /// Creates an animated Liquid Glass container.
  const AnimatedLiquidGlassContainer({
    required super.duration,
    super.key,
    super.curve = Curves.easeInOut,
    this.child,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.blurSigma,
    this.opacity,
    this.borderRadius,
    this.tintColor,
    this.reflectionColor,
    this.enableReflection,
    this.enableShadow,
    this.borderWidth,
    this.borderColor,
    this.shadows,
    this.alignment,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? blurSigma;
  final double? opacity;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final Color? reflectionColor;
  final bool? enableReflection;
  final bool? enableShadow;
  final double? borderWidth;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final AlignmentGeometry? alignment;

  @override
  AnimatedWidgetBaseState<AnimatedLiquidGlassContainer> createState() =>
      _AnimatedLiquidGlassContainerState();
}

class _AnimatedLiquidGlassContainerState
    extends AnimatedWidgetBaseState<AnimatedLiquidGlassContainer> {
  Tween<double>? _blurSigma;
  Tween<double>? _opacity;
  BorderRadiusTween? _borderRadius;
  ColorTween? _tintColor;
  ColorTween? _reflectionColor;
  Tween<double>? _borderWidth;
  ColorTween? _borderColor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _blurSigma = visitor(
      _blurSigma,
      widget.blurSigma ?? 10.0,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _opacity = visitor(
      _opacity,
      widget.opacity ?? 0.15,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _borderRadius = visitor(
      _borderRadius,
      widget.borderRadius ?? const BorderRadius.all(Radius.circular(16)),
      (value) => BorderRadiusTween(begin: value as BorderRadius),
    ) as BorderRadiusTween?;

    _tintColor = visitor(
      _tintColor,
      widget.tintColor ?? Colors.white,
      (value) => ColorTween(begin: value as Color),
    ) as ColorTween?;

    _reflectionColor = visitor(
      _reflectionColor,
      widget.reflectionColor ?? Colors.white,
      (value) => ColorTween(begin: value as Color),
    ) as ColorTween?;

    _borderWidth = visitor(
      _borderWidth,
      widget.borderWidth ?? 0.5,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _borderColor = visitor(
      _borderColor,
      widget.borderColor ?? Colors.white.withValues(alpha: 0.3),
      (value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      width: widget.width,
      height: widget.height,
      constraints: widget.constraints,
      padding: widget.padding,
      margin: widget.margin,
      blurSigma: _blurSigma?.evaluate(animation),
      opacity: _opacity?.evaluate(animation),
      borderRadius: _borderRadius?.evaluate(animation),
      tintColor: _tintColor?.evaluate(animation),
      reflectionColor: _reflectionColor?.evaluate(animation),
      enableReflection: widget.enableReflection,
      enableShadow: widget.enableShadow,
      borderWidth: _borderWidth?.evaluate(animation),
      borderColor: _borderColor?.evaluate(animation),
      shadows: widget.shadows,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}
