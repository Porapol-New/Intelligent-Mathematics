import 'package:flutter/material.dart';

class PercentageCalculator extends StatefulWidget {
  @override
  _PercentageCalculatorState createState() => _PercentageCalculatorState();
}

class _PercentageCalculatorState extends State<PercentageCalculator> {
  final TextEditingController _partController = TextEditingController();
  final TextEditingController _wholeController = TextEditingController();
  double _percentage = 0.0;
  bool _isDarkMode = false;

  void _calculatePercentage() {
    final part = double.tryParse(_partController.text);
    final whole = double.tryParse(_wholeController.text);
    if (part != null && whole != null && whole != 0) {
      setState(() {
        _percentage = (part / whole) * 100;
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
        title: Text('คำอธิบายสูตรคำนวณเปอร์เซ็นต์'),
        content: Text(
          'การคำนวณเปอร์เซ็นต์ใช้สูตร:\n'
          'Percentage = (Part / Whole) × 100\n'
          'โดยที่ Part คือจำนวนที่ต้องการคำนวณและ Whole คือจำนวนทั้งหมด.',
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
        title: Text('Percentage Calculator'),
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
                      'สูตรคำนวณเปอร์เซ็นต์: Percentage = (Part / Whole) × 100\n'
                      'กรุณากรอกจำนวนที่ต้องการคำนวณ (Part) และจำนวนทั้งหมด (Whole)',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _partController,
                      label: 'Part (จำนวนที่ต้องการคำนวณ)',
                      icon: Icons.percent,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _wholeController,
                      label: 'Whole (จำนวนทั้งหมด)',
                      icon: Icons.attach_money,
                    ),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculate Percentage',
                      onPressed: _calculatePercentage,
                    ),
                    SizedBox(height: 8),
                    _buildResultText(
                        'Percentage: ${_percentage.toStringAsFixed(2)}%'),
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
