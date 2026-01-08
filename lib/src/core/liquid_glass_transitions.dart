import 'package:flutter/material.dart';

// ============================================================================
// LIQUID GLASS TRANSITIONS
// ============================================================================
// Beautiful, Apple-inspired transitions for Liquid Glass widgets.
// These transitions follow Apple's Human Interface Guidelines, featuring
// smooth, natural motion with carefully crafted curves and timing.
// ============================================================================

/// The type of transition animation to use for Liquid Glass widgets.
///
/// Each transition type is designed to feel natural and polished,
/// following Apple's Human Interface Guidelines for animation.
enum LiquidGlassTransitionType {
  /// Fade transition - Simple opacity animation.
  /// Best for subtle, non-intrusive appearances.
  fade,

  /// Scale transition - Grows from center with fade.
  /// Classic iOS-style modal appearance.
  scale,

  /// Scale and fade from a smaller size (Apple's signature style).
  /// The default and recommended transition for dialogs.
  scaleDown,

  /// Slide up from bottom with fade.
  /// Great for sheets and bottom-anchored content.
  slideUp,

  /// Slide down from top with fade.
  /// Perfect for notifications and top-anchored content.
  slideDown,

  /// Slide from left with fade.
  slideLeft,

  /// Slide from right with fade.
  slideRight,

  /// Zoom in with a subtle bounce effect.
  /// Adds playful energy to the appearance.
  zoom,

  /// Elastic/spring animation with overshoot.
  /// Creates a lively, bouncy feel.
  elastic,

  /// Blur transition - Fades in while background blurs.
  /// Emphasizes the glass effect beautifully.
  blur,

  /// No animation - Instant appearance.
  none,
}

/// Configuration for Liquid Glass transitions.
///
/// Allows fine-tuned control over animation timing and curves.
@immutable
class LiquidGlassTransitionConfig {
  /// Creates a transition configuration.
  const LiquidGlassTransitionConfig({
    this.type = LiquidGlassTransitionType.scaleDown,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration,
    this.curve,
    this.reverseCurve,
  });

  /// The type of transition to use.
  final LiquidGlassTransitionType type;

  /// Duration of the enter animation.
  final Duration duration;

  /// Duration of the exit animation. If null, uses [duration].
  final Duration? reverseDuration;

  /// Custom curve for enter animation. If null, uses default for [type].
  final Curve? curve;

  /// Custom curve for exit animation. If null, uses [curve] or default.
  final Curve? reverseCurve;

  /// Gets the effective curve for the given transition type.
  Curve get effectiveCurve => curve ?? _defaultCurveForType(type);

  /// Gets the effective reverse curve.
  Curve get effectiveReverseCurve =>
      reverseCurve ?? curve ?? _defaultReverseCurveForType(type);

  /// Gets the effective reverse duration.
  Duration get effectiveReverseDuration => reverseDuration ?? duration;

  /// Default curve for each transition type.
  static Curve _defaultCurveForType(LiquidGlassTransitionType type) {
    switch (type) {
      case LiquidGlassTransitionType.fade:
        return Curves.easeOut;
      case LiquidGlassTransitionType.scale:
        return Curves.easeOutCubic;
      case LiquidGlassTransitionType.scaleDown:
        return const _AppleEaseCurve(); // Custom Apple-like curve
      case LiquidGlassTransitionType.slideUp:
      case LiquidGlassTransitionType.slideDown:
      case LiquidGlassTransitionType.slideLeft:
      case LiquidGlassTransitionType.slideRight:
        return Curves.easeOutCubic;
      case LiquidGlassTransitionType.zoom:
        return Curves.easeOutBack;
      case LiquidGlassTransitionType.elastic:
        return Curves.elasticOut;
      case LiquidGlassTransitionType.blur:
        return Curves.easeOut;
      case LiquidGlassTransitionType.none:
        return Curves.linear;
    }
  }

  /// Default reverse curve for each transition type.
  static Curve _defaultReverseCurveForType(LiquidGlassTransitionType type) {
    switch (type) {
      case LiquidGlassTransitionType.fade:
        return Curves.easeIn;
      case LiquidGlassTransitionType.scale:
      case LiquidGlassTransitionType.scaleDown:
        return Curves.easeInCubic;
      case LiquidGlassTransitionType.slideUp:
      case LiquidGlassTransitionType.slideDown:
      case LiquidGlassTransitionType.slideLeft:
      case LiquidGlassTransitionType.slideRight:
        return Curves.easeInCubic;
      case LiquidGlassTransitionType.zoom:
        return Curves.easeIn;
      case LiquidGlassTransitionType.elastic:
        return Curves.easeInBack;
      case LiquidGlassTransitionType.blur:
        return Curves.easeIn;
      case LiquidGlassTransitionType.none:
        return Curves.linear;
    }
  }

  /// Creates a copy with the given fields replaced.
  LiquidGlassTransitionConfig copyWith({
    LiquidGlassTransitionType? type,
    Duration? duration,
    Duration? reverseDuration,
    Curve? curve,
    Curve? reverseCurve,
  }) {
    return LiquidGlassTransitionConfig(
      type: type ?? this.type,
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
    );
  }

  /// Preset: Fast and snappy (200ms)
  static const fast = LiquidGlassTransitionConfig(
    duration: Duration(milliseconds: 200),
  );

  /// Preset: Normal speed (300ms) - Default
  static const normal = LiquidGlassTransitionConfig();

  /// Preset: Slow and elegant (450ms)
  static const slow = LiquidGlassTransitionConfig(
    duration: Duration(milliseconds: 450),
  );

  /// Preset: Bouncy elastic animation
  static const bouncy = LiquidGlassTransitionConfig(
    type: LiquidGlassTransitionType.elastic,
    duration: Duration(milliseconds: 600),
  );

  /// Preset: iOS-style scale animation
  static const iOS = LiquidGlassTransitionConfig(
    duration: Duration(milliseconds: 280),
  );

  /// Preset: Material-style fade animation
  static const material = LiquidGlassTransitionConfig(
    type: LiquidGlassTransitionType.fade,
    duration: Duration(milliseconds: 250),
  );
}

// ============================================================================
// CUSTOM CURVES
// ============================================================================

/// Apple's signature ease curve - smooth and natural.
///
/// This curve closely mimics the animation timing used in iOS/macOS.
class _AppleEaseCurve extends Curve {
  const _AppleEaseCurve();

  @override
  double transformInternal(double t) {
    // Attempt to replicate Apple's spring-like ease curve
    // Using a modified cubic bezier approximation
    final t2 = t * t;
    final t3 = t2 * t;
    return 3 * t2 - 2 * t3 + 0.5 * t3 * (1 - t);
  }
}

/// A spring curve with configurable parameters.
class LiquidGlassSpringCurve extends Curve {
  /// Creates a spring curve with the given parameters.
  const LiquidGlassSpringCurve({
    this.damping = 0.7,
    this.stiffness = 100,
  });

  /// Damping ratio (0-1). Lower = more bouncy.
  final double damping;

  /// Stiffness of the spring. Higher = faster.
  final double stiffness;

  @override
  double transformInternal(double t) {
    // Simplified spring physics approximation
    // Uses damping for decay calculation
    final decay = damping * 10;
    return 1 - (1 - t) * (1 + decay * t) * (1 - t).abs();
  }
}

// ============================================================================
// TRANSITION BUILDERS
// ============================================================================

/// Builds the appropriate transition widget for the given type.
///
/// This is the core function that creates animated transitions
/// for dialogs, snackbars, and other Liquid Glass widgets.
Widget buildLiquidGlassTransition({
  required BuildContext context,
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
  required LiquidGlassTransitionType type,
  Curve? curve,
  Alignment? alignment,
}) {
  final effectiveCurve =
      curve ?? LiquidGlassTransitionConfig._defaultCurveForType(type);
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: effectiveCurve,
  );

  switch (type) {
    case LiquidGlassTransitionType.none:
      return child;

    case LiquidGlassTransitionType.fade:
      return FadeTransition(
        opacity: curvedAnimation,
        child: child,
      );

    case LiquidGlassTransitionType.scale:
      return ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );

    case LiquidGlassTransitionType.scaleDown:
      // Apple's signature "scale down" appearance
      // Starts slightly larger and scales down to normal size
      return ScaleTransition(
        scale: Tween<double>(begin: 1.1, end: 1).animate(curvedAnimation),
        alignment: alignment ?? Alignment.center,
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 0.6, curve: Curves.easeOut),
            ),
          ),
          child: child,
        ),
      );

    case LiquidGlassTransitionType.slideUp:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );

    case LiquidGlassTransitionType.slideDown:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );

    case LiquidGlassTransitionType.slideLeft:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );

    case LiquidGlassTransitionType.slideRight:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );

    case LiquidGlassTransitionType.zoom:
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1).animate(curvedAnimation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 0.5, curve: Curves.easeOut),
            ),
          ),
          child: child,
        ),
      );

    case LiquidGlassTransitionType.elastic:
      return ScaleTransition(
        scale: Tween<double>(begin: 0.6, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
        ),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 0.3, curve: Curves.easeOut),
            ),
          ),
          child: child,
        ),
      );

    case LiquidGlassTransitionType.blur:
      // The blur effect is handled by the BackdropFilter in the widget itself
      // Here we just do a fade with scale
      return ScaleTransition(
        scale: Tween<double>(begin: 1.05, end: 1).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );
  }
}

// ============================================================================
// PAGE ROUTE TRANSITION
// ============================================================================

/// A custom page route with Liquid Glass transitions.
///
/// Use this for full-page navigation with beautiful transitions.
class LiquidGlassPageRoute<T> extends PageRouteBuilder<T> {
  /// Creates a Liquid Glass page route.
  LiquidGlassPageRoute({
    required this.page,
    this.transitionConfig = LiquidGlassTransitionConfig.normal,
    super.settings,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: transitionConfig.duration,
          reverseTransitionDuration: transitionConfig.effectiveReverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return buildLiquidGlassTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
              type: transitionConfig.type,
              curve: transitionConfig.curve,
            );
          },
        );

  /// The page widget to display.
  final Widget page;

  /// Configuration for the transition.
  final LiquidGlassTransitionConfig transitionConfig;
}

// ============================================================================
// ANIMATED OVERLAY CONTROLLER
// ============================================================================

/// A controller for managing animated overlay entries.
///
/// Used internally by snackbar and toast implementations.
class LiquidGlassOverlayController {
  /// Creates an overlay controller.
  LiquidGlassOverlayController({
    required this.vsync,
    required this.config,
  }) : _animationController = AnimationController(
          vsync: vsync,
          duration: config.duration,
          reverseDuration: config.effectiveReverseDuration,
        );

  /// The TickerProvider for animations.
  final TickerProvider vsync;

  /// The transition configuration.
  final LiquidGlassTransitionConfig config;

  /// The animation controller.
  final AnimationController _animationController;

  /// The current overlay entry.
  OverlayEntry? _overlayEntry;

  /// Whether the overlay is currently visible.
  bool get isVisible => _overlayEntry != null;

  /// The animation value (0.0 to 1.0).
  Animation<double> get animation => _animationController;

  /// Shows the overlay with animation.
  Future<void> show({
    required OverlayState overlay,
    required WidgetBuilder builder,
  }) async {
    // Remove existing if any
    await hide();

    _overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedOverlayWidget(
        animation: _animationController,
        config: config,
        child: builder(context),
      ),
    );

    overlay.insert(_overlayEntry!);
    await _animationController.forward();
  }

  /// Hides the overlay with animation.
  Future<void> hide() async {
    if (_overlayEntry == null) return;

    await _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Disposes the controller.
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController.dispose();
  }
}

/// Internal widget that wraps overlay content with animation.
class _AnimatedOverlayWidget extends StatelessWidget {
  const _AnimatedOverlayWidget({
    required this.animation,
    required this.config,
    required this.child,
  });

  final Animation<double> animation;
  final LiquidGlassTransitionConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return buildLiquidGlassTransition(
          context: context,
          animation: animation,
          secondaryAnimation: kAlwaysDismissedAnimation,
          child: child,
          type: config.type,
          curve: config.effectiveCurve,
        );
      },
    );
  }
}
