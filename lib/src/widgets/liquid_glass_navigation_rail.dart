import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled NavigationRail.
///
/// Provides a translucent, blurred side navigation rail that follows
/// Apple's Liquid Glass design language.
class LiquidGlassNavigationRail extends StatelessWidget {
  /// Creates a Liquid Glass navigation rail.
  const LiquidGlassNavigationRail({
    required this.destinations,
    required this.selectedIndex,
    super.key,
    this.backgroundColor,
    this.extended = false,
    this.leading,
    this.trailing,
    this.onDestinationSelected,
    this.elevation,
    this.groupAlignment,
    this.labelType,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.minWidth,
    this.minExtendedWidth,
    this.useIndicator,
    this.indicatorColor,
    this.indicatorShape,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.borderColor,
    this.showRightBorder = true,
  });

  final Color? backgroundColor;
  final bool extended;
  final Widget? leading;
  final Widget? trailing;
  final List<NavigationRailDestination> destinations;
  final int? selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final double? elevation;
  final double? groupAlignment;
  final NavigationRailLabelType? labelType;
  final TextStyle? unselectedLabelTextStyle;
  final TextStyle? selectedLabelTextStyle;
  final IconThemeData? unselectedIconTheme;
  final IconThemeData? selectedIconTheme;
  final double? minWidth;
  final double? minExtendedWidth;
  final bool? useIndicator;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? borderColor;
  final bool showRightBorder;

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
            border: showRightBorder
                ? Border(
                    right: BorderSide(
                      color: effectiveBorderColor,
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          child: NavigationRail(
            backgroundColor: Colors.transparent,
            extended: extended,
            leading: leading,
            trailing: trailing,
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            elevation: 0,
            groupAlignment: groupAlignment,
            labelType: labelType,
            unselectedLabelTextStyle: unselectedLabelTextStyle,
            selectedLabelTextStyle: selectedLabelTextStyle,
            unselectedIconTheme: unselectedIconTheme,
            selectedIconTheme: selectedIconTheme,
            minWidth: minWidth,
            minExtendedWidth: minExtendedWidth,
            useIndicator: useIndicator ?? true,
            indicatorColor: indicatorColor,
            indicatorShape: indicatorShape,
          ),
        ),
      ),
    );
  }
}
