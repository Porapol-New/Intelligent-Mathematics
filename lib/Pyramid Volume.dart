// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pyramid Volume Calculator',
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
      home: Pyramid(),
    );
  }
}

class Pyramid extends StatefulWidget {
  @override
  _PyramidVolumeState createState() => _PyramidVolumeState();
}

class _PyramidVolumeState extends State<Pyramid> {
  final TextEditingController _baseLengthController = TextEditingController();
  final TextEditingController _baseWidthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _pyramidVolume = 0.0;
  bool _isDarkMode = false;

  void _calculatePyramidVolume() {
    final baseLength = double.tryParse(_baseLengthController.text);
    final baseWidth = double.tryParse(_baseWidthController.text);
    final height = double.tryParse(_heightController.text);
    if (baseLength != null && baseWidth != null && height != null) {
      setState(() {
        // Area of the base (Rectangle)
        double baseArea = baseLength * baseWidth;
        // Volume of the pyramid
        _pyramidVolume = (1 / 3) * baseArea * height;
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
          'การคำนวณปริมาตรของปิระมิดใช้สูตร:\n'
          'ปริมาตร (V) = 1/3 × พื้นที่ฐาน (A_b) × ความสูง (h)\n'
          'กรุณากรอกค่าพื้นที่ฐานและความสูงเพื่อคำนวณปริมาตรของปิระมิด',
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
        title: Text('Pyramid Volume Calculator'),
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
            onPressed: _showFormulaExplanation, // ปุ่มแสดงคำอธิบายสูตร
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
                      'สูตรคำนวณปริมาตรของปิระมิด: ปริมาตร = 1/3 × พื้นที่ฐาน × ความสูง\n'
                      'กรุณากรอกค่าพื้นที่ฐานและความสูงเพื่อคำนวณปริมาตรของปิระมิด',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _baseLengthController,
                      label: 'Base Length',
                      icon: Icons.straighten,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _baseWidthController,
                      label: 'Base Width',
                      icon: Icons.straighten,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _heightController,
                      label: 'Pyramid Height',
                      icon: Icons.height,
                    ),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculated',
                      onPressed: _calculatePyramidVolume,
                    ),
                    SizedBox(height: 8),
                    _buildResultText('Pyramid Volume: $_pyramidVolume'),
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
