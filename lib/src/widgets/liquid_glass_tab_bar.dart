import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled TabBar.
///
/// Provides a translucent, blurred tab bar that follows
/// Apple's Liquid Glass design language.
class LiquidGlassTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a Liquid Glass tab bar.
  const LiquidGlassTabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
    this.textScaler,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
    this.borderColor,
    this.usePillIndicator = true,
    this.pillColor,
    this.pillBorderRadius,
  });

  final List<Widget> tabs;
  final TabController? controller;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final bool automaticIndicatorColorAdjustment;
  final double indicatorWeight;
  final EdgeInsetsGeometry indicatorPadding;
  final Decoration? indicator;
  final TabBarIndicatorSize? indicatorSize;
  final Color? dividerColor;
  final double? dividerHeight;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Color? unselectedLabelColor;
  final TextStyle? unselectedLabelStyle;
  final DragStartBehavior dragStartBehavior;
  final WidgetStateProperty<Color?>? overlayColor;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final ValueChanged<int>? onTap;
  final ScrollPhysics? physics;
  final InteractiveInkFeatureFactory? splashFactory;
  final BorderRadius? splashBorderRadius;
  final TabAlignment? tabAlignment;
  final TextScaler? textScaler;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? tintColor;
  final Color? borderColor;
  final bool usePillIndicator;
  final Color? pillColor;
  final BorderRadius? pillBorderRadius;

  @override
  Size get preferredSize => const Size.fromHeight(46);

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma;
    final effectiveOpacity = glassOpacity ?? theme.opacity;
    final effectiveTintColor = tintColor ?? theme.tintColor;
    final effectivePillColor = pillColor ?? colorScheme.primaryContainer;
    final effectivePillBorderRadius =
        pillBorderRadius ?? BorderRadius.circular(20);

    Decoration? effectiveIndicator;
    if (usePillIndicator) {
      effectiveIndicator = BoxDecoration(
        color: effectivePillColor.withValues(alpha: 0.4),
        borderRadius: effectivePillBorderRadius,
      );
    } else {
      effectiveIndicator = indicator;
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveTintColor.withValues(alpha: effectiveOpacity * 0.5),
          ),
          child: TabBar(
            tabs: tabs,
            controller: controller,
            isScrollable: isScrollable,
            padding: padding,
            indicatorColor: indicatorColor,
            automaticIndicatorColorAdjustment:
                automaticIndicatorColorAdjustment,
            indicatorWeight: usePillIndicator ? 0 : indicatorWeight,
            indicatorPadding:
                indicatorPadding.add(const EdgeInsets.symmetric(horizontal: 4)),
            indicator: effectiveIndicator,
            indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
            dividerColor: dividerColor ?? Colors.transparent,
            dividerHeight: dividerHeight ?? 0,
            labelColor: labelColor,
            labelStyle: labelStyle,
            labelPadding: labelPadding,
            unselectedLabelColor: unselectedLabelColor,
            unselectedLabelStyle: unselectedLabelStyle,
            dragStartBehavior: dragStartBehavior,
            overlayColor:
                overlayColor ?? WidgetStateProperty.all(Colors.transparent),
            mouseCursor: mouseCursor,
            enableFeedback: enableFeedback,
            onTap: onTap,
            physics: physics,
            splashFactory: splashFactory ?? NoSplash.splashFactory,
            splashBorderRadius: splashBorderRadius,
            tabAlignment: tabAlignment,
            textScaler: textScaler,
          ),
        ),
      ),
    );
  }
}

/// A Liquid Glass styled TabBar with a segmented control appearance.
class LiquidGlassSegmentedTabBar extends StatefulWidget {
  /// Creates a Liquid Glass segmented tab bar.
  const LiquidGlassSegmentedTabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.onTap,
    this.blurSigma,
    this.glassOpacity,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.height = 36,
  });

  final List<Widget> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final double? blurSigma;
  final double? glassOpacity;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double height;

  @override
  State<LiquidGlassSegmentedTabBar> createState() =>
      _LiquidGlassSegmentedTabBarState();
}

class _LiquidGlassSegmentedTabBarState
    extends State<LiquidGlassSegmentedTabBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleTabChange);
    _selectedIndex = widget.controller?.index ?? 0;
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.controller != null) {
      setState(() {
        _selectedIndex = widget.controller!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveBlurSigma = widget.blurSigma ?? theme.blurSigma * 0.8;
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(10);
    final effectiveBackgroundColor =
        widget.backgroundColor ?? theme.tintColor.withValues(alpha: 0.1);
    final effectiveSelectedColor = widget.selectedColor ?? colorScheme.surface;

    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlurSigma,
            sigmaY: effectiveBlurSigma,
          ),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              borderRadius: effectiveBorderRadius,
              border: Border.all(
                color: theme.effectiveBorderColor,
                width: 0.5,
              ),
            ),
            child: Row(
              children: List.generate(widget.tabs.length, (index) {
                final isSelected = index == _selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      widget.controller?.animateTo(index);
                      widget.onTap?.call(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? effectiveSelectedColor
                            : Colors.transparent,
                        borderRadius: effectiveBorderRadius.subtract(
                          BorderRadius.circular(2),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: DefaultTextStyle(
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurfaceVariant,
                                  ),
                          child: widget.tabs[index],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
