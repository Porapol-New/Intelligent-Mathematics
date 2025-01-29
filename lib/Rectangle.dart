import 'package:flutter/material.dart';
import 'package:flutter_loginsystems_1/Menu.dart';

class RectangleCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rectangle Area Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
      ),
      themeMode: ThemeMode.system,
      home: RectangleArea(),
    );
  }
}

class RectangleArea extends StatefulWidget {
  @override
  _RectangleAreaState createState() => _RectangleAreaState();
}

class _RectangleAreaState extends State<RectangleArea> {
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  double _rectangleArea = 0.0;
  bool _isDarkMode = false;

  void _calculateRectangleArea() {
    final length = double.tryParse(_lengthController.text);
    final width = double.tryParse(_widthController.text);
    if (length != null && width != null) {
      setState(() {
        _rectangleArea = length * width;
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
          'การคำนวณพื้นที่ของสี่เหลี่ยมผืนผ้าใช้สูตร: \n'
          'พื้นที่ (A) = ความยาว (L) * ความกว้าง (W)\n\n'
          'สูตรนี้ใช้ในการคำนวณพื้นที่ทั้งหมดภายในสี่เหลี่ยมผืนผ้าโดยการคูณความยาวกับความกว้าง.',
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
        title: Text('Rectangle Area Calculator'),
        backgroundColor: _isDarkMode ? Colors.black : Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Mymenu()),
            );
          },
        ),
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
                      'สูตรคำนวณพื้นที่สี่เหลี่ยมผืนผ้า: พื้นที่ = ความยาว * ความกว้าง\n'
                      'กรุณากรอกค่าความยาวและความกว้างเพื่อคำนวณพื้นที่.',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _lengthController,
                      label: 'Length',
                      icon: Icons.straighten,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _widthController,
                      label: 'Width',
                      icon: Icons.straighten,
                    ),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculated',
                      onPressed: _calculateRectangleArea,
                    ),
                    SizedBox(height: 8),
                    _buildResultText('Rectangle Area: $_rectangleArea'),
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
