import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled BottomNavigationBar.
///
/// Provides a translucent, blurred bottom navigation bar that follows
/// Apple's Liquid Glass design language.
class LiquidGlassBottomNavigationBar extends StatefulWidget {
  /// Creates a Liquid Glass bottom navigation bar.
  const LiquidGlassBottomNavigationBar({
    required this.items,
    super.key,
    this.onTap,
    this.currentIndex = 0,
    this.elevation,
    this.type,
    this.fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = true,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.borderColor,
    this.showTopBorder = true,
    this.enablePillIndicator = true,
    this.pillColor,
  });

  final List<BottomNavigationBarItem> items;
  final ValueChanged<int>? onTap;
  final int currentIndex;
  final double? elevation;
  final BottomNavigationBarType? type;
  final Color? fixedColor;
  final Color? backgroundColor;
  final double iconSize;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final double selectedFontSize;
  final double unselectedFontSize;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool? showSelectedLabels;
  final bool? showUnselectedLabels;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final BottomNavigationBarLandscapeLayout? landscapeLayout;
  final bool useLegacyColorScheme;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? borderColor;
  final bool showTopBorder;
  final bool enablePillIndicator;
  final Color? pillColor;

  @override
  State<LiquidGlassBottomNavigationBar> createState() =>
      _LiquidGlassBottomNavigationBarState();
}

class _LiquidGlassBottomNavigationBarState
    extends State<LiquidGlassBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LiquidGlassBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final effectiveBlurSigma = widget.blurSigma ?? theme.blurSigma;

    // iOS 26 floating pill nav bar
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: effectiveBlurSigma,
              sigmaY: effectiveBlurSigma,
            ),
            child: CustomPaint(
              painter: _LiquidGlassNavBarPainter(isDark: isDark),
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(widget.items.length, (index) {
                    return _buildNavItem(context, index, isDark);
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, bool isDark) {
    final item = widget.items[index];
    final isSelected = index == widget.currentIndex;

    final selectedColor =
        widget.selectedItemColor ?? (isDark ? Colors.white : Colors.black);
    final unselectedColor = widget.unselectedItemColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.6)
            : Colors.black.withValues(alpha: 0.6));

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap?.call(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            // Selected item gets darker pill background (iOS 26 style)
            color: isSelected
                ? (isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.1))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  size: widget.iconSize,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
                child: isSelected ? item.activeIcon : item.icon,
              ),
              if ((widget.showSelectedLabels ?? true) ||
                  (widget.showUnselectedLabels ?? true)) ...[
                const SizedBox(height: 2),
                if ((isSelected && (widget.showSelectedLabels ?? true)) ||
                    (!isSelected && (widget.showUnselectedLabels ?? true)))
                  Text(
                    item.label ?? '',
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? selectedColor : unselectedColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for iOS 26 Liquid Glass navigation bar.
///
/// Renders the floating pill with:
/// - Subtle transparent base
/// - Liquid swirl texture
/// - Thin luminous white border
class _LiquidGlassNavBarPainter extends CustomPainter {
  _LiquidGlassNavBarPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(50));

    // Layer 1: Base fill
    // Fully transparent as requested
    final basePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas
      ..drawRRect(rrect, basePaint)

      // Layer 2: Liquid swirl effect
      ..save()
      ..clipRRect(rrect);

    // Create curved liquid swirl path
    final liquidPath = Path()
      ..moveTo(-size.width * 0.1, size.height * 0.7)
      ..cubicTo(
        size.width * 0.15,
        size.height * 0.3,
        size.width * 0.35,
        size.height * 0.1,
        size.width * 0.55,
        size.height * 0.2,
      )
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.3,
        size.width * 0.9,
        size.height * 0.5,
        size.width * 1.1,
        size.height * 0.3,
      )
      ..lineTo(size.width * 1.15, size.height * 0.6)
      ..cubicTo(
        size.width * 0.95,
        size.height * 0.8,
        size.width * 0.7,
        size.height * 0.6,
        size.width * 0.5,
        size.height * 0.7,
      )
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.8,
        size.width * 0.1,
        size.height * 0.9,
        -size.width * 0.05,
        size.height * 0.85,
      )
      ..close();

    final liquidGradient = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0),
        Colors.white
            .withValues(alpha: isDark ? 0.01 : 0.02), // Essentially invisible
        Colors.white
            .withValues(alpha: isDark ? 0.005 : 0.01), // Essentially invisible
        Colors.white.withValues(alpha: 0),
      ],
      stops: const [0.0, 0.35, 0.65, 1.0],
    );

    final liquidPaint = Paint()
      ..shader = liquidGradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas
      ..drawPath(liquidPath, liquidPaint)
      ..restore();

    // Layer 3: Thin luminous white border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final borderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: isDark ? 0.85 : 0.95),
        Colors.white.withValues(alpha: isDark ? 0.3 : 0.4),
        Colors.white.withValues(alpha: isDark ? 0.2 : 0.3),
        Colors.white.withValues(alpha: isDark ? 0.7 : 0.8),
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );
    borderPaint.shader = borderGradient.createShader(rect);

    canvas.drawRRect(rrect, borderPaint);

    // Layer 4: Inner Glow (Inset)
    final innerGlowPaint = Paint()
      ..color = Colors.white
          .withValues(alpha: isDark ? 0.02 : 0.04) // Drastically reduced
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final innerRect = rrect.deflate(1);
    canvas.drawRRect(innerRect, innerGlowPaint);
  }

  @override
  bool shouldRepaint(covariant _LiquidGlassNavBarPainter oldDelegate) {
    return isDark != oldDelegate.isDark;
  }
}

/// A Liquid Glass styled NavigationBar (Material 3).
class LiquidGlassNavigationBar extends StatelessWidget {
  /// Creates a Liquid Glass navigation bar.
  const LiquidGlassNavigationBar({
    required this.destinations,
    super.key,
    this.animationDuration,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.indicatorColor,
    this.indicatorShape,
    this.height,
    this.labelBehavior,
    this.overlayColor,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.borderColor,
    this.showTopBorder = true,
  });

  final Duration? animationDuration;
  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final ValueChanged<int>? onDestinationSelected;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final double? height;
  final NavigationDestinationLabelBehavior? labelBehavior;
  final WidgetStateProperty<Color?>? overlayColor;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? borderColor;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma;
    final effectiveOpacity = glassOpacity ?? theme.opacity * 0.8;
    final effectiveBackgroundColor = backgroundColor ??
        (brightness == Brightness.light
            ? Colors.white
            : Colors.black.withValues(alpha: 0.5));
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor.withValues(alpha: effectiveOpacity),
            border: showTopBorder
                ? Border(
                    top: BorderSide(
                      color: effectiveBorderColor,
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          child: NavigationBar(
            animationDuration: animationDuration,
            selectedIndex: selectedIndex,
            destinations: destinations,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: shadowColor,
            surfaceTintColor: Colors.transparent,
            indicatorColor: indicatorColor,
            indicatorShape: indicatorShape,
            height: height,
            labelBehavior: labelBehavior,
            overlayColor: overlayColor,
          ),
        ),
      ),
    );
  }
}
