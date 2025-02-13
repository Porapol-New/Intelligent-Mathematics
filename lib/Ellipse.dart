import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_loginsystems_1/comment_section.dart'; // Importing math package for Pi

class EllipseAreaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ellipse Area Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const EllipseArea(),
    );
  }
}

class EllipseArea extends StatefulWidget {
  const EllipseArea();

  @override
  _EllipseAreaState createState() => _EllipseAreaState();
}

class _EllipseAreaState extends State<EllipseArea> {
  final TextEditingController _aController =
      TextEditingController(); // Semi-major axis
  final TextEditingController _bController =
      TextEditingController(); // Semi-minor axis
  double _ellipseArea = 0.0;

  static const double _pi = 3.1416;

  void _calculateEllipseArea() {
    final a = double.tryParse(_aController.text);
    final b = double.tryParse(_bController.text);

    if (a == null || b == null || a <= 0 || b <= 0) {
      _showErrorDialog('กรุณากรอกค่าให้ถูกต้อง');
      setState(() {
        _ellipseArea = 0.0;
      });
    } else {
      setState(() {
        _ellipseArea = _pi * a * b;
      });
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(errorMessage),
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
          'พื้นที่ของวงรีสามารถคำนวณได้ด้วยสูตร: \n'
          'พื้นที่ = π x a x b\n\n'
          'π (Pi) คือค่าคงที่ทางคณิตศาสตร์ ซึ่งมีค่าประมาณ 3.1416. '
          'a คือรัศมีใหญ่ และ b คือรัศมีเล็ก.',
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
        title: const Text('Ellipse Area Calculator'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDescriptionText(
                    'สูตรคำนวณพื้นที่วงรี: พื้นที่ = π x a x b\n'
                    'กรุณากรอกค่ารัศมีใหญ่ (a) และรัศมีเล็ก (b) เพื่อคำนวณพื้นที่วงรี',
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _aController,
                    label: 'Semi-Major Axis (a)',
                    icon: Icons.circle_outlined,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _bController,
                    label: 'Semi-Minor Axis (b)',
                    icon: Icons.circle_outlined,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _buildCalculateButton(
                    label: 'Calculate',
                    onPressed: _calculateEllipseArea,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _ellipseArea != 0.0
                      ? _buildResultText(
                          'Ellipse Area: ${_ellipseArea.toStringAsFixed(2)}',
                          isDarkMode,
                        )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CommentSection(pageId: "ellipse"),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
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
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
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
