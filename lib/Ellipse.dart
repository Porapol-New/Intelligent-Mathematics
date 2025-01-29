// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math'; // Importing math package for Pi

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ellipse Area Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: ThemeMode.system,
      home: Ellipse(),
    );
  }
}

class Ellipse extends StatefulWidget {
  @override
  _EllipseAreaState createState() => _EllipseAreaState();
}

class _EllipseAreaState extends State<Ellipse> {
  final TextEditingController _aController =
      TextEditingController(); // Semi-major axis
  final TextEditingController _bController =
      TextEditingController(); // Semi-minor axis
  double _ellipseArea = 0.0;
  bool _isDarkMode = false;

  void _calculateEllipseArea() {
    final a = double.tryParse(_aController.text);
    final b = double.tryParse(_bController.text);
    if (a != null && b != null) {
      setState(() {
        _ellipseArea = pi * a * b; // Ellipse area formula
      });
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('คำอธิบายสูตรคำนวณ'),
        content: Text(
          'การคำนวณพื้นที่วงรีใช้สูตร:\n'
          'พื้นที่ (A) = π × a × b\n'
          'กรุณากรอกค่ารัศมีใหญ่ (a) และรัศมีเล็ก (b) เพื่อคำนวณพื้นที่วงรี',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ปิด'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ellipse Area Calculator'),
        backgroundColor: _isDarkMode ? Colors.black : Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        titleTextStyle:
            TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
        iconTheme:
            IconThemeData(color: _isDarkMode ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_outlined),
            onPressed: _toggleTheme,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showFormulaExplanation, // Show formula explanation
            color: _isDarkMode ? Colors.white : Colors.black,
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
                      'สูตรคำนวณพื้นที่วงรี: พื้นที่ = π × a × b\n'
                      'กรุณากรอกค่ารัศมีใหญ่ (a) และรัศมีเล็ก (b) เพื่อคำนวณพื้นที่วงรี',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _aController,
                      label: 'Semi-Major Axis (a)',
                      icon: Icons.circle_outlined,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _bController,
                      label: 'Semi-Minor Axis (b)',
                      icon: Icons.circle_outlined,
                    ),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculated',
                      onPressed: _calculateEllipseArea,
                    ),
                    SizedBox(height: 8),
                    _buildResultText('Ellipse Area: $_ellipseArea'),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      color: _isDarkMode ? Colors.grey[800] : Colors.grey[100],
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
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon, color: _isDarkMode ? Colors.white54 : Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: _isDarkMode ? Colors.white54 : Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: _isDarkMode ? Colors.white : Colors.black),
        ),
        labelStyle:
            TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildCalculateButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isDarkMode ? Colors.white : Colors.black,
        foregroundColor: _isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildResultText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildDescriptionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: _isDarkMode ? Colors.white70 : Colors.grey[800],
      ),
    );
  }
}
