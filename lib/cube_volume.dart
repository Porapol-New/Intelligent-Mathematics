import 'package:flutter/material.dart';
import 'package:flutter_loginsystems_1/comment_section.dart';

void main() {
  runApp(const CubeVolumeApp());
}

class CubeVolumeApp extends StatelessWidget {
  const CubeVolumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimalist Cube Volume Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const CubeVolume(),
    );
  }
}

class CubeVolume extends StatefulWidget {
  const CubeVolume({super.key});

  @override
  _CubeVolumeState createState() => _CubeVolumeState();
}

class _CubeVolumeState extends State<CubeVolume> {
  final TextEditingController _sideController = TextEditingController();
  double _cubeVolume = 0.0;

  void _calculateCubeVolume() {
    final side = double.tryParse(_sideController.text);
    if (side == null || side <= 0) {
      _showErrorDialog('กรุณากรอกค่าด้านให้ถูกต้อง');
    } else {
      setState(() {
        _cubeVolume = side * side * side;
      });
    }
  }

  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คำอธิบายสูตรคำนวณ'),
        content: const Text(
          'การคำนวณปริมาตรของลูกบาศก์ (Cube Volume) ใช้สูตรง่าย ๆ '
          'ปริมาตร (V) = ด้าน (s) ยกกำลังสาม หรือ V = s³\n'
          'ปริมาตรของลูกบาศก์คือพื้นที่ที่ลูกบาศก์ใช้ในช่องว่าง ซึ่งสามารถคำนวณได้โดยการนำความยาวของด้านหนึ่งของลูกบาศก์มาคูณกันสามครั้ง.',
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(message),
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
        title: const Text('Cube Volume Calculator'),
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
                    'สูตรคำนวณปริมาตรทรงลูกบาศก์: ปริมาตร = ด้าน^3\n'
                    'กรุณากรอกค่าด้านของลูกบาศก์เพื่อคำนวณปริมาตร',
                    isDarkMode,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _sideController,
                    label: 'Side of Cube',
                    icon: Icons.cut_outlined,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  _buildCalculateButton(
                    label: 'Calculate',
                    onPressed: _calculateCubeVolume,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 8),
                  if (_cubeVolume != 0.0)
                    _buildResultText(
                      'Cube Volume: ${_cubeVolume.toStringAsFixed(2)}',
                      isDarkMode,
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CommentSection(pageId: "cube_volume"),
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
