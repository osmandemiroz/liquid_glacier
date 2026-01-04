import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled AppBar.
///
/// Provides a translucent, blurred app bar that applies Apple's
/// Liquid Glass design language.
class LiquidGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a Liquid Glass app bar.
  const LiquidGlassAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
    this.borderColor,
  });

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;

  // Liquid Glass specific properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? tintColor;
  final Color? borderColor;

  @override
  Size get preferredSize => Size.fromHeight(
        (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma;
    final effectiveOpacity = glassOpacity ?? theme.opacity * 0.8;
    final effectiveTintColor = tintColor ??
        (brightness == Brightness.light
            ? Colors.white
            : Colors.black.withAlpha(128));
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveTintColor.withAlpha(effectiveOpacity as int),
            border: Border(
              bottom: BorderSide(
                color: effectiveBorderColor,
                width: 0.5,
              ),
            ),
          ),
          child: AppBar(
            leading: leading,
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: title,
            actions: actions,
            flexibleSpace: flexibleSpace,
            bottom: bottom,
            elevation: 0,
            scrolledUnderElevation: 0,
            shadowColor: shadowColor,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shape: shape,
            iconTheme: iconTheme,
            actionsIconTheme: actionsIconTheme,
            primary: primary,
            centerTitle: centerTitle,
            excludeHeaderSemantics: excludeHeaderSemantics,
            titleSpacing: titleSpacing,
            toolbarOpacity: toolbarOpacity,
            bottomOpacity: bottomOpacity,
            toolbarHeight: toolbarHeight,
            leadingWidth: leadingWidth,
            toolbarTextStyle: toolbarTextStyle,
            titleTextStyle: titleTextStyle,
            systemOverlayStyle: systemOverlayStyle,
            forceMaterialTransparency: true,
            clipBehavior: clipBehavior,
          ),
        ),
      ),
    );
  }
}

/// A sliver version of [LiquidGlassAppBar] for use in CustomScrollView.
class LiquidGlassSliverAppBar extends StatelessWidget {
  /// Creates a sliver Liquid Glass app bar.
  const LiquidGlassSliverAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.forceElevated = false,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.expandedHeight,
    this.collapsedHeight,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
  });

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool forceElevated;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double? expandedHeight;
  final double? collapsedHeight;
  final double toolbarHeight;
  final double? leadingWidth;
  final bool floating;
  final bool pinned;
  final bool snap;
  final bool stretch;
  final double stretchTriggerOffset;
  final AsyncCallback? onStretchTrigger;
  final ShapeBorder? shape;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;

  // Liquid Glass specific properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma;
    final effectiveOpacity = glassOpacity ?? theme.opacity * 0.8;
    final effectiveTintColor = tintColor ??
        (brightness == Brightness.light
            ? Colors.white
            : Colors.black.withAlpha(128));

    return SliverAppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlurSigma,
            sigmaY: effectiveBlurSigma,
          ),
          child: ColoredBox(
            color: effectiveTintColor.withAlpha(effectiveOpacity as int),
            child: flexibleSpace,
          ),
        ),
      ),
      bottom: bottom,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: shadowColor,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      forceElevated: forceElevated,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      floating: floating,
      pinned: pinned,
      snap: snap,
      stretch: stretch,
      stretchTriggerOffset: stretchTriggerOffset,
      onStretchTrigger: onStretchTrigger,
      shape: shape,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: true,
      clipBehavior: clipBehavior,
    );
  }
}
