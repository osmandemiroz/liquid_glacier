import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// Base class for Liquid Glass button styling.
abstract class LiquidGlassButtonStyle {
  const LiquidGlassButtonStyle({
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.tintColor,
    this.borderColor,
    this.borderWidth,
    this.enableGlow = true,
    this.glowColor,
    this.glowIntensity = 0.3,
  });

  final double? blurSigma;
  final double? glassOpacity;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool enableGlow;
  final Color? glowColor;
  final double glowIntensity;
}

/// A Liquid Glass styled button.
///
/// A versatile button that applies the glass effect with optional
/// glow on press and hover animations.
class LiquidGlassButton extends StatefulWidget {
  /// Creates a Liquid Glass button.
  const LiquidGlassButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.tintColor,
    this.borderColor,
    this.borderWidth,
    this.enableGlow = true,
    this.glowColor,
    this.glowIntensity = 0.3,
    this.padding,
    this.minimumSize,
    this.maximumSize,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final Widget child;

  // Liquid Glass specific properties
  final double? blurSigma;
  final double? glassOpacity;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool enableGlow;
  final Color? glowColor;
  final double glowIntensity;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Size? maximumSize;

  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton>
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
      end: 0.96,
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
    widget.onHover?.call(isHovered);
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveBlurSigma = widget.blurSigma ?? theme.blurSigma;
    final baseOpacity = widget.glassOpacity ?? theme.opacity;
    // Match LiquidGlassContainer logic: 0.8 for dark, 1.2 for light
    final effectiveOpacity = Theme.of(context).brightness == Brightness.dark
        ? baseOpacity * 0.8
        : baseOpacity * 1.2;

    final effectiveBorderRadius =
        widget.borderRadius ?? const BorderRadius.all(Radius.circular(12));
    final effectiveTintColor = widget.tintColor ?? theme.tintColor;
    final effectiveBorderColor =
        widget.borderColor ?? theme.effectiveBorderColor;
    final effectiveBorderWidth = widget.borderWidth ?? theme.borderWidth;
    final effectiveGlowColor = widget.glowColor ?? colorScheme.primary;
    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    final isDisabled = widget.onPressed == null && widget.onLongPress == null;

    return MouseRegion(
      onEnter: isDisabled ? null : (_) => _handleHover(true),
      onExit: isDisabled ? null : (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: isDisabled ? null : _handleTapDown,
        onTapUp: isDisabled ? null : _handleTapUp,
        onTapCancel: isDisabled ? null : _handleTapCancel,
        onTap: widget.onPressed,
        onLongPress: widget.onLongPress,
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  constraints: BoxConstraints(
                    minWidth: widget.minimumSize?.width ?? 64.0,
                    minHeight: widget.minimumSize?.height ?? 36.0,
                    maxWidth: widget.maximumSize?.width ?? double.infinity,
                    maxHeight: widget.maximumSize?.height ?? double.infinity,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: effectiveBorderRadius,
                    boxShadow: widget.enableGlow && (_isHovered || _isPressed)
                        ? [
                            BoxShadow(
                              color: effectiveGlowColor.withValues(
                                alpha:
                                    widget.glowIntensity * _glowAnimation.value,
                              ),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: effectiveBorderRadius,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: effectiveBlurSigma,
                        sigmaY: effectiveBlurSigma,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        padding: effectivePadding,
                        decoration: BoxDecoration(
                          color: effectiveTintColor.withValues(
                            alpha: isDisabled
                                ? effectiveOpacity * 0.5
                                : _isHovered
                                    ? effectiveOpacity * 1.3
                                    : effectiveOpacity,
                          ),
                          borderRadius: effectiveBorderRadius,
                          border: Border.all(
                            color: _isHovered
                                ? effectiveBorderColor.withValues(
                                    alpha: 0.5,
                                  )
                                : effectiveBorderColor,
                            width: effectiveBorderWidth,
                          ),
                        ),
                        child: DefaultTextStyle(
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: isDisabled
                                        ? Theme.of(context).disabledColor
                                        : null,
                                  ),
                          child: IconTheme(
                            data: IconThemeData(
                              color: isDisabled
                                  ? Theme.of(context).disabledColor
                                  : null,
                            ),
                            child: widget.child,
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
  }
}

/// A Liquid Glass styled ElevatedButton equivalent.
class LiquidGlassElevatedButton extends StatelessWidget {
  /// Creates a Liquid Glass elevated button.
  const LiquidGlassElevatedButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.onLongPress,
    this.blurSigma,
    this.glassOpacity = 0.25,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.minimumSize,
    this.icon,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final double? blurSigma;
  final double? glassOpacity;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final content = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              child,
            ],
          )
        : child;

    return LiquidGlassButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      blurSigma: blurSigma,
      glassOpacity: glassOpacity,
      borderRadius: borderRadius,
      tintColor: backgroundColor ?? colorScheme.primary,
      glowColor: backgroundColor ?? colorScheme.primary,
      padding: padding,
      minimumSize: minimumSize,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: foregroundColor ?? colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
        child: IconTheme(
          data: IconThemeData(
            color: foregroundColor ?? colorScheme.onPrimary,
          ),
          child: content,
        ),
      ),
    );
  }
}

/// A Liquid Glass styled TextButton equivalent.
class LiquidGlassTextButton extends StatelessWidget {
  /// Creates a Liquid Glass text button.
  const LiquidGlassTextButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.onLongPress,
    this.foregroundColor,
    this.padding,
    this.minimumSize,
    this.icon,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final content = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              child,
            ],
          )
        : child;

    return LiquidGlassButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      blurSigma: 0,
      glassOpacity: 0,
      borderWidth: 0,
      enableGlow: false,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minimumSize: minimumSize,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: foregroundColor ?? colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
        child: IconTheme(
          data: IconThemeData(
            color: foregroundColor ?? colorScheme.primary,
          ),
          child: content,
        ),
      ),
    );
  }
}

/// A Liquid Glass styled OutlinedButton equivalent.
class LiquidGlassOutlinedButton extends StatelessWidget {
  /// Creates a Liquid Glass outlined button.
  const LiquidGlassOutlinedButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.onLongPress,
    this.blurSigma,
    this.borderRadius,
    this.borderColor,
    this.foregroundColor,
    this.padding,
    this.minimumSize,
    this.icon,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final double? blurSigma;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final content = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              child,
            ],
          )
        : child;

    return LiquidGlassButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      blurSigma: blurSigma ?? 8,
      glassOpacity: 0.05,
      borderRadius: borderRadius,
      borderColor: borderColor ?? colorScheme.primary.withValues(alpha: 0.5),
      borderWidth: 1.5,
      glowColor: colorScheme.primary,
      padding: padding,
      minimumSize: minimumSize,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: foregroundColor ?? colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
        child: IconTheme(
          data: IconThemeData(
            color: foregroundColor ?? colorScheme.primary,
          ),
          child: content,
        ),
      ),
    );
  }
}

/// A Liquid Glass styled IconButton.
class LiquidGlassIconButton extends StatelessWidget {
  /// Creates a Liquid Glass icon button.
  const LiquidGlassIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.onLongPress,
    this.tooltip,
    this.blurSigma,
    this.glassOpacity,
    this.size = 40.0,
    this.iconSize = 24.0,
    this.color,
    this.backgroundColor,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String? tooltip;
  final double? blurSigma;
  final double? glassOpacity;
  final double size;
  final double iconSize;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget button = LiquidGlassButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      blurSigma: blurSigma,
      glassOpacity: glassOpacity ?? 0.15,
      borderRadius: BorderRadius.circular(size / 2),
      tintColor: backgroundColor,
      padding: EdgeInsets.zero,
      minimumSize: Size(size, size),
      maximumSize: Size(size, size),
      child: IconTheme(
        data: IconThemeData(
          size: iconSize,
          color: color,
        ),
        child: icon,
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip,
        child: button,
      );
    }

    return button;
  }
}
