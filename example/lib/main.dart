import 'package:flutter/material.dart';
import 'package:liquid_glacier/liquid_glacier.dart';

void main() {
  runApp(const LiquidGlassExampleApp());
}

class LiquidGlassExampleApp extends StatelessWidget {
  const LiquidGlassExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LiquidGlassDemo();
  }
}

class LiquidGlassDemo extends StatefulWidget {
  const LiquidGlassDemo({super.key});

  @override
  State<LiquidGlassDemo> createState() => _LiquidGlassDemoState();
}

enum _ThemeColor { purple, blue, teal, orange, pink }

class _LiquidGlassDemoState extends State<LiquidGlassDemo> {
  int _selectedIndex = 0;
  _ThemeColor _selectedColor = _ThemeColor.purple;
  final TextEditingController _textController = TextEditingController();

  Color get _seedColor {
    switch (_selectedColor) {
      case _ThemeColor.purple:
        return Colors.deepPurple;
      case _ThemeColor.blue:
        return Colors.blue;
      case _ThemeColor.teal:
        return Colors.teal;
      case _ThemeColor.orange:
        return Colors.deepOrange;
      case _ThemeColor.pink:
        return Colors.pink;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
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
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _seedColor.withValues(
                    alpha: 0.2,
                  ), // Dynamic background based on selection
                  const Color(0xFF16213e),
                  const Color(0xFF0f3460),
                  _seedColor.withValues(alpha: 0.4),
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
                        children: _ThemeColor.values.map((color) {
                          Color activeColor;
                          switch (color) {
                            case _ThemeColor.purple:
                              activeColor = Colors.deepPurple;
                            case _ThemeColor.blue:
                              activeColor = Colors.blue;
                            case _ThemeColor.teal:
                              activeColor = Colors.teal;
                            case _ThemeColor.orange:
                              activeColor = Colors.deepOrange;
                            case _ThemeColor.pink:
                              activeColor = Colors.pink;
                          }
                          return LiquidGlassRadioButton<_ThemeColor>(
                            value: color,
                            groupValue: _selectedColor,
                            activeColor: activeColor,
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedColor = val);
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
                            onPressed: () =>
                                _showSnackBar('Secondary pressed!'),
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
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.white70),
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
        ),
      ),
    );
  }
}
