import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled FloatingActionButton.
///
/// Provides a translucent, blurred FAB that follows
/// Apple's Liquid Glass design language with glow effects.
class LiquidGlassFAB extends StatefulWidget {
  /// Creates a Liquid Glass floating action button.
  const LiquidGlassFAB({
    required this.onPressed,
    super.key,
    this.child,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.heroTag,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.mouseCursor,
    this.mini = false,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.isExtended = false,
    this.enableFeedback,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
    this.borderColor,
    this.enableGlow = true,
    this.glowColor,
    this.glowIntensity = 0.4,
    this.size,
  });

  /// Creates an extended Liquid Glass FAB.
  LiquidGlassFAB.extended({
    required this.onPressed,
    required Widget icon,
    required Widget label,
    super.key,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.heroTag,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.mouseCursor,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.enableFeedback,
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
    this.borderColor,
    this.enableGlow = true,
    this.glowColor,
    this.glowIntensity = 0.4,
    this.size,
  })  : mini = false,
        isExtended = true,
        child = _ExtendedFABChild(icon: icon, label: label);

  final Widget? child;
  final String? tooltip;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Object? heroTag;
  final VoidCallback? onPressed;
  final MouseCursor? mouseCursor;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final double? disabledElevation;
  final bool mini;
  final ShapeBorder? shape;
  final Clip clipBehavior;
  final bool isExtended;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool? enableFeedback;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? tintColor;
  final Color? borderColor;
  final bool enableGlow;
  final Color? glowColor;
  final double glowIntensity;
  final double? size;

  @override
  State<LiquidGlassFAB> createState() => _LiquidGlassFABState();
}

class _LiquidGlassFABState extends State<LiquidGlassFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
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
    setState(() => _isHovered = isHovered);
    if (isHovered && widget.onPressed != null) {
      _controller.forward();
    } else if (!_isPressed) {
      _controller.reverse();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    if (!_isHovered) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    if (!_isHovered) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveBlurSigma = widget.blurSigma ?? theme.blurSigma;
    final effectiveOpacity = widget.glassOpacity ?? theme.opacity * 1.5;
    final effectiveTintColor = widget.tintColor ?? colorScheme.primaryContainer;
    final effectiveBorderColor =
        widget.borderColor ?? theme.effectiveBorderColor;
    final effectiveGlowColor = widget.glowColor ?? colorScheme.primary;

    double fabSize;
    if (widget.size != null) {
      fabSize = widget.size!;
    } else if (widget.mini) {
      fabSize = 40.0;
    } else {
      fabSize = 56.0;
    }

    final borderRadius = widget.isExtended
        ? BorderRadius.circular(28)
        : BorderRadius.circular(fabSize / 2);

    Widget fab = MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  height: widget.isExtended ? 56 : fabSize,
                  constraints: widget.isExtended
                      ? const BoxConstraints(minWidth: 80)
                      : BoxConstraints.tightFor(
                          width: fabSize,
                          height: fabSize,
                        ),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    boxShadow: [
                      if (widget.enableGlow && (_isHovered || _isPressed))
                        BoxShadow(
                          color: effectiveGlowColor.withValues(
                            alpha: widget.glowIntensity * _glowAnimation.value,
                          ),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: effectiveBlurSigma,
                        sigmaY: effectiveBlurSigma,
                      ),
                      child: Container(
                        padding: widget.isExtended
                            ? const EdgeInsets.symmetric(horizontal: 20)
                            : null,
                        decoration: BoxDecoration(
                          color: effectiveTintColor.withValues(
                            alpha: _isHovered || _isPressed
                                ? effectiveOpacity * 1.2
                                : effectiveOpacity,
                          ),
                          borderRadius: borderRadius,
                          border: Border.all(
                            color: effectiveBorderColor,
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: IconTheme(
                            data: IconThemeData(
                              color: widget.foregroundColor ??
                                  colorScheme.onPrimaryContainer,
                              size: widget.mini ? 18 : 24,
                            ),
                            child: DefaultTextStyle(
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: widget.foregroundColor ??
                                        colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                              child: widget.child ?? const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      fab = Tooltip(
        message: widget.tooltip,
        child: fab,
      );
    }

    if (widget.heroTag != null) {
      fab = Hero(
        tag: widget.heroTag!,
        child: fab,
      );
    }

    return fab;
  }
}

class _ExtendedFABChild extends StatelessWidget {
  const _ExtendedFABChild({
    required this.icon,
    required this.label,
  });

  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 12),
        label,
      ],
    );
  }
}

/// A small Liquid Glass FAB variant.
class LiquidGlassSmallFAB extends StatelessWidget {
  /// Creates a small Liquid Glass FAB.
  const LiquidGlassSmallFAB({
    required this.onPressed,
    required this.child,
    super.key,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.blurSigma,
    this.glassOpacity,
    this.enableGlow = true,
    this.glowColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? blurSigma;
  final double? glassOpacity;
  final bool enableGlow;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassFAB(
      onPressed: onPressed,
      mini: true,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      blurSigma: blurSigma,
      glassOpacity: glassOpacity,
      enableGlow: enableGlow,
      glowColor: glowColor,
      child: child,
    );
  }
}
