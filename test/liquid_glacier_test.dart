import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glacier/liquid_glacier.dart';

void main() {
  group('LiquidGlassTheme', () {
    testWidgets('provides default theme data', (WidgetTester tester) async {
      late LiquidGlassThemeData themeData;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              themeData = LiquidGlassTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(themeData.blurSigma, 10.0);
      expect(themeData.opacity, 0.15);
      expect(themeData.enableReflection, true);
      expect(themeData.enableShadow, true);
    });

    testWidgets('inherits custom theme data', (WidgetTester tester) async {
      late LiquidGlassThemeData themeData;

      await tester.pumpWidget(
        MaterialApp(
          home: LiquidGlassTheme(
            data: const LiquidGlassThemeData(
              blurSigma: 20,
              opacity: 0.3,
              enableReflection: false,
            ),
            child: Builder(
              builder: (context) {
                themeData = LiquidGlassTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(themeData.blurSigma, 20.0);
      expect(themeData.opacity, 0.3);
      expect(themeData.enableReflection, false);
    });
  });

  group('LiquidGlassContainer', () {
    testWidgets('renders with blur effect', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidGlassContainer(
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(LiquidGlassContainer), findsOneWidget);
    });
  });

  group('LiquidGlassCard', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidGlassCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(LiquidGlassCard), findsOneWidget);
    });

    testWidgets('handles tap callback', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidGlassCard(
              onTap: () => tapped = true,
              child: const Text('Tappable Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LiquidGlassCard));
      await tester.pump();

      expect(tapped, true);
    });
  });

  group('LiquidGlassButton', () {
    testWidgets('renders with child', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidGlassButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
          ),
        ),
      );

      expect(find.text('Button'), findsOneWidget);
    });

    testWidgets('handles tap when enabled', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidGlassButton(
              onPressed: () => pressed = true,
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LiquidGlassButton));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('is disabled when onPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidGlassButton(
              onPressed: null,
              child: Text('Disabled'),
            ),
          ),
        ),
      );

      expect(find.text('Disabled'), findsOneWidget);
    });
  });
}
