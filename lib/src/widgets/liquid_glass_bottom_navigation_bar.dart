import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/core/liquid_glass_container.dart';
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

    // Calculate alignment for the sliding pill
    var alignmentValue = 0.0;
    if (widget.items.length > 1) {
      alignmentValue =
          -1.0 + (widget.currentIndex * 2.0 / (widget.items.length - 1));
    }

    // iOS 26 floating pill nav bar
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: LiquidGlassContainer(
          borderRadius: BorderRadius.circular(50),
          blurSigma: effectiveBlurSigma,
          // LiquidGlassContainer handles opacity and tint automatically based on theme
          // but we can pass overrides if needed to match the old logic exactly,
          // however the goal is standardization, so purely using the container is best.
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Stack(
              children: [
                // Sliding Pill Indicator
                AnimatedAlign(
                  alignment: Alignment(alignmentValue, 0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  child: FractionallySizedBox(
                    widthFactor: 1 / widget.items.length,
                    heightFactor: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                // Navigation Items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(widget.items.length, (index) {
                    return _buildNavItem(context, index, isDark);
                  }),
                ),
              ],
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          // Background is now handled by the sliding pill in the parent Stack
          decoration: BoxDecoration(
            color: Colors.transparent,
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
