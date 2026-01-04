import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/core/liquid_glass_container.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled Card widget.
///
/// Replaces the standard Material [Card] with a frosted glass surface
/// that features blur, transparency, and subtle depth effects.
class LiquidGlassCard extends StatefulWidget {
  /// Creates a Liquid Glass card.
  const LiquidGlassCard({
    super.key,
    this.child,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.semanticContainer = true,
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.enableHoverEffect = true,
    this.onTap,
    this.onLongPress,
  });

  /// The widget to display inside the card.
  final Widget? child;

  /// The card's background color (tint for glass effect).
  final Color? color;

  /// The shadow color.
  final Color? shadowColor;

  /// The surface tint color.
  final Color? surfaceTintColor;

  /// Elevation (affects shadow intensity).
  final double? elevation;

  /// Shape of the card (use [borderRadius] for glass-specific rounding).
  final ShapeBorder? shape;

  /// Whether to paint the border in front of the child.
  final bool borderOnForeground;

  /// Margin around the card.
  final EdgeInsetsGeometry? margin;

  /// How to clip the card's content.
  final Clip? clipBehavior;

  /// Whether the card is a semantic container.
  final bool semanticContainer;

  // Liquid Glass specific properties

  /// Blur intensity for the glass effect.
  final double? blurSigma;

  /// Opacity of the glass surface.
  final double? glassOpacity;

  /// Border radius for rounded corners.
  final BorderRadius? borderRadius;

  /// Whether to animate on hover/tap.
  final bool enableHoverEffect;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when the card is long pressed.
  final VoidCallback? onLongPress;

  @override
  State<LiquidGlassCard> createState() => _LiquidGlassCardState();
}

class _LiquidGlassCardState extends State<LiquidGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (!widget.enableHoverEffect) return;
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
    } else if (!_isPressed) {
      _controller.reverse();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enableHoverEffect) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enableHoverEffect) return;
    setState(() => _isPressed = false);
    if (!_isHovered) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.enableHoverEffect) return;
    setState(() => _isPressed = false);
    if (!_isHovered) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);

    Widget card = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.enableHoverEffect ? _scaleAnimation.value : 1.0,
          child: LiquidGlassContainer(
            margin: widget.margin ?? const EdgeInsets.all(4),
            borderRadius: widget.borderRadius ?? theme.borderRadius,
            blurSigma: widget.blurSigma,
            opacity: widget.glassOpacity != null
                ? widget.glassOpacity! * _opacityAnimation.value
                : null,
            tintColor: widget.color,
            child: widget.child,
          ),
        );
      },
    );

    if (widget.onTap != null || widget.onLongPress != null) {
      card = MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: card,
        ),
      );
    }

    if (widget.semanticContainer) {
      return Semantics(
        container: true,
        child: card,
      );
    }

    return card;
  }
}
