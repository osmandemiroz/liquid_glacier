// ignore_for_file: no_default_cases

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/core/liquid_glass_transitions.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

// ============================================================================
// LIQUID GLASS SNACK BAR
// ============================================================================
// A beautiful, Apple-inspired snackbar with liquid glass effects.
// Features translucent surfaces, dynamic blur, subtle reflections,
// and smooth animated transitions following Apple's Human Interface Guidelines.
// ============================================================================

/// The type/severity of the snackbar, which affects its accent color.
enum LiquidGlassSnackBarType {
  /// Informational message (blue accent)
  info,

  /// Success message (green accent)
  success,

  /// Warning message (orange accent)
  warning,

  /// Error message (red accent)
  error,

  /// Custom/neutral message (uses theme color)
  neutral,
}

/// Position where the snackbar appears on screen.
enum LiquidGlassSnackBarPosition {
  /// Bottom of the screen (default)
  bottom,

  /// Top of the screen
  top,
}

// ============================================================================
// ANIMATED SNACKBAR OVERLAY SYSTEM
// ============================================================================

/// Controller for managing animated Liquid Glass snackbars.
///
/// This provides a beautiful overlay-based snackbar system with
/// full control over animations and transitions.
class LiquidGlassSnackBarController {
  LiquidGlassSnackBarController._();

  static LiquidGlassSnackBarController? _instance;
  // ignore: prefer_constructors_over_static_methods
  static LiquidGlassSnackBarController get instance {
    _instance ??= LiquidGlassSnackBarController._();
    return _instance!;
  }

  OverlayEntry? _currentEntry;
  _AnimatedSnackBarState? _currentState;
  Timer? _autoHideTimer;

  /// Whether a snackbar is currently visible.
  bool get isVisible => _currentEntry != null;

  /// Shows a snackbar and returns when it's dismissed.
  Future<void> show({
    required BuildContext context,
    required String message,
    LiquidGlassSnackBarType type = LiquidGlassSnackBarType.neutral,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
    LiquidGlassSnackBarPosition position = LiquidGlassSnackBarPosition.bottom,
    LiquidGlassTransitionType transitionType =
        LiquidGlassTransitionType.slideUp,
    Duration transitionDuration = const Duration(milliseconds: 350),
    Curve? transitionCurve,
    double? blurSigma,
    double? glassOpacity,
    BorderRadius? borderRadius,
    Color? tintColor,
    Color? borderColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) async {
    // Dismiss any existing snackbar first
    await hide();

    final overlay = Overlay.of(context);
    final completer = Completer<void>();

    // Determine transition based on position if not specified
    var effectiveTransitionType = transitionType;
    if (position == LiquidGlassSnackBarPosition.top &&
        transitionType == LiquidGlassTransitionType.slideUp) {
      effectiveTransitionType = LiquidGlassTransitionType.slideDown;
    }

    _currentEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackBar(
        message: message,
        type: type,
        icon: icon,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        showCloseIcon: showCloseIcon,
        position: position,
        transitionType: effectiveTransitionType,
        transitionDuration: transitionDuration,
        transitionCurve: transitionCurve,
        blurSigma: blurSigma,
        glassOpacity: glassOpacity,
        borderRadius: borderRadius,
        tintColor: tintColor,
        borderColor: borderColor,
        margin: margin,
        padding: padding,
        onDismiss: () {
          _autoHideTimer?.cancel();
          _currentEntry?.remove();
          _currentEntry = null;
          _currentState = null;
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
        onStateCreated: (state) {
          _currentState = state;
        },
      ),
    );

    overlay.insert(_currentEntry!);

    // Set up auto-hide timer
    if (duration != Duration.zero) {
      _autoHideTimer = Timer(duration, hide);
    }

    return completer.future;
  }

  /// Hides the current snackbar with animation.
  Future<void> hide() async {
    _autoHideTimer?.cancel();
    _autoHideTimer = null;

    if (_currentState != null) {
      await _currentState!.animateOut();
    }

    _currentEntry?.remove();
    _currentEntry = null;
    _currentState = null;
  }
}

/// Internal animated snackbar widget.
class _AnimatedSnackBar extends StatefulWidget {
  const _AnimatedSnackBar({
    required this.message,
    required this.type,
    required this.position,
    required this.transitionType,
    required this.transitionDuration,
    required this.onDismiss,
    required this.onStateCreated,
    this.icon,
    this.actionLabel,
    this.onActionPressed,
    this.showCloseIcon = false,
    this.transitionCurve,
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.tintColor,
    this.borderColor,
    this.margin,
    this.padding,
  });

  final String message;
  final LiquidGlassSnackBarType type;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool showCloseIcon;
  final LiquidGlassSnackBarPosition position;
  final LiquidGlassTransitionType transitionType;
  final Duration transitionDuration;
  final Curve? transitionCurve;
  final double? blurSigma;
  final double? glassOpacity;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback onDismiss;
  final void Function(_AnimatedSnackBarState state) onStateCreated;

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );

    final curve =
        widget.transitionCurve ?? _getCurveForTransition(widget.transitionType);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: curve,
      reverseCurve: Curves.easeInCubic,
    );

    // Register state with controller
    widget.onStateCreated(this);

    // Start entrance animation
    _controller.forward();
  }

  Curve _getCurveForTransition(LiquidGlassTransitionType type) {
    switch (type) {
      case LiquidGlassTransitionType.slideUp:
      case LiquidGlassTransitionType.slideDown:
        return Curves.easeOutCubic;
      case LiquidGlassTransitionType.scale:
      case LiquidGlassTransitionType.scaleDown:
        return Curves.easeOutBack;
      case LiquidGlassTransitionType.elastic:
        return Curves.elasticOut;
      case LiquidGlassTransitionType.zoom:
        return Curves.easeOutBack;
      default:
        return Curves.easeOut;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Animates the snackbar out.
  Future<void> animateOut() async {
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final safeBottom = mediaQuery.padding.bottom;
    final safeTop = mediaQuery.padding.top;

    return Positioned(
      left: 0,
      right: 0,
      top: widget.position == LiquidGlassSnackBarPosition.top
          ? safeTop + 8
          : null,
      bottom: widget.position == LiquidGlassSnackBarPosition.bottom
          ? bottomInset + safeBottom + 16
          : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return _buildTransitionedContent(child!);
        },
        child: _LiquidGlassSnackBarContent(
          message: widget.message,
          type: widget.type,
          icon: widget.icon,
          actionLabel: widget.actionLabel,
          onActionPressed: widget.onActionPressed,
          showCloseIcon: widget.showCloseIcon,
          blurSigma: widget.blurSigma,
          glassOpacity: widget.glassOpacity,
          borderRadius: widget.borderRadius,
          tintColor: widget.tintColor,
          borderColor: widget.borderColor,
          padding: widget.padding,
          onClose: animateOut,
        ),
      ),
    );
  }

  Widget _buildTransitionedContent(Widget child) {
    final value = _animation.value;

    switch (widget.transitionType) {
      case LiquidGlassTransitionType.none:
        return Padding(
          padding: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        );

      case LiquidGlassTransitionType.fade:
        return Opacity(
          opacity: value,
          child: Padding(
            padding:
                widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        );

      case LiquidGlassTransitionType.scale:
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );

      case LiquidGlassTransitionType.scaleDown:
        return Transform.scale(
          scale: 1.1 - (0.1 * value),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );

      case LiquidGlassTransitionType.slideUp:
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );

      case LiquidGlassTransitionType.slideDown:
        return Transform.translate(
          offset: Offset(0, -50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );

      case LiquidGlassTransitionType.slideLeft:
        return Transform.translate(
          offset: Offset(100 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );

      case LiquidGlassTransitionType.slideRight:
        return Transform.translate(
          offset: Offset(-100 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );

      case LiquidGlassTransitionType.zoom:
        return Transform.scale(
          scale: 0.5 + (0.5 * value),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );

      case LiquidGlassTransitionType.elastic:
        return Transform.scale(
          scale: 0.6 + (0.4 * value),
          child: Opacity(
            opacity: (value * 3).clamp(0.0, 1.0),
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );

      case LiquidGlassTransitionType.blur:
        return Transform.scale(
          scale: 1.05 - (0.05 * value),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding:
                  widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: child,
            ),
          ),
        );
    }
  }
}

/// Internal content widget for the Liquid Glass SnackBar.
class _LiquidGlassSnackBarContent extends StatelessWidget {
  const _LiquidGlassSnackBarContent({
    required this.message,
    required this.type,
    required this.onClose,
    this.icon,
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.tintColor,
    this.borderColor,
    this.padding,
    this.actionLabel,
    this.onActionPressed,
    this.showCloseIcon = false,
  });

  final String message;
  final Widget? icon;
  final LiquidGlassSnackBarType type;
  final double? blurSigma;
  final double? glassOpacity;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool showCloseIcon;
  final VoidCallback onClose;

  /// Returns the accent color based on snackbar type.
  Color _getTypeAccentColor() {
    switch (type) {
      case LiquidGlassSnackBarType.info:
        return const Color(0xFF007AFF); // Apple Blue
      case LiquidGlassSnackBarType.success:
        return const Color(0xFF34C759); // Apple Green
      case LiquidGlassSnackBarType.warning:
        return const Color(0xFFFF9500); // Apple Orange
      case LiquidGlassSnackBarType.error:
        return const Color(0xFFFF3B30); // Apple Red
      case LiquidGlassSnackBarType.neutral:
        return Colors.white;
    }
  }

  /// Returns the default icon based on snackbar type.
  IconData _getTypeDefaultIcon() {
    switch (type) {
      case LiquidGlassSnackBarType.info:
        return Icons.info_outline_rounded;
      case LiquidGlassSnackBarType.success:
        return Icons.check_circle_outline_rounded;
      case LiquidGlassSnackBarType.warning:
        return Icons.warning_amber_rounded;
      case LiquidGlassSnackBarType.error:
        return Icons.error_outline_rounded;
      case LiquidGlassSnackBarType.neutral:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    // Calculate effective values from theme or overrides
    final effectiveBlurSigma = blurSigma ?? theme.blurSigma * 1.2;
    final effectiveOpacity = glassOpacity ?? theme.opacity * 1.3;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveTintColor =
        tintColor ?? (isDark ? const Color(0xFF2C2C2E) : Colors.white);
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;
    final accentColor = _getTypeAccentColor();

    // Build the icon widget
    var effectiveIcon = icon;
    if (effectiveIcon == null && type != LiquidGlassSnackBarType.neutral) {
      effectiveIcon = Icon(
        _getTypeDefaultIcon(),
        color: accentColor,
        size: 22,
      );
    }

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlurSigma,
            sigmaY: effectiveBlurSigma,
          ),
          child: Container(
            decoration: BoxDecoration(
              // Base glass color with tint
              color: effectiveTintColor.withValues(alpha: effectiveOpacity),
              borderRadius: effectiveBorderRadius,
              // Subtle luminous border
              border: Border.all(
                color: effectiveBorderColor.withValues(
                  alpha: isDark ? 0.3 : 0.4,
                ),
                width: 0.5,
              ),
              // Soft shadow for depth
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: -2,
                ),
                // Subtle glow effect based on type
                if (type != LiquidGlassSnackBarType.neutral)
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: -4,
                  ),
              ],
              // Subtle gradient for depth
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.08 : 0.15),
                  Colors.transparent,
                  Colors.black.withValues(alpha: isDark ? 0.05 : 0.02),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Container(
              // Accent bar on the left edge
              decoration: type != LiquidGlassSnackBarType.neutral
                  ? BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: accentColor,
                          width: 3,
                        ),
                      ),
                      borderRadius: effectiveBorderRadius,
                    )
                  : null,
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Leading icon
                  if (effectiveIcon != null) ...[
                    effectiveIcon,
                    const SizedBox(width: 12),
                  ],

                  // Message text
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),

                  // Action button
                  if (actionLabel != null && onActionPressed != null) ...[
                    const SizedBox(width: 8),
                    _LiquidGlassSnackBarAction(
                      label: actionLabel!,
                      onPressed: () {
                        onActionPressed!();
                        onClose();
                      },
                      accentColor: accentColor,
                      isDark: isDark,
                    ),
                  ],

                  // Close button
                  if (showCloseIcon) ...[
                    const SizedBox(width: 4),
                    _LiquidGlassSnackBarCloseButton(
                      isDark: isDark,
                      onPressed: onClose,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Action button for the Liquid Glass SnackBar.
class _LiquidGlassSnackBarAction extends StatefulWidget {
  const _LiquidGlassSnackBarAction({
    required this.label,
    required this.onPressed,
    required this.accentColor,
    required this.isDark,
  });

  final String label;
  final VoidCallback onPressed;
  final Color accentColor;
  final bool isDark;

  @override
  State<_LiquidGlassSnackBarAction> createState() =>
      _LiquidGlassSnackBarActionState();
}

class _LiquidGlassSnackBarActionState
    extends State<_LiquidGlassSnackBarAction> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isPressed
                ? widget.accentColor.withValues(alpha: 0.3)
                : _isHovered
                    ? widget.accentColor.withValues(alpha: 0.15)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.accentColor.withValues(
                alpha: _isHovered || _isPressed ? 0.5 : 0.3,
              ),
              width: 0.5,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.accentColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}

/// Close button for the Liquid Glass SnackBar.
class _LiquidGlassSnackBarCloseButton extends StatefulWidget {
  const _LiquidGlassSnackBarCloseButton({
    required this.isDark,
    required this.onPressed,
  });

  final bool isDark;
  final VoidCallback onPressed;

  @override
  State<_LiquidGlassSnackBarCloseButton> createState() =>
      _LiquidGlassSnackBarCloseButtonState();
}

class _LiquidGlassSnackBarCloseButtonState
    extends State<_LiquidGlassSnackBarCloseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05))
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close_rounded,
            size: 18,
            color: widget.isDark
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HELPER FUNCTION - Main API
// ============================================================================

/// Shows a Liquid Glass styled snackbar with beautiful animated transitions.
///
/// This is the recommended way to display a snackbar with the Liquid Glass style.
/// It uses an overlay-based system for full control over animations.
///
/// Parameters:
/// - [context]: The build context
/// - [message]: The message to display
/// - [type]: The snackbar type (info, success, warning, error, neutral)
/// - [icon]: Optional custom icon widget
/// - [actionLabel]: Optional action button label
/// - [onActionPressed]: Optional action button callback
/// - [duration]: How long the snackbar should be visible
/// - [showCloseIcon]: Whether to show a close button
/// - [position]: Where to show the snackbar (top or bottom)
/// - [transitionType]: The type of entrance/exit animation
/// - [transitionDuration]: Duration of the animation
///
/// Example:
/// ```dart
/// showLiquidGlassSnackBar(
///   context: context,
///   message: 'File saved successfully!',
///   type: LiquidGlassSnackBarType.success,
///   transitionType: LiquidGlassTransitionType.slideUp,
///   actionLabel: 'View',
///   onActionPressed: () => openFile(),
/// );
/// ```
Future<void> showLiquidGlassSnackBar({
  required BuildContext context,
  required String message,
  LiquidGlassSnackBarType type = LiquidGlassSnackBarType.neutral,
  Widget? icon,
  String? actionLabel,
  VoidCallback? onActionPressed,
  Duration duration = const Duration(seconds: 4),
  bool showCloseIcon = false,
  LiquidGlassSnackBarPosition position = LiquidGlassSnackBarPosition.bottom,
  LiquidGlassTransitionType transitionType = LiquidGlassTransitionType.slideUp,
  Duration transitionDuration = const Duration(milliseconds: 350),
  Curve? transitionCurve,
  double? blurSigma,
  double? glassOpacity,
  BorderRadius? borderRadius,
  Color? tintColor,
  Color? borderColor,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
}) {
  return LiquidGlassSnackBarController.instance.show(
    context: context,
    message: message,
    type: type,
    icon: icon,
    actionLabel: actionLabel,
    onActionPressed: onActionPressed,
    duration: duration,
    showCloseIcon: showCloseIcon,
    position: position,
    transitionType: transitionType,
    transitionDuration: transitionDuration,
    transitionCurve: transitionCurve,
    blurSigma: blurSigma,
    glassOpacity: glassOpacity,
    borderRadius: borderRadius,
    tintColor: tintColor,
    borderColor: borderColor,
    margin: margin,
    padding: padding,
  );
}

/// Hides the current Liquid Glass snackbar with animation.
Future<void> hideLiquidGlassSnackBar() {
  return LiquidGlassSnackBarController.instance.hide();
}

// ============================================================================
// LEGACY SNACKBAR (ScaffoldMessenger-based)
// ============================================================================
// These are kept for compatibility with standard Flutter SnackBar APIs.
// For the best experience with transitions, use showLiquidGlassSnackBar above.
// ============================================================================

/// A Liquid Glass styled SnackBar (ScaffoldMessenger-based).
///
/// For smooth animated transitions, use [showLiquidGlassSnackBar] instead.
class LiquidGlassSnackBar extends SnackBar {
  /// Creates a Liquid Glass snackbar.
  LiquidGlassSnackBar({
    required BuildContext context,
    required String message,
    super.key,
    Widget? icon,
    LiquidGlassSnackBarType type = LiquidGlassSnackBarType.neutral,
    String? actionLabel,
    VoidCallback? onActionPressed,
    super.onVisible,
    super.duration,
    double? blurSigma,
    double? glassOpacity,
    BorderRadius? borderRadius,
    Color? tintColor,
    Color? borderColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    bool showCloseIcon = false,
    super.width,
    DismissDirection super.dismissDirection = DismissDirection.down,
  }) : super(
          content: _LegacySnackBarContent(
            context: context,
            message: message,
            icon: icon,
            type: type,
            blurSigma: blurSigma,
            glassOpacity: glassOpacity,
            borderRadius: borderRadius,
            tintColor: tintColor,
            borderColor: borderColor,
            padding: padding,
            actionLabel: actionLabel,
            onActionPressed: onActionPressed,
            showCloseIcon: showCloseIcon,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: margin ?? const EdgeInsets.all(16),
          padding: EdgeInsets.zero,
          action: null,
          showCloseIcon: false,
        );
}

/// Legacy snackbar content for ScaffoldMessenger-based snackbar.
class _LegacySnackBarContent extends StatelessWidget {
  const _LegacySnackBarContent({
    required this.context,
    required this.message,
    required this.type,
    this.icon,
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.tintColor,
    this.borderColor,
    this.padding,
    this.actionLabel,
    this.onActionPressed,
    this.showCloseIcon = false,
  });

  final BuildContext context;
  final String message;
  final Widget? icon;
  final LiquidGlassSnackBarType type;
  final double? blurSigma;
  final double? glassOpacity;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool showCloseIcon;

  Color _getTypeAccentColor() {
    switch (type) {
      case LiquidGlassSnackBarType.info:
        return const Color(0xFF007AFF);
      case LiquidGlassSnackBarType.success:
        return const Color(0xFF34C759);
      case LiquidGlassSnackBarType.warning:
        return const Color(0xFFFF9500);
      case LiquidGlassSnackBarType.error:
        return const Color(0xFFFF3B30);
      case LiquidGlassSnackBarType.neutral:
        return Colors.white;
    }
  }

  IconData _getTypeDefaultIcon() {
    switch (type) {
      case LiquidGlassSnackBarType.info:
        return Icons.info_outline_rounded;
      case LiquidGlassSnackBarType.success:
        return Icons.check_circle_outline_rounded;
      case LiquidGlassSnackBarType.warning:
        return Icons.warning_amber_rounded;
      case LiquidGlassSnackBarType.error:
        return Icons.error_outline_rounded;
      case LiquidGlassSnackBarType.neutral:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma * 1.2;
    final effectiveOpacity = glassOpacity ?? theme.opacity * 1.3;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveTintColor =
        tintColor ?? (isDark ? const Color(0xFF2C2C2E) : Colors.white);
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;
    final accentColor = _getTypeAccentColor();

    var effectiveIcon = icon;
    if (effectiveIcon == null && type != LiquidGlassSnackBarType.neutral) {
      effectiveIcon = Icon(
        _getTypeDefaultIcon(),
        color: accentColor,
        size: 22,
      );
    }

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveTintColor.withValues(alpha: effectiveOpacity),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: effectiveBorderColor.withValues(
                alpha: isDark ? 0.3 : 0.4,
              ),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -2,
              ),
              if (type != LiquidGlassSnackBarType.neutral)
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: -4,
                ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: isDark ? 0.08 : 0.15),
                Colors.transparent,
                Colors.black.withValues(alpha: isDark ? 0.05 : 0.02),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Container(
            decoration: type != LiquidGlassSnackBarType.neutral
                ? BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: accentColor,
                        width: 3,
                      ),
                    ),
                    borderRadius: effectiveBorderRadius,
                  )
                : null,
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (effectiveIcon != null) ...[
                  effectiveIcon,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (actionLabel != null && onActionPressed != null) ...[
                  const SizedBox(width: 8),
                  _LiquidGlassSnackBarAction(
                    label: actionLabel!,
                    onPressed: () {
                      onActionPressed!();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    accentColor: accentColor,
                    isDark: isDark,
                  ),
                ],
                if (showCloseIcon) ...[
                  const SizedBox(width: 4),
                  _LiquidGlassSnackBarCloseButton(
                    isDark: isDark,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LIQUID GLASS SNACK BAR CONTENT (for custom content)
// ============================================================================

/// A standalone Liquid Glass content widget for creating custom snackbars.
///
/// Use this when you need more control over the snackbar content
/// while still maintaining the glass effect aesthetic.
class LiquidGlassSnackBarContent extends StatelessWidget {
  /// Creates a Liquid Glass snackbar content widget.
  const LiquidGlassSnackBarContent({
    required this.child,
    super.key,
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.tintColor,
    this.borderColor,
    this.padding,
    this.accentColor,
  });

  /// The content to display inside the glass container.
  final Widget child;

  /// Override blur sigma from theme.
  final double? blurSigma;

  /// Override glass opacity from theme.
  final double? glassOpacity;

  /// Override border radius from theme.
  final BorderRadius? borderRadius;

  /// Override tint color from theme.
  final Color? tintColor;

  /// Override border color from theme.
  final Color? borderColor;

  /// Padding inside the glass container.
  final EdgeInsetsGeometry? padding;

  /// Optional accent color for left border.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma * 1.2;
    final effectiveOpacity = glassOpacity ?? theme.opacity * 1.3;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveTintColor =
        tintColor ?? (isDark ? const Color(0xFF2C2C2E) : Colors.white);
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveTintColor.withValues(alpha: effectiveOpacity),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: effectiveBorderColor.withValues(
                alpha: isDark ? 0.3 : 0.4,
              ),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -2,
              ),
              if (accentColor != null)
                BoxShadow(
                  color: accentColor!.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: -4,
                ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: isDark ? 0.08 : 0.15),
                Colors.transparent,
                Colors.black.withValues(alpha: isDark ? 0.05 : 0.02),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Container(
            decoration: accentColor != null
                ? BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: accentColor!,
                        width: 3,
                      ),
                    ),
                    borderRadius: effectiveBorderRadius,
                  )
                : null,
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: child,
          ),
        ),
      ),
    );
  }
}
