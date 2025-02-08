import 'package:flutter/material.dart';

class PyramidSurfaceAreaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pyramid Surface Area Calculator',
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
      home: const PyramidSurfaceArea(),
    );
  }
}

class PyramidSurfaceArea extends StatefulWidget {
  const PyramidSurfaceArea();

  @override
  _PyramidSurfaceAreaState createState() => _PyramidSurfaceAreaState();
}

class _PyramidSurfaceAreaState extends State<PyramidSurfaceArea> {
  final TextEditingController _baseAreaController = TextEditingController();
  final TextEditingController _basePerimeterController =
      TextEditingController();
  final TextEditingController _slantHeightController = TextEditingController();
  double _surfaceArea = 0.0;

  void _calculateSurfaceArea() {
    final baseArea = double.tryParse(_baseAreaController.text);
    final basePerimeter = double.tryParse(_basePerimeterController.text);
    final slantHeight = double.tryParse(_slantHeightController.text);

    if (baseArea == null ||
        baseArea <= 0 ||
        basePerimeter == null ||
        basePerimeter <= 0 ||
        slantHeight == null ||
        slantHeight <= 0) {
      _showErrorDialog('กรุณากรอกค่าที่ถูกต้อง');
      setState(() {
        _surfaceArea = 0.0;
      });
    } else {
      setState(() {
        _surfaceArea = baseArea + 0.5 * basePerimeter * slantHeight;
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
          'การคำนวณพื้นที่ผิวของปิระมิดใช้สูตร: \n'
          'พื้นที่ผิวรวม = พื้นที่ฐาน + พื้นที่ผิวด้านข้าง\n\n'
          'พื้นที่ฐาน = ความยาวฐาน × ความกว้างฐาน\n'
          'พื้นที่ผิวด้านข้าง = 1/2 × (ความยาวฐาน + ความกว้างฐาน) × ความเอียงของปิระมิด',
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
        title: const Text('Pyramid Surface Area Calculator'),
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
                    'สูตรคำนวณพื้นที่ผิวของปิระมิด: พื้นที่ผิวรวม = พื้นที่ฐาน + พื้นที่ผิวด้านข้าง\n'
                    'กรุณากรอกค่าความยาวฐาน, ความกว้างฐาน และความเอียงเพื่อคำนวณพื้นที่ผิว',
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _baseAreaController,
                    label: 'Base Area (B)',
                    icon: Icons.square_foot,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _basePerimeterController,
                    label: 'Base Perimeter (P)',
                    icon: Icons.straighten,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _slantHeightController,
                    label: 'Slant Height (l)',
                    icon: Icons.height,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _buildCalculateButton(
                    label: 'Calculate',
                    onPressed: _calculateSurfaceArea,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _surfaceArea != 0.0
                      ? _buildResultText(
                          'Surface Area: ${_surfaceArea.toStringAsFixed(2)}',
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
}
