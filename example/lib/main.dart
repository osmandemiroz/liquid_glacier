import 'package:flutter/material.dart';
import 'package:liquid_glacier/liquid_glacier.dart';

void main() {
  runApp(const LiquidGlassExampleApp());
}

class LiquidGlassExampleApp extends StatelessWidget {
  const LiquidGlassExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LiquidGlassDemo(),
    );
  }
}

class LiquidGlassDemo extends StatefulWidget {
  const LiquidGlassDemo({super.key});

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

  @override
  Widget build(BuildContext context) {
    return LiquidGlassTheme(
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1a1a2e),
                Color(0xFF16213e),
                Color(0xFF0f3460),
                Color(0xFF533483),
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
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: Colors.white70),
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
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white54,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
