// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimalist Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // ใช้สีฟ้าอ่อนและสีเทาสำหรับ Light Mode
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF8F9FA), // พื้นหลังสีขาวนวล
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey, // ใช้โทนสีเทาฟ้าสำหรับ Dark Mode
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212), // พื้นหลังสีดำหม่น
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: ThemeMode.system, // ปรับตามการตั้งค่าระบบ
      home: CubeVolume(),
    );
  }
}

class CubeVolume extends StatefulWidget {
  @override
  _CubeVolumeState createState() => _CubeVolumeState();
}

class _CubeVolumeState extends State<CubeVolume> {
  final TextEditingController _sideController = TextEditingController();
  double _cubeVolume = 0.0;
  bool _isDarkMode = false;

  void _calculateCubeVolume() {
    final side = double.tryParse(_sideController.text);
    if (side != null) {
      setState(() {
        _cubeVolume = side * side * side;
      });
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // ปรับธีมสี
    });
  }

  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('คำอธิบายสูตรคำนวณ'),
        content: Text(
          'การคำนวณปริมาตรของลูกบาศก์ (Cube Volume) ใช้สูตรง่าย ๆ '
          'ปริมาตร (V) = ด้าน (s) ยกกำลังสาม หรือ V = s³\n'
          'ปริมาตรของลูกบาศก์คือพื้นที่ที่ลูกบาศก์ใช้ในช่องว่าง ซึ่งสามารถคำนวณได้โดยการนำความยาวของด้านหนึ่งของลูกบาศก์มาคูณกันสามครั้ง '
          'ดังนั้น ปริมาตรจึงขึ้นอยู่กับค่าของความยาวด้านของลูกบาศก์',
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
        title: Text('Minimalist Cubes Calculator'),
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
            onPressed: _toggleTheme, // ปุ่มสำหรับเปลี่ยนธีมสี
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
                      'สูตรคำนวณปริมาตรทรงลูกบาศก์: ปริมาตร = ด้าน^3\n'
                      'กรุณากรอกค่าด้านของลูกบาศก์เพื่อคำนวณปริมาตร',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _sideController,
                      label: 'Side of Cube',
                      icon: Icons.cut_outlined,
                    ),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculate Cube Volume',
                      onPressed: _calculateCubeVolume,
                    ),
                    SizedBox(height: 8),
                    _buildResultText('Cube Volume: $_cubeVolume'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showFormulaExplanation, // เพิ่มปุ่มแสดงคำอธิบายสูตร
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(
                  'แสดงคำอธิบายสูตร',
                  style: TextStyle(fontSize: 16),
                ),
              ),
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
