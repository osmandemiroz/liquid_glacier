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
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

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

    // iOS 26 Liquid Glass: Calculate adaptive colors
    final glassBaseColor = isDark
        ? effectiveTintColor.withValues(alpha: effectiveOpacity * 0.8)
        : effectiveTintColor.withValues(alpha: effectiveOpacity * 1.2);

    // Specular highlight color (bright edge at top)
    final specularColor = effectiveReflectionColor.withValues(alpha: 0.4);
    final specularFadeColor = effectiveReflectionColor.withValues(alpha: 0);

    // Inner glow colors for depth
    final innerGlowColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.15);

    // Rim light color (luminous border effect)
    final rimLightColor = isDark
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.white.withValues(alpha: 0.4);

    Widget container = ClipRRect(
      borderRadius: effectiveBorderRadius,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: CustomPaint(
          painter: _LiquidGlassPainter(
            borderRadius: effectiveBorderRadius,
            glassColor: glassBaseColor,
            specularColor: specularColor,
            specularFadeColor: specularFadeColor,
            innerGlowColor: innerGlowColor,
            rimLightColor: rimLightColor,
            borderColor: effectiveBorderColor,
            borderWidth: effectiveBorderWidth,
            enableReflection: effectiveEnableReflection,
            isDark: isDark,
          ),
          child: Container(
            width: width,
            height: height,
            constraints: constraints,
            padding: padding,
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );

    // Apply shadow wrapper if enabled
    if (effectiveEnableShadow) {
      container = Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          boxShadow: [
            // Primary soft shadow
            ...effectiveShadows,
            // Additional glow shadow for iOS 26 effect
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
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

/// Custom painter that renders iOS 26 Liquid Glass effects.
///
/// Paints layered glass effects including:
/// - Subtle transparent base
/// - Curved liquid/smoke swirl flowing across the surface
/// - Very thin luminous white border
/// - Organic flowing highlight texture
class _LiquidGlassPainter extends CustomPainter {
  _LiquidGlassPainter({
    required this.borderRadius,
    required this.glassColor,
    required this.specularColor,
    required this.specularFadeColor,
    required this.innerGlowColor,
    required this.rimLightColor,
    required this.borderColor,
    required this.borderWidth,
    required this.enableReflection,
    required this.isDark,
  });

  final BorderRadius borderRadius;
  final Color glassColor;
  final Color specularColor;
  final Color specularFadeColor;
  final Color innerGlowColor;
  final Color rimLightColor;
  final Color borderColor;
  final double borderWidth;
  final bool enableReflection;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    // Layer 1: Very subtle transparent base (almost invisible)
    final basePaint = Paint()
      ..color = glassColor.withValues(alpha: glassColor.a * 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, basePaint);

    // Layer 2: Liquid flow / smoke swirl effect (iOS 26 signature)
    if (enableReflection) {
      canvas
        ..save()
        ..clipRRect(rrect);

      // Create curved liquid swirl using bezier path
      final liquidPath = Path()

        // First swirl curve - flowing from bottom-left to top-right
        ..moveTo(-size.width * 0.2, size.height * 0.8)
        ..cubicTo(
          size.width * 0.1,
          size.height * 0.6,
          size.width * 0.3,
          size.height * 0.3,
          size.width * 0.5,
          size.height * 0.2,
        )
        ..cubicTo(
          size.width * 0.7,
          size.height * 0.1,
          size.width * 0.9,
          size.height * 0.15,
          size.width * 1.2,
          size.height * 0.0,
        )
        // Extend the path width for the swirl effect
        ..lineTo(size.width * 1.3, size.height * 0.25)
        ..cubicTo(
          size.width * 1.0,
          size.height * 0.35,
          size.width * 0.75,
          size.height * 0.3,
          size.width * 0.55,
          size.height * 0.4,
        )
        ..cubicTo(
          size.width * 0.35,
          size.height * 0.5,
          size.width * 0.15,
          size.height * 0.75,
          -size.width * 0.1,
          size.height * 0.95,
        )
        ..close();

      // Liquid swirl gradient - subtle smoky white
      final liquidGradient = LinearGradient(
        begin: const Alignment(-0.5, 1),
        end: const Alignment(1, -0.5),
        colors: [
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: isDark ? 0.08 : 0.12),
          Colors.white.withValues(alpha: isDark ? 0.15 : 0.20),
          Colors.white.withValues(alpha: isDark ? 0.08 : 0.12),
          Colors.white.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      );

      final liquidPaint = Paint()
        ..shader = liquidGradient.createShader(rect)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

      canvas.drawPath(liquidPath, liquidPaint);

      // Second subtle swirl - adds organic depth
      final secondSwirl = Path()
        ..moveTo(size.width * 0.6, size.height * 1.1)
        ..cubicTo(
          size.width * 0.7,
          size.height * 0.7,
          size.width * 0.85,
          size.height * 0.5,
          size.width * 1.1,
          size.height * 0.4,
        )
        ..lineTo(size.width * 1.2, size.height * 0.55)
        ..cubicTo(
          size.width * 0.95,
          size.height * 0.65,
          size.width * 0.8,
          size.height * 0.85,
          size.width * 0.7,
          size.height * 1.2,
        )
        ..close();

      final secondGradient = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: isDark ? 0.05 : 0.08),
          Colors.white.withValues(alpha: 0),
        ],
      );

      final secondPaint = Paint()
        ..shader = secondGradient.createShader(rect)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas
        ..drawPath(secondSwirl, secondPaint)
        ..restore();
    }

    // Layer 3: Very thin luminous white border (iOS 26 signature)
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;

    // Gradient rim for luminous effect - brighter at top-left
    final rimGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: isDark ? 0.5 : 0.6),
        Colors.white.withValues(alpha: isDark ? 0.15 : 0.2),
        Colors.white.withValues(alpha: isDark ? 0.1 : 0.15),
        Colors.white.withValues(alpha: isDark ? 0.25 : 0.35),
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );
    rimPaint.shader = rimGradient.createShader(rect);

    canvas.drawRRect(rrect, rimPaint);

    // Layer 4: Inner subtle glow along edges
    final innerGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 3);

    final innerGlowGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white.withValues(alpha: isDark ? 0.1 : 0.15),
        Colors.white.withValues(alpha: 0),
      ],
    );
    innerGlowPaint.shader = innerGlowGradient.createShader(rect);

    final innerRRect = rrect.deflate(1.5);
    canvas.drawRRect(innerRRect, innerGlowPaint);
  }

  @override
  bool shouldRepaint(covariant _LiquidGlassPainter oldDelegate) {
    return borderRadius != oldDelegate.borderRadius ||
        glassColor != oldDelegate.glassColor ||
        specularColor != oldDelegate.specularColor ||
        specularFadeColor != oldDelegate.specularFadeColor ||
        innerGlowColor != oldDelegate.innerGlowColor ||
        rimLightColor != oldDelegate.rimLightColor ||
        borderColor != oldDelegate.borderColor ||
        borderWidth != oldDelegate.borderWidth ||
        enableReflection != oldDelegate.enableReflection ||
        isDark != oldDelegate.isDark;
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
