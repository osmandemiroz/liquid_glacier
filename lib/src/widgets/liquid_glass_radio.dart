import 'package:flutter/material.dart';
import 'package:liquid_glacier/liquid_glacier.dart';

/// A radio button that follows the Liquid Glass design language.
///
/// This widget creates a radio button with a glassmorphic appearance,
/// featuring a translucent outer circle and a filled inner circle when selected.
class LiquidGlassRadioButton<T> extends StatelessWidget {
  /// Creates a [LiquidGlassRadioButton].
  const LiquidGlassRadioButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.tintColor,
    this.activeColor,
    this.size = 24.0,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback.
  /// The radio button does not actually change state until the parent
  /// widget rebuilds the radio button with the new [groupValue].
  final ValueChanged<T?>? onChanged;

  /// The tint color of the glass effect.
  ///
  /// If null, defaults to [LiquidGlassThemeData.tintColor].
  final Color? tintColor;

  /// The color to use when this radio button is selected.
  ///
  /// If null, defaults to [ThemeData.primaryColor] or a white color depending on brightness.
  final Color? activeColor;

  /// The size of the radio button.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidGlassTheme.of(context);
    final isSelected = value == groupValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveActiveColor =
        activeColor ?? (isDark ? Colors.white : Theme.of(context).primaryColor);

    return GestureDetector(
      onTap: () {
        onChanged?.call(value);
      },
      behavior: HitTestBehavior.opaque,
      child: LiquidGlassContainer(
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(size / 2),
        padding: EdgeInsets.zero,
        tintColor: tintColor ?? theme.tintColor,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: isSelected ? size * 0.5 : 0,
            height: isSelected ? size * 0.5 : 0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: effectiveActiveColor,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: effectiveActiveColor.withValues(alpha: 0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
