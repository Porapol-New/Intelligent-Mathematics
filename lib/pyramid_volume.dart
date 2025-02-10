import 'package:flutter/material.dart';

class PyramidVolume extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pyramid Volume Calculator',
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
      home: const Pyramid(),
    );
  }
}

class Pyramid extends StatefulWidget {
  const Pyramid();

  @override
  _PyramidVolumeState createState() => _PyramidVolumeState();
}

class _PyramidVolumeState extends State<Pyramid> {
  final TextEditingController _baseLengthController = TextEditingController();
  final TextEditingController _baseWidthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _pyramidVolume = 0.0;

  void _calculatePyramidVolume() {
    final baseLength = double.tryParse(_baseLengthController.text);
    final baseWidth = double.tryParse(_baseWidthController.text);
    final height = double.tryParse(_heightController.text);
    if (baseLength == null ||
        baseWidth == null ||
        height == null ||
        baseLength <= 0 ||
        baseWidth <= 0 ||
        height <= 0) {
      _showErrorDialog('กรุณากรอกค่าที่ถูกต้อง');
      setState(() {
        _pyramidVolume = 0.0;
      });
    } else {
      setState(() {
        double baseArea = baseLength * baseWidth;
        _pyramidVolume = (1 / 3) * baseArea * height;
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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pyramid Volume Calculator'),
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
                    'สูตรคำนวณปริมาตรของปิระมิด: ปริมาตร = 1/3 × พื้นที่ฐาน × ความสูง\n'
                    'กรุณากรอกค่าพื้นที่ฐานและความสูงเพื่อคำนวณปริมาตรของปิระมิด',
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _baseLengthController,
                    label: 'Base Length',
                    icon: Icons.straighten,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _baseWidthController,
                    label: 'Base Width',
                    icon: Icons.straighten,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _heightController,
                    label: 'Pyramid Height',
                    icon: Icons.height,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _buildCalculateButton(
                    label: 'Calculate',
                    onPressed: _calculatePyramidVolume,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _pyramidVolume != 0.0
                      ? _buildResultText(
                          'Pyramid Volume: ${_pyramidVolume.toStringAsFixed(2)}',
                          isDarkMode,
                        )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(height: 20),
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

  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คำอธิบายสูตรคำนวณ'),
        content: const Text(
          'ปริมาตรของปิระมิดคำนวณโดยใช้สูตร:\n'
          'ปริมาตร = 1/3 × พื้นที่ฐาน × ความสูง\n'
          'โดยที่พื้นที่ฐานคำนวณจากความยาว × ความกว้าง',
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
}
