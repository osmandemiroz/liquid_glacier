# Liquid Glacier 🧊

A Flutter package that applies Apple's **Liquid Glass** design language to Material widgets. Features translucent surfaces, dynamic blur effects, subtle reflections, and depth-based layering.

[![pub package](https://img.shields.io/pub/v/liquid_glacier.svg)](https://pub.dev/packages/liquid_glacier)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub](https://img.shields.io/github/stars/osmandemiroz/liquid_glacier?style=social)](https://github.com/osmandemiroz/liquid_glacier)

**Author:** [Osman Demiröz](https://github.com/osmandemiroz)

## ✨ Features

- 🔮 **Translucent Surfaces** - Frosted glass effect using `BackdropFilter`
- 🎨 **Dynamic Blur** - Configurable blur intensity (sigma 5-25)
- ✨ **Subtle Reflections** - Gradient overlays for glass-like highlights
- 📐 **Depth & Layering** - Multi-layer shadows for visual depth
- 🎭 **Smooth Animations** - Hover, press, and focus state animations
- 🌓 **Light/Dark Mode** - Auto-adapts to theme brightness

## 📸 Screenshots

<p align="center">
  <img src="example/assets/screenshots/screenshot1.png" width="19%" alt="Screenshot 1" />
  <img src="example/assets/screenshots/screenshot2.png" width="19%" alt="Screenshot 2" />
  <img src="example/assets/screenshots/screenshot3.png" width="19%" alt="Screenshot 3" />
  <img src="example/assets/screenshots/screenshot4.png" width="19%" alt="Screenshot 4" />
  <img src="example/assets/screenshots/screenshot5.png" width="19%" alt="Screenshot 5" />
</p>

## 📦 Installation

```yaml
dependencies:
  liquid_glacier: ^0.0.1
```

## 🚀 Quick Start

Wrap your app with `LiquidGlassTheme` to configure the global glass effect:

```dart
import 'package:liquid_glacier/liquid_glacier.dart';

void main() {
  runApp(
    LiquidGlassTheme(
      data: LiquidGlassThemeData(
        blurSigma: 12.0,
        opacity: 0.2,
        tintColor: Colors.white,
      ),
      child: MaterialApp(
        home: MyHomePage(),
      ),
    ),
  );
}
```

## 🧩 Available Widgets

| Widget | Description |
|--------|-------------|
| `LiquidGlassAppBar` | Translucent app bar with blur |
| `LiquidGlassCard` | Frosted glass card with hover effects |
| `LiquidGlassButton` | Button with glow on press |
| `LiquidGlassElevatedButton` | Elevated button variant |
| `LiquidGlassTextButton` | Text button variant |
| `LiquidGlassOutlinedButton` | Outlined button variant |
| `LiquidGlassIconButton` | Icon button with glass effect |
| `LiquidGlassRadioButton` | Radio button with glass selection |
| `LiquidGlassTextField` | Input field with focus glow |
| `LiquidGlassBottomNavigationBar` | Bottom nav with floating pill indicator |
| `LiquidGlassNavigationBar` | Material 3 navigation bar |
| `LiquidGlassDialog` | Dialog with frosted background |
| `LiquidGlassAlertDialog` | Alert dialog variant |
| `LiquidGlassChip` | Chip with selection glow |
| `LiquidGlassFilterChip` | Filter chip variant |
| `LiquidGlassNavigationRail` | Side navigation rail |
| `LiquidGlassTabBar` | Tab bar with pill indicator |
| `LiquidGlassSegmentedTabBar` | Segmented control style |
| `LiquidGlassFAB` | FAB with glow effect |
| `LiquidGlassDrawer` | Drawer with blur |
| `LiquidGlassContainer` | Base glass container |

## 🎨 Theme Configuration

```dart
LiquidGlassThemeData(
  blurSigma: 10.0,          // Blur intensity (5-25)
  opacity: 0.15,            // Glass opacity (0.0-1.0)
  borderRadius: BorderRadius.circular(16),
  tintColor: Colors.white,  // Glass tint
  reflectionColor: Colors.white,
  animationDuration: Duration(milliseconds: 200),
  enableReflection: true,   // Gradient overlay
  enableShadow: true,       // Depth shadows
  borderWidth: 0.5,
  borderColor: Colors.white.withOpacity(0.3),
)
```

## 📱 Examples

### Glass Card

```dart
LiquidGlassCard(
  onTap: () => print('Tapped!'),
  child: Padding(
    padding: EdgeInsets.all(20),
    child: Text('Glass Card'),
  ),
)
```

### Glass Radio Button

```dart
LiquidGlassRadioButton<int>(
  value: 1,
  groupValue: selectedValue,
  onChanged: (val) => setState(() => selectedValue = val),
  glassColor: Colors.blue,
  label: Text('Option 1'),
)
```

### Glass Button

```dart
LiquidGlassElevatedButton(
  onPressed: () {},
  icon: Icon(Icons.send),
  child: Text('Send'),
)
```

### Glass App Bar

```dart
Scaffold(
  appBar: LiquidGlassAppBar(
    title: Text('My App'),
    actions: [
      LiquidGlassIconButton(
        icon: Icon(Icons.settings),
        onPressed: () {},
      ),
    ],
  ),
  body: ...,
)
```

### Glass Dialog

```dart
showLiquidGlassDialog(
  context: context,
  builder: (context) => LiquidGlassAlertDialog(
    icon: Icon(Icons.check_circle),
    title: Text('Success'),
    content: Text('Operation completed.'),
    actions: [
      LiquidGlassTextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
      ),
    ],
  ),
);
```

## 🎯 Best Practices

1. **Use over vibrant backgrounds** - Glass effect shines over images/gradients
2. **Keep opacity low** - 0.1-0.3 works best for readability
3. **Moderate blur** - Sigma 8-15 balances effect and performance
4. **Test on devices** - BackdropFilter can be expensive on older devices

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.
