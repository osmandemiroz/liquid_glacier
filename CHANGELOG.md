## 0.0.2

### New Features

*   **New Widget:** `LiquidGlassSnackBar` - Beautiful snackbar with glass effect and smooth animated transitions.
*   **Animated Transitions:** Added `LiquidGlassTransitionType` enum with 11 transition types:
    - `fade`, `scale`, `scaleDown` (iOS-style), `slideUp`, `slideDown`, `slideLeft`, `slideRight`, `zoom`, `elastic`, `blur`, `none`
*   **Transition Configuration:** Added `LiquidGlassTransitionConfig` for fine-tuned animation control with presets (`.iOS`, `.bouncy`, `.fast`, `.slow`, `.normal`).
*   **Enhanced Dialog:** `showLiquidGlassDialog` now supports custom transitions via `transitionType` and `transitionDuration` parameters.
*   **Confirmation Dialog:** Added `showLiquidGlassConfirmDialog` helper for quick yes/no dialogs with destructive styling option.
*   **Snackbar Positioning:** Added `LiquidGlassSnackBarPosition` enum for top or bottom placement.
*   **Snackbar Types:** Added `LiquidGlassSnackBarType` enum (info, success, warning, error, neutral) with Apple-inspired accent colors.

### Improvements

*   Snackbars now use an overlay-based system for full animation control.
*   Added `hideLiquidGlassSnackBar()` function for programmatic dismissal.
*   Added `LiquidGlassSnackBarContent` widget for custom snackbar content.
*   Updated example app with comprehensive transition demonstrations.

## 0.0.1

*   **New Widget:** Added `LiquidGlassRadioButton` for glass-styled radio selection.
*   **Enhancement:** `LiquidGlassBottomNavigationBar` now features a fluid "waterwall bubble" sliding pill animation.
*   **Standardization:** Unified Liquid Glass effects (opacity, blur, adaptive tint) across `LiquidGlassButton`, `LiquidGlassTextField`, and `LiquidGlassBottomNavigationBar` to match `LiquidGlassContainer`.
*   **Fix:** Resolved linter errors related to `ThemeData` brightness access.
*   **Docs:** Updated README with new widget details and screenshots.
