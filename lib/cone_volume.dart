// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class ConeVolumeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cone Volume Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme:
            const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme:
            const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
      ),
      themeMode: ThemeMode.system,
      home: const Cone(),
    );
  }
}

class Cone extends StatefulWidget {
  const Cone();

  @override
  _ConeVolumeState createState() => _ConeVolumeState();
}

class _ConeVolumeState extends State<Cone> {
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double? _coneVolume;
  static const double _pi = 3.14159265359;

  void _calculateConeVolume() {
    final double? radius = double.tryParse(_radiusController.text);
    final double? height = double.tryParse(_heightController.text);

    if (radius == null || height == null || radius <= 0 || height <= 0) {
      _showErrorDialog("กรุณากรอกรัศมีให้ถูกต้อง");
      return;
    }

    setState(() {
      _coneVolume = (1 / 3) * _pi * radius * radius * height;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คำอธิบายสูตรคำนวณ'),
        content: const Text(
          'การคำนวณปริมาตรทรงกรวยใช้สูตรดังนี้:\n'
          'V = (1/3) × π × r² × h\n'
          'โดยที่ r คือรัศมีของฐาน และ h คือความสูงของทรงกรวย',
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
        title: const Text('Cone Volume Calculator'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDescriptionText(
                    'สูตรคำนวณปริมาตรทรงกรวย:\n'
                    'ปริมาตร = (1/3) × π × รัศมี² × ความสูง\n'
                    'กรุณากรอกค่ารัศมีและความสูงเพื่อคำนวณปริมาตร',
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _radiusController,
                    label: 'Radius of Cone',
                    icon: Icons.circle,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _heightController,
                    label: 'Height of Cone',
                    icon: Icons.height,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _buildCalculateButton(
                      'Calculate', _calculateConeVolume, isDarkMode),
                  const SizedBox(height: 8),
                  _coneVolume != null
                      ? _buildResultText(
                          'Cone Volume: ${_coneVolume!.toStringAsFixed(2)}',
                          isDarkMode)
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }
}

Widget _buildCard({required Widget child}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 2,
    child: Padding(padding: const EdgeInsets.all(16.0), child: child),
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
      prefixIcon: Icon(icon, color: isDarkMode ? Colors.white54 : Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
      ),
      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
    ),
    keyboardType: TextInputType.number,
    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
  );
}

Widget _buildCalculateButton(
    String label, VoidCallback onPressed, bool isDarkMode) {
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
        color: isDarkMode ? Colors.white : Colors.black87),
  );
}

Widget _buildDescriptionText(String text, bool isDarkMode) {
  return Text(
    text,
    style: TextStyle(
        fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.grey[800]),
  );
}
