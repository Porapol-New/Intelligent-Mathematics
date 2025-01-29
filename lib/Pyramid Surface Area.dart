// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pyramid Surface Area Calculator',
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
      home: PyramidSurfaceArea(),
    );
  }
}

class PyramidSurfaceArea extends StatefulWidget {
  @override
  _PyramidSurfaceAreaState createState() => _PyramidSurfaceAreaState();
}

class _PyramidSurfaceAreaState extends State<PyramidSurfaceArea> {
  final TextEditingController _baseAreaController = TextEditingController();
  final TextEditingController _basePerimeterController =
      TextEditingController();
  final TextEditingController _slantHeightController = TextEditingController();
  double _surfaceArea = 0.0;
  bool _isDarkMode = false;

  void _calculateSurfaceArea() {
    final baseArea = double.tryParse(_baseAreaController.text);
    final basePerimeter = double.tryParse(_basePerimeterController.text);
    final slantHeight = double.tryParse(_slantHeightController.text);
    if (baseArea != null && basePerimeter != null && slantHeight != null) {
      setState(() {
        _surfaceArea = baseArea + 0.5 * basePerimeter * slantHeight;
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
          'การคำนวณพื้นที่ผิวของปิระมิดใช้สูตร:\n'
          'พื้นที่ผิวรวม = พื้นที่ฐาน + พื้นที่ผิวด้านข้าง\n\n'
          '\n'
          'พื้นที่ฐาน = ความยาวฐาน × ความกว้างฐาน\n'
          'พื้นที่ผิวด้านข้าง = 1/2 × (ความยาวฐาน + ความกว้างฐาน) × ความเอียงของปิระมิด\n'
          '\n'
          'กรุณากรอกค่าความยาวฐาน, ความกว้างฐาน และความเอียงเพื่อคำนวณพื้นที่ผิว.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pyramid Surface Area Calculator'),
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
            onPressed: _showFormulaExplanation,
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
                      'สูตรคำนวณพื้นที่ผิวของปิระมิด: พื้นที่ผิวรวม = พื้นที่ฐาน + พื้นที่ผิวด้านข้างกรุณากรอกค่าความยาวฐาน, \n'
                      'ความกว้างฐาน และความเอียงเพื่อคำนวณพื้นที่ผิว',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _baseAreaController,
                      label: 'Base Length(B)',
                      icon: Icons.square_foot,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _basePerimeterController,
                      label: 'Base Width (W)',
                      icon: Icons.straighten,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _slantHeightController,
                      label: 'Slant Height (l)',
                      icon: Icons.height,
                    ),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculate',
                      onPressed: _calculateSurfaceArea,
                    ),
                    SizedBox(height: 8),
                    _buildResultText('Surface Area: $_surfaceArea'),
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
