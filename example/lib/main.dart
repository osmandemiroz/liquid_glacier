import 'package:flutter/material.dart';
import 'package:liquid_glacier/liquid_glacier.dart';

void main() {
  runApp(const LiquidGlassExampleApp());
}

// ============================================================================
// ROOT APP WIDGET
// ============================================================================
// Holds the MaterialApp at the top level so ScaffoldMessenger is available
// to all descendants.
// ============================================================================

class LiquidGlassExampleApp extends StatefulWidget {
  const LiquidGlassExampleApp({super.key});

  @override
  State<LiquidGlassExampleApp> createState() => _LiquidGlassExampleAppState();
}

enum ThemeColor { purple, blue, teal, orange, pink }

class _LiquidGlassExampleAppState extends State<LiquidGlassExampleApp> {
  ThemeColor _selectedColor = ThemeColor.purple;

  Color get _seedColor {
    switch (_selectedColor) {
      case ThemeColor.purple:
        return Colors.deepPurple;
      case ThemeColor.blue:
        return Colors.blue;
      case ThemeColor.teal:
        return Colors.teal;
      case ThemeColor.orange:
        return Colors.deepOrange;
      case ThemeColor.pink:
        return Colors.pink;
    }
  }

  void _onColorChanged(ThemeColor color) {
    setState(() => _selectedColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: LiquidGlassTheme(
        data: const LiquidGlassThemeData(
          blurSigma: 25,
          opacity: 0.12,
          borderWidth: 1,
        ),
        child: LiquidGlassDemo(
          seedColor: _seedColor,
          selectedColor: _selectedColor,
          onColorChanged: _onColorChanged,
        ),
      ),
    );
  }
}

// ============================================================================
// DEMO CONTENT WIDGET
// ============================================================================
// The main demo content that showcases all Liquid Glass widgets.
// Now has access to ScaffoldMessenger via the context.
// ============================================================================

class LiquidGlassDemo extends StatefulWidget {
  const LiquidGlassDemo({
    required this.seedColor,
    required this.selectedColor,
    required this.onColorChanged,
    super.key,
  });

  final Color seedColor;
  final ThemeColor selectedColor;
  final ValueChanged<ThemeColor> onColorChanged;

  @override
  State<LiquidGlassDemo> createState() => _LiquidGlassDemoState();
}

class _LiquidGlassDemoState extends State<LiquidGlassDemo> {
  int _selectedIndex = 0;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Shows a Liquid Glass SnackBar with the given message.
  void _showSnackBar(String message) {
    // Now context is below MaterialApp, so ScaffoldMessenger is available!
    showLiquidGlassSnackBar(
      context: context,
      message: message,
      type: LiquidGlassSnackBarType.info,
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.seedColor.withValues(
                alpha: 0.2,
              ), // Dynamic background based on selection
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
              widget.seedColor.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Liquid Glacier',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Apple-inspired glassmorphism for Flutter',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Theme Selector (Radio Buttons)
                _buildSection('Theme Color'),
                LiquidGlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ThemeColor.values.map((color) {
                      Color activeColor;
                      switch (color) {
                        case ThemeColor.purple:
                          activeColor = Colors.deepPurple;
                        case ThemeColor.blue:
                          activeColor = Colors.blue;
                        case ThemeColor.teal:
                          activeColor = Colors.teal;
                        case ThemeColor.orange:
                          activeColor = Colors.deepOrange;
                        case ThemeColor.pink:
                          activeColor = Colors.pink;
                      }
                      return LiquidGlassRadioButton<ThemeColor>(
                        value: color,
                        groupValue: widget.selectedColor,
                        activeColor: activeColor,
                        onChanged: (val) {
                          if (val != null) {
                            widget.onColorChanged(val);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),

                // Liquid Glass Card
                _buildSection('LiquidGlassCard'),
                LiquidGlassCard(
                  onTap: () => _showSnackBar('Card tapped!'),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Beautiful Glass Card',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap me! This card features blur, translucency, and subtle reflections.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Liquid Glass Buttons
                _buildSection('LiquidGlassButton'),
                Row(
                  children: [
                    Expanded(
                      child: LiquidGlassButton(
                        onPressed: () => _showSnackBar('Primary pressed!'),
                        child: const Text('Primary'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LiquidGlassButton(
                        onPressed: () => _showSnackBar('Secondary pressed!'),
                        tintColor: Colors.purple,
                        child: const Text('Tinted'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const LiquidGlassButton(
                  onPressed: null,
                  child: Text('Disabled Button'),
                ),
                const SizedBox(height: 30),

                // Liquid Glass TextField
                _buildSection('LiquidGlassTextField'),
                LiquidGlassTextField(
                  controller: _textController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                const LiquidGlassTextField(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
                ),
                const SizedBox(height: 30),

                // Liquid Glass Container
                _buildSection('LiquidGlassContainer'),
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white70),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This is a custom glass container. Use it for any content!',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Liquid Glass Chips
                _buildSection('LiquidGlassChip'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    LiquidGlassChip(
                      label: const Text('Flutter'),
                      avatar: const Icon(Icons.flutter_dash, size: 18),
                      onTap: () => _showSnackBar('Flutter chip tapped!'),
                    ),
                    LiquidGlassChip(
                      label: const Text('Dart'),
                      avatar: const Icon(Icons.code, size: 18),
                      onTap: () => _showSnackBar('Dart chip tapped!'),
                    ),
                    const LiquidGlassChip(
                      label: Text('Design'),
                      avatar: Icon(Icons.palette, size: 18),
                      selected: true,
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Liquid Glass SnackBar Showcase with Transitions
                _buildSection('LiquidGlassSnackBar'),
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Snackbar types with smooth animated transitions:',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Row 1: Info (slide up) and Success (scale)
                      Row(
                        children: [
                          Expanded(
                            child: LiquidGlassButton(
                              onPressed: () => showLiquidGlassSnackBar(
                                context: context,
                                message: 'This is an info message.',
                                type: LiquidGlassSnackBarType.info,
                              ),
                              tintColor: const Color(0xFF007AFF),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, size: 18),
                                  SizedBox(width: 6),
                                  Text('Info'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LiquidGlassButton(
                              onPressed: () => showLiquidGlassSnackBar(
                                context: context,
                                message: 'Operation completed successfully!',
                                type: LiquidGlassSnackBarType.success,
                                transitionType: LiquidGlassTransitionType.scale,
                              ),
                              tintColor: const Color(0xFF34C759),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline, size: 18),
                                  SizedBox(width: 6),
                                  Text('Success'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Row 2: Warning (zoom) and Error (elastic)
                      Row(
                        children: [
                          Expanded(
                            child: LiquidGlassButton(
                              onPressed: () => showLiquidGlassSnackBar(
                                context: context,
                                message: 'Please check your settings.',
                                type: LiquidGlassSnackBarType.warning,
                                transitionType: LiquidGlassTransitionType.zoom,
                              ),
                              tintColor: const Color(0xFFFF9500),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.warning_amber, size: 18),
                                  SizedBox(width: 6),
                                  Text('Warning'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LiquidGlassButton(
                              onPressed: () => showLiquidGlassSnackBar(
                                context: context,
                                message: 'Something went wrong!',
                                type: LiquidGlassSnackBarType.error,
                                transitionType:
                                    LiquidGlassTransitionType.elastic,
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                              ),
                              tintColor: const Color(0xFFFF3B30),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 18),
                                  SizedBox(width: 6),
                                  Text('Error'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Row 3: Top position
                      LiquidGlassButton(
                        onPressed: () => showLiquidGlassSnackBar(
                          context: context,
                          message: 'Notification from the top!',
                          type: LiquidGlassSnackBarType.info,
                          position: LiquidGlassSnackBarPosition.top,
                          transitionType: LiquidGlassTransitionType.slideDown,
                        ),
                        tintColor: Colors.purple,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_upward, size: 18),
                            SizedBox(width: 6),
                            Text('Top Position'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Row 4: With action and close button
                      LiquidGlassButton(
                        onPressed: () => showLiquidGlassSnackBar(
                          context: context,
                          message: 'File saved to Downloads folder.',
                          type: LiquidGlassSnackBarType.success,
                          transitionType: LiquidGlassTransitionType.scaleDown,
                          actionLabel: 'Open',
                          onActionPressed: () =>
                              _showSnackBar('Opening file...'),
                          showCloseIcon: true,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_alt, size: 18),
                            SizedBox(width: 6),
                            Text('With Action & Close'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Liquid Glass Dialog Showcase
                _buildSection('LiquidGlassDialog'),
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Beautiful animated dialog transitions:',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Row 1: Scale Down (iOS) and Scale
                      Row(
                        children: [
                          Expanded(
                            child: LiquidGlassButton(
                              onPressed: () => showLiquidGlassDialog<void>(
                                context: context,
                                builder: (context) => LiquidGlassAlertDialog(
                                  icon: const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFD60A),
                                  ),
                                  title: const Text('iOS Style'),
                                  content: const Text(
                                    'This dialog uses the signature iOS scale-down animation.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Color(0xFF007AFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              tintColor: const Color(0xFF007AFF),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone_iphone, size: 18),
                                  SizedBox(width: 6),
                                  Text('iOS Style'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LiquidGlassButton(
                              onPressed: () => showLiquidGlassDialog<void>(
                                context: context,
                                transitionType:
                                    LiquidGlassTransitionType.elastic,
                                transitionDuration:
                                    const Duration(milliseconds: 600),
                                builder: (context) => LiquidGlassAlertDialog(
                                  icon: const Icon(
                                    Icons.celebration,
                                    color: Color(0xFFFF9500),
                                  ),
                                  title: const Text('Bouncy!'),
                                  content: const Text(
                                    'This dialog has a playful elastic bounce animation.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Awesome!',
                                        style: TextStyle(
                                          color: Color(0xFFFF9500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              tintColor: const Color(0xFFFF9500),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.animation, size: 18),
                                  SizedBox(width: 6),
                                  Text('Elastic'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Row 2: Slide Up and Zoom
                      Row(
                        children: [
                          Expanded(
                            child: LiquidGlassButton(
                              onPressed: () => showLiquidGlassDialog<void>(
                                context: context,
                                transitionType:
                                    LiquidGlassTransitionType.slideUp,
                                builder: (context) => LiquidGlassAlertDialog(
                                  icon: const Icon(
                                    Icons.upload_rounded,
                                    color: Color(0xFF34C759),
                                  ),
                                  title: const Text('Slide Up'),
                                  content: const Text(
                                    'Perfect for bottom sheet-style dialogs.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Got it!',
                                        style: TextStyle(
                                          color: Color(0xFF34C759),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              tintColor: const Color(0xFF34C759),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_upward, size: 18),
                                  SizedBox(width: 6),
                                  Text('Slide Up'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LiquidGlassButton(
                              onPressed: () => showLiquidGlassDialog<void>(
                                context: context,
                                transitionType: LiquidGlassTransitionType.zoom,
                                builder: (context) => LiquidGlassAlertDialog(
                                  icon: const Icon(
                                    Icons.zoom_in,
                                    color: Color(0xFFAF52DE),
                                  ),
                                  title: const Text('Zoom'),
                                  content: const Text(
                                    'A dramatic zoom entrance with subtle bounce.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Nice!',
                                        style: TextStyle(
                                          color: Color(0xFFAF52DE),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              tintColor: const Color(0xFFAF52DE),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.zoom_in, size: 18),
                                  SizedBox(width: 6),
                                  Text('Zoom'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Confirmation dialog
                      LiquidGlassButton(
                        onPressed: () async {
                          final confirmed = await showLiquidGlassConfirmDialog(
                            context: context,
                            title: 'Delete Item',
                            message:
                                'Are you sure you want to delete this item? This action cannot be undone.',
                            confirmText: 'Delete',
                            isDestructive: true,
                          );
                          if ((confirmed ?? false) && context.mounted) {
                            await showLiquidGlassSnackBar(
                              context: context,
                              message: 'Item deleted successfully.',
                              type: LiquidGlassSnackBarType.success,
                            );
                          }
                        },
                        tintColor: const Color(0xFFFF3B30),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline, size: 18),
                            SizedBox(width: 6),
                            Text('Confirmation Dialog'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: LiquidGlassFAB(
        onPressed: () => _showSnackBar('FAB pressed!'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: LiquidGlassBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
