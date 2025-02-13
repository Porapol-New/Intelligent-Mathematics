import 'package:flutter/material.dart';
import 'package:flutter_loginsystems_1/comment_section.dart';
import 'package:intl/intl.dart';

class PercentageCalculator extends StatefulWidget {
  const PercentageCalculator({Key? key}) : super(key: key);

  @override
  _PercentageCalculatorState createState() => _PercentageCalculatorState();
}

class _PercentageCalculatorState extends State<PercentageCalculator> {
  final TextEditingController _partController = TextEditingController();
  final TextEditingController _wholeController = TextEditingController();
  double _percentage = 0.0;

  static const String formulaExplanation = 'การคำนวณเปอร์เซ็นต์ใช้สูตร:\n'
      'Percentage = (Part / Whole) × 100\n'
      'โดยที่ Part คือจำนวนที่ต้องการคำนวณและ Whole คือจำนวนทั้งหมด( Part ต้องน้อยกว่าหรือเท่ากับ Whole)\n';

  final double _maxInputValue = 1000000000; // 1 Billion

  void _calculatePercentage() {
    final part = double.tryParse(_partController.text);
    final whole = double.tryParse(_wholeController.text);

    if (part == null) {
      _showErrorDialog('กรุณากรอกตัวเลขสำหรับ Part');
    } else if (part < 0) {
      _showErrorDialog('Part ต้องเป็นค่าบวก');
    } else if (part > _maxInputValue) {
      _showErrorDialog('Part เกิน ${_formatNumber(_maxInputValue)}');
    } else if (whole == null) {
      _showErrorDialog('กรุณากรอกตัวเลขสำหรับ Whole');
    } else if (whole <= 0) {
      _showErrorDialog('Whole ต้องมากกว่าศูนย์');
    } else if (whole > _maxInputValue) {
      _showErrorDialog('Whole เกิน ${_formatNumber(_maxInputValue)}');
    } else if (part > whole) {
      _showErrorDialog('Part ต้องน้อยกว่าหรือเท่ากับ Whole');
    } else {
      setState(() {
        _percentage = (part / whole) * 100;
      });
    }
  }

  String _formatNumber(double number) {
    return NumberFormat('#,###').format(number);
  }

  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คำอธิบายสูตรคำนวณเปอร์เซ็นต์'),
        content: Text(formulaExplanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Percentage Calculator'),
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
              isDarkMode: isDarkMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDescriptionText(
                    'สูตรคำนวณเปอร์เซ็นต์: Percentage = (Part / Whole) × 100\n'
                    'กรุณากรอกจำนวนที่ต้องการคำนวณ (Part) และจำนวนทั้งหมด (Whole)',
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _partController,
                    label: 'Part (จำนวนที่ต้องการคำนวณ)',
                    icon: Icons.percent,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _wholeController,
                    label: 'Whole (จำนวนทั้งหมด)',
                    icon: Icons.attach_money,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _buildCalculateButton(
                    label: 'Calculate Percentage',
                    onPressed: _calculatePercentage,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _buildResultText(
                    'Percentage: ${_percentage.toStringAsFixed(2)}%',
                    isDarkMode,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CommentSection(pageId: "percentage"),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }

  Widget _buildCard({required Widget child, required bool isDarkMode}) {
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
      keyboardType: TextInputType
          .number, // or TextInputType.numberWithOptions(decimal: true) if needed
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
