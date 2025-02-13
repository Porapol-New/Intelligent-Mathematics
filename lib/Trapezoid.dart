// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_loginsystems_1/Menu.dart';
import 'package:flutter_loginsystems_1/comment_section.dart';
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
      title: 'Trapezoid Area Calculator',
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
      home: const TrapezoidArea(),
    );
  }
}

class TrapezoidArea extends StatefulWidget {
  const TrapezoidArea({super.key});

  @override
  _TrapezoidAreaState createState() => _TrapezoidAreaState();
}

class _TrapezoidAreaState extends State<TrapezoidArea> {
  final TextEditingController _base1Controller = TextEditingController();
  final TextEditingController _base2Controller = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _trapezoidArea = 0.0;

  void _calculateTrapezoidArea() {
    final base1 = double.tryParse(_base1Controller.text);
    final base2 = double.tryParse(_base2Controller.text);
    final height = double.tryParse(_heightController.text);

    if (base1 != null &&
        base2 != null &&
        height != null &&
        base1 > 0 &&
        base2 > 0 &&
        height > 0) {
      setState(() {
        _trapezoidArea = 0.5 * (base1 + base2) * height;
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
          content: const Text('กรุณากรอกค่าที่ถูกต้อง'),
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
          'การคำนวณพื้นที่ของสี่เหลี่ยมคางหมูใช้สูตร: \n'
          'พื้นที่ (A) = 1/2 * (ฐานล่าง (b1) + ฐานบน (b2)) * สูง (h)\n\n'
          'โดยพื้นที่ของสี่เหลี่ยมคางหมูคือพื้นที่ที่อยู่ภายในรูปทรงซึ่งมีฐานทั้งสองขนานกัน.',
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
        title: const Text('Trapezoid Area Calculator'),
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
                      'สูตรคำนวณพื้นที่สี่เหลี่ยมคางหมู: พื้นที่ = 1/2 * (ฐานล่าง + ฐานบน) * สูง\n'
                      'กรุณากรอกค่าฐานล่าง ฐานบน และความสูงเพื่อคำนวณพื้นที่.',
                      isDarkMode,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _base1Controller,
                      label: 'Base 1',
                      icon: Icons.straighten,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _base2Controller,
                      label: 'Base 2',
                      icon: Icons.straighten,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _heightController,
                      label: 'Height',
                      icon: Icons.height,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculate',
                      onPressed: _calculateTrapezoidArea,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 8),
                    _buildResultText(
                        'Trapezoid Area: $_trapezoidArea', isDarkMode),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CommentSection(pageId: "trapezoid")
            ],
          ),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : Colors.grey[100],
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
    required bool isDarkMode,
  }) {
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
    required bool isDarkMode,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.white : Colors.black,
        foregroundColor: isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }

  Widget _buildResultText(String text, bool isDarkMode) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildDescriptionText(String text, bool isDarkMode) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: isDarkMode ? Colors.white70 : Colors.grey[800],
      ),
    );
  }
}
