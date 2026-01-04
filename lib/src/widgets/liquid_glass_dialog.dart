import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled Dialog.
///
/// Provides a translucent, blurred dialog that follows
/// Apple's Liquid Glass design language.
class LiquidGlassDialog extends StatelessWidget {
  /// Creates a Liquid Glass dialog.
  const LiquidGlassDialog({
    super.key,
    this.child,
    this.title,
    this.content,
    this.actions,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.semanticLabel,
    this.insetPadding,
    this.clipBehavior = Clip.antiAlias,
    this.shape,
    this.alignment,
    this.scrollable = false,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.tintColor,
    this.borderColor,
    this.maxWidth,
    this.enableBackgroundBlur = true,
  });

  final Widget? child;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final OverflowBarAlignment? actionsOverflowAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final String? semanticLabel;
  final EdgeInsets? insetPadding;
  final Clip clipBehavior;
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final bool scrollable;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final Color? borderColor;
  final double? maxWidth;
  final bool enableBackgroundBlur;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final brightness = Theme.of(context).brightness;

    final effectiveBlurSigma = blurSigma ?? theme.blurSigma * 1.5;
    final effectiveOpacity = glassOpacity ?? theme.opacity * 1.2;
    final effectiveBorderRadius = borderRadius ?? theme.borderRadius;
    final effectiveTintColor = tintColor ??
        (brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF2C2C2E));
    final effectiveBorderColor = borderColor ?? theme.effectiveBorderColor;

    Widget dialogContent;

    if (child != null) {
      dialogContent = child!;
    } else {
      dialogContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: titlePadding ?? const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headlineSmall!,
                textAlign: TextAlign.center,
                child: title!,
              ),
            ),
          if (content != null)
            Flexible(
              child: SingleChildScrollView(
                padding:
                    contentPadding ?? const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: content,
              ),
            ),
          if (actions != null && actions!.isNotEmpty)
            Padding(
              padding: actionsPadding ?? const EdgeInsets.all(16),
              child: OverflowBar(
                alignment: actionsAlignment ?? MainAxisAlignment.end,
                overflowAlignment:
                    actionsOverflowAlignment ?? OverflowBarAlignment.end,
                overflowDirection:
                    actionsOverflowDirection ?? VerticalDirection.down,
                spacing: 8,
                overflowSpacing: actionsOverflowButtonSpacing ?? 8,
                children: actions!,
              ),
            ),
        ],
      );
    }

    final Widget dialog = ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlurSigma,
          sigmaY: effectiveBlurSigma,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? 560,
            minWidth: 280,
          ),
          decoration: BoxDecoration(
            color: effectiveTintColor.withValues(alpha: effectiveOpacity),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: effectiveBorderColor,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: dialogContent,
        ),
      ),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: insetPadding ??
          const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      clipBehavior: Clip.none,
      alignment: alignment,
      child: dialog,
    );
  }
}

/// Shows a Liquid Glass dialog.
Future<T?> showLiquidGlassDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) {
  return showDialog<T>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black26,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    traversalEdgeBehavior: traversalEdgeBehavior,
  );
}

/// A Liquid Glass styled AlertDialog.
class LiquidGlassAlertDialog extends StatelessWidget {
  /// Creates a Liquid Glass alert dialog.
  const LiquidGlassAlertDialog({
    super.key,
    this.icon,
    this.iconPadding,
    this.iconColor,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding,
    this.contentTextStyle,
    this.actions,
    this.actionsPadding,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.semanticLabel,
    this.scrollable = false,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.borderRadius,
    this.tintColor,
    this.borderColor,
  });

  final Widget? icon;
  final EdgeInsetsGeometry? iconPadding;
  final Color? iconColor;
  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final Widget? content;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? contentTextStyle;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final OverflowBarAlignment? actionsOverflowAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final String? semanticLabel;
  final bool scrollable;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassDialog(
      blurSigma: blurSigma,
      glassOpacity: glassOpacity,
      borderRadius: borderRadius,
      tintColor: tintColor,
      borderColor: borderColor,
      title: Column(
        children: [
          if (icon != null)
            Padding(
              padding: iconPadding ?? const EdgeInsets.only(bottom: 16),
              child: IconTheme(
                data: IconThemeData(
                  color: iconColor ?? Theme.of(context).colorScheme.secondary,
                  size: 32,
                ),
                child: icon!,
              ),
            ),
          if (title != null)
            DefaultTextStyle(
              style:
                  titleTextStyle ?? Theme.of(context).textTheme.headlineSmall!,
              textAlign: TextAlign.center,
              child: title!,
            ),
        ],
      ),
      content: content != null
          ? DefaultTextStyle(
              style:
                  contentTextStyle ?? Theme.of(context).textTheme.bodyMedium!,
              textAlign: TextAlign.center,
              child: content!,
            )
          : null,
      actions: actions,
      actionsPadding: actionsPadding,
      actionsAlignment: actionsAlignment,
      actionsOverflowAlignment: actionsOverflowAlignment,
      actionsOverflowDirection: actionsOverflowDirection,
      actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
      scrollable: scrollable,
    );
  }
}
