// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_loginsystems_1/Menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeMode = await ThemeProvider.loadThemeMode();
  runApp(TrapezoidAreaCalculator(themeMode: themeMode));
}

class ThemeProvider {
  static const String _key = 'theme_mode';

  static Future<void> setThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, themeMode.toString());
  }

  static Future<ThemeMode> loadThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeMode = prefs.getString(_key);
    if (themeMode == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    } else if (themeMode == ThemeMode.light.toString()) {
      return ThemeMode.light;
    }
    return ThemeMode.system; // Default to system theme
  }
}

class TrapezoidAreaCalculator extends StatelessWidget {
  final ThemeMode themeMode;

  const TrapezoidAreaCalculator({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triangle Area Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: themeMode,
      home: const Triangle(),
    );
  }
}

class Triangle extends StatefulWidget {
  const Triangle({super.key});

  @override
  _TriangleAreaState createState() => _TriangleAreaState();
}

class _TriangleAreaState extends State<Triangle> {
  final TextEditingController _baseController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _triangleArea = 0.0;

  void _calculateTriangleArea() {
    final base = double.tryParse(_baseController.text);
    final height = double.tryParse(_heightController.text);

    // Check if the values are valid and positive
    if (base != null && height != null && base > 0 && height > 0) {
      setState(() {
        _triangleArea = 0.5 * base * height;
      });
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Error'),
          content: const Text('กรุณากรอกค่าให้ถูกต้อง'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คำอธิบายสูตรคำนวณ'),
        content: const Text(
          'การคำนวณพื้นที่สามเหลี่ยมใช้สูตร:\n'
          'พื้นที่ (A) = 1/2 × ฐาน (b) × สูง (h)\n'
          'กรุณากรอกค่าฐานและความสูงเพื่อคำนวณพื้นที่ของสามเหลี่ยม',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Triangle Area Calculator'),
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        titleTextStyle:
            TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showFormulaExplanation,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDescriptionText(
                      'สูตรคำนวณพื้นที่สามเหลี่ยม: พื้นที่ = 1/2 × ฐาน × สูง\n'
                      'กรุณากรอกค่าฐานและความสูงเพื่อคำนวณพื้นที่',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _baseController,
                      label: 'Base of Triangle',
                      icon: Icons.straighten,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _heightController,
                      label: 'Height of Triangle',
                      icon: Icons.height,
                    ),
                    const SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculate',
                      onPressed: _calculateTriangleArea,
                    ),
                    const SizedBox(height: 8),
                    _buildResultText('Triangle Area: $_triangleArea'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon, color: isDarkMode ? Colors.white54 : Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: isDarkMode ? Colors.white54 : Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: isDarkMode ? Colors.white : Colors.black),
        ),
        labelStyle:
            TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildCalculateButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.white : Colors.black,
        foregroundColor: isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildResultText(String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildDescriptionText(String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: isDarkMode ? Colors.white70 : Colors.grey[800],
      ),
    );
  }
}
