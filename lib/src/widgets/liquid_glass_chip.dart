import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_glacier/src/theme/liquid_glass_theme.dart';

/// A Liquid Glass styled Chip.
///
/// Provides a translucent, blurred chip that follows
/// Apple's Liquid Glass design language.
class LiquidGlassChip extends StatefulWidget {
  /// Creates a Liquid Glass chip.
  const LiquidGlassChip({
    required this.label,
    super.key,
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.deleteIcon,
    this.onDeleted,
    this.deleteIconColor,
    this.deleteButtonTooltipMessage,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    // Liquid Glass properties
    this.blurSigma,
    this.glassOpacity,
    this.tintColor,
    this.borderColor,
    this.enableGlow = false,
    this.glowColor,
    this.onTap,
    this.selected = false,
    this.selectedColor,
  });

  final Widget? avatar;
  final Widget label;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Widget? deleteIcon;
  final VoidCallback? onDeleted;
  final Color? deleteIconColor;
  final String? deleteButtonTooltipMessage;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final IconThemeData? iconTheme;

  // Liquid Glass properties
  final double? blurSigma;
  final double? glassOpacity;
  final Color? tintColor;
  final Color? borderColor;
  final bool enableGlow;
  final Color? glowColor;
  final VoidCallback? onTap;
  final bool selected;
  final Color? selectedColor;

  @override
  State<LiquidGlassChip> createState() => _LiquidGlassChipState();
}

class _LiquidGlassChipState extends State<LiquidGlassChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveBlurSigma = widget.blurSigma ?? theme.blurSigma * 0.8;
    final effectiveOpacity = widget.glassOpacity ?? theme.opacity;
    final effectiveTintColor = widget.tintColor ?? theme.tintColor;
    final effectiveBorderColor =
        widget.borderColor ?? theme.effectiveBorderColor;
    final effectiveSelectedColor =
        widget.selectedColor ?? colorScheme.primaryContainer;
    final effectiveGlowColor = widget.glowColor ?? colorScheme.primary;

    final borderRadius = BorderRadius.circular(20);

    final Widget chip = MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: widget.enableGlow && (_isHovered || widget.selected)
                    ? [
                        BoxShadow(
                          color: effectiveGlowColor.withValues(alpha: 0.2),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: effectiveBlurSigma,
                    sigmaY: effectiveBlurSigma,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: widget.selected
                          ? effectiveSelectedColor.withValues(alpha: 0.4)
                          : effectiveTintColor.withValues(
                              alpha: _isHovered
                                  ? effectiveOpacity * 1.3
                                  : effectiveOpacity,
                            ),
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: widget.selected
                            ? effectiveGlowColor.withValues(alpha: 0.5)
                            : effectiveBorderColor,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.avatar != null) ...[
                          widget.avatar!,
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: DefaultTextStyle(
                            style: widget.labelStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: widget.selected
                                          ? colorScheme.onPrimaryContainer
                                          : null,
                                    ),
                            child: widget.label,
                          ),
                        ),
                        if (widget.onDeleted != null) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onDeleted,
                            child: widget.deleteIcon ??
                                Icon(
                                  Icons.close,
                                  size: 18,
                                  color: widget.deleteIconColor ??
                                      colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    return chip;
  }
}

/// A Liquid Glass styled FilterChip.
class LiquidGlassFilterChip extends StatelessWidget {
  /// Creates a Liquid Glass filter chip.
  const LiquidGlassFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
    this.avatar,
    this.labelStyle,
    this.blurSigma,
    this.glassOpacity,
    this.selectedColor,
    this.checkmarkColor,
    this.showCheckmark = true,
  });

  final Widget? avatar;
  final Widget label;
  final TextStyle? labelStyle;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final double? blurSigma;
  final double? glassOpacity;
  final Color? selectedColor;
  final Color? checkmarkColor;
  final bool showCheckmark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LiquidGlassChip(
      avatar: selected && showCheckmark
          ? Icon(
              Icons.check,
              size: 18,
              color: checkmarkColor ?? colorScheme.primary,
            )
          : avatar,
      label: label,
      labelStyle: labelStyle,
      selected: selected,
      selectedColor: selectedColor,
      enableGlow: true,
      blurSigma: blurSigma,
      glassOpacity: glassOpacity,
      onTap: () => onSelected(!selected),
    );
  }
}

/// A Liquid Glass styled ChoiceChip.
class LiquidGlassChoiceChip extends StatelessWidget {
  /// Creates a Liquid Glass choice chip.
  const LiquidGlassChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
    this.avatar,
    this.labelStyle,
    this.blurSigma,
    this.glassOpacity,
    this.selectedColor,
  });

  final Widget? avatar;
  final Widget label;
  final TextStyle? labelStyle;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final double? blurSigma;
  final double? glassOpacity;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassChip(
      avatar: avatar,
      label: label,
      labelStyle: labelStyle,
      selected: selected,
      selectedColor: selectedColor,
      enableGlow: true,
      blurSigma: blurSigma,
      glassOpacity: glassOpacity,
      onTap: () => onSelected(!selected),
    );
  }
}

/// A Liquid Glass styled InputChip.
class LiquidGlassInputChip extends StatelessWidget {
  /// Creates a Liquid Glass input chip.
  const LiquidGlassInputChip({
    required this.label,
    super.key,
    this.avatar,
    this.labelStyle,
    this.onDeleted,
    this.deleteIcon,
    this.onTap,
    this.selected = false,
    this.blurSigma,
    this.glassOpacity,
    this.selectedColor,
  });

  final Widget? avatar;
  final Widget label;
  final TextStyle? labelStyle;
  final VoidCallback? onDeleted;
  final Widget? deleteIcon;
  final VoidCallback? onTap;
  final bool selected;
  final double? blurSigma;
  final double? glassOpacity;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassChip(
      avatar: avatar,
      label: label,
      labelStyle: labelStyle,
      onDeleted: onDeleted,
      deleteIcon: deleteIcon,
      selected: selected,
      selectedColor: selectedColor,
      blurSigma: blurSigma,
      glassOpacity: glassOpacity,
      onTap: onTap,
    );
  }
}
