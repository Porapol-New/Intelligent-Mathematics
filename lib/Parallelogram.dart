import 'package:flutter/material.dart';

class ParallelogramCalculator extends StatefulWidget {
  const ParallelogramCalculator({Key? key}) : super(key: key); // Added const

  @override
  _ParallelogramCalculatorState createState() =>
      _ParallelogramCalculatorState();
}

class _ParallelogramCalculatorState extends State<ParallelogramCalculator> {
  final TextEditingController _baseController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _area = 0.0;

  static const String formulaExplanation = // Moved and made static const
      'การคำนวณพื้นที่ของสี่เหลี่ยมด้านขนานใช้สูตรง่าย ๆ คือ:\n'
      'พื้นที่ = ฐาน × ความสูง\n\n'
      'โดย:\n'
      '- ฐาน (Base) คือความยาวด้านล่างของสี่เหลี่ยมด้านขนาน\n'
      '- ความสูง (Height) คือระยะตั้งฉากจากฐานถึงด้านตรงข้าม';

  void _calculateArea() {
    final base = double.tryParse(_baseController.text);
    final height = double.tryParse(_heightController.text);

    if (base == null || height == null || base <= 0 || height <= 0) {
      // Combined conditions and added checks for <= 0
      _showErrorDialog(
          'กรุณากรอกข้อมูลที่ถูกต้องสำหรับ ฐาน และ ความสูง'); // More specific error message
      setState(() {
        _area = 0.0; // Reset area on error
      });
    } else {
      setState(() {
        _area = base * height;
      });
    }
  }

  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คำอธิบายสูตรคำนวณ'), // Added const
        content: Text(formulaExplanation), // Used the static const variable
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'), // Added const
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    // Made error message dynamic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Error'), // Added const
        content: Text(errorMessage), // Used dynamic error message
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'), // Added const
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness ==
        Brightness.dark; // Get theme from context

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parallelogram Area Calculator'), // Added const
        backgroundColor: isDarkMode
            ? Colors.black
            : const Color(0xFFFAFAFA), // Consistent background color
        elevation: 0,
        centerTitle: true,
        titleTextStyle:
            TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline), // Added const
            onPressed: _showFormulaExplanation,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Added const
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCard(
              isDarkMode: isDarkMode, // Pass isDarkMode to _buildCard
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDescriptionText(
                    'สูตรคำนวณพื้นที่สี่เหลี่ยมด้านขนาน: พื้นที่ = ฐาน × ความสูง\n'
                    'กรุณากรอกค่า ฐาน และ ความสูง เพื่อคำนวณพื้นที่',
                    isDarkMode, // Pass isDarkMode
                  ),
                  const SizedBox(height: 10), // Added const
                  _buildTextField(
                    controller: _baseController,
                    label: 'Base of Parallelogram',
                    icon: Icons.square_foot,
                    isDarkMode: isDarkMode, // Pass isDarkMode
                  ),
                  const SizedBox(height: 10), // Added const
                  _buildTextField(
                    controller: _heightController,
                    label: 'Height of Parallelogram',
                    icon: Icons.height,
                    isDarkMode: isDarkMode, // Pass isDarkMode
                  ),
                  const SizedBox(height: 8), // Added const
                  _buildCalculateButton(
                    label: 'Calculate',
                    onPressed: _calculateArea,
                    isDarkMode: isDarkMode, // Pass isDarkMode
                  ),
                  const SizedBox(height: 8), // Added const
                  _buildResultText(
                      'Area: $_area', isDarkMode), // Pass isDarkMode
                ],
              ),
            ),
            const SizedBox(height: 20), // Added const
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }

  Widget _buildCard({required Widget child, required bool isDarkMode}) {
    // Added isDarkMode parameter
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Added const
        child: child,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode, // Added isDarkMode parameter
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
    required bool isDarkMode, // Added isDarkMode parameter
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.white : Colors.black,
        foregroundColor: isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // Added const
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18), // Added const
      ),
    );
  }

  Widget _buildResultText(String text, bool isDarkMode) {
    // Added isDarkMode parameter
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
    // Added isDarkMode parameter
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: isDarkMode ? Colors.white70 : Colors.grey[800],
      ),
    );
  }
}
