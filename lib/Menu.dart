// ignore_for_file: use_key_in_widget_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_loginsystems_1/cone_volume.dart';
import 'package:flutter_loginsystems_1/cube_volume.dart';
import 'package:flutter_loginsystems_1/ellipse.dart';
import 'package:flutter_loginsystems_1/parallelogram.dart';
import 'package:flutter_loginsystems_1/percentage.dart';
import 'package:flutter_loginsystems_1/pyramid_surface_area.dart';
import 'package:flutter_loginsystems_1/pyramid_volume.dart';
import 'package:flutter_loginsystems_1/sphere_volume.dart';
import 'package:flutter_loginsystems_1/trapezoid.dart';
import 'package:flutter_loginsystems_1/triangle.dart';
import 'package:flutter_loginsystems_1/userinfo.dart';
// import 'Cubes.dart';
import 'rectangle.dart';
import 'circle.dart';

void main() async {
  // เริ่มต้นการใช้งาน Firebase ก่อนที่แอปจะเริ่มทำงาน
  await Firebase.initializeApp(
    name: 'menuApp',
    options: FirebaseOptions(
      apiKey: "AIzaSyBCxHLO6YkKfy1Rz5lruP9d7ohqwfPFUnk",
      appId: "1:376512958685:ios:3b66d3ce14218e69ae8b34",
      messagingSenderId: "376512958685",
      projectId: "fluttercalculator-8fe21",
    ),
  );
  runApp(Mymenu()); // รันแอปหลักที่ชื่อ Mymenu
}

class Mymenu extends StatefulWidget {
  @override
  _MymenuState createState() => _MymenuState();
}

class _MymenuState extends State<Mymenu> {
  // ตัวแปรในการจัดการโหมดธีม (แสงหรือมืด)
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ปิดแถบ debug
      title: 'Home',
      theme: ThemeData(
        brightness: Brightness.light, // โหมดธีมแบบสว่าง
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // โหมดธีมแบบมืด
      ),
      themeMode: _themeMode, // เปลี่ยนธีมตามที่ผู้ใช้เลือก
      home: HomeScreen(
        onThemeChanged: (bool isDarkMode) {
          setState(() {
            _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
          });
        },
      ),
      onGenerateRoute: (RouteSettings settings) {
        // จัดการเส้นทางการนำทางตามชื่อเส้นทาง
        final routeName = settings.name;

        if (routeName == '/Circlearea') {
          return MaterialPageRoute(builder: (context) => CircleArea());
        } else if (routeName == '/Rectangle') {
          return MaterialPageRoute(builder: (context) => RectangleArea());
        } else if (routeName == '/CubeVolume') {
          return MaterialPageRoute(builder: (context) => CubeVolume());
        } else if (routeName == '/Triangle') {
          return MaterialPageRoute(builder: (context) => Triangle());
        } else if (routeName == '/Sphere') {
          return MaterialPageRoute(builder: (context) => Sphere());
        } else if (routeName == '/Cone') {
          return MaterialPageRoute(builder: (context) => Cone());
        } else if (routeName == '/ParallelogramCalculator') {
          return MaterialPageRoute(
              builder: (context) => ParallelogramCalculator());
        } else if (routeName == '/TrapezoidAreaCalculator') {
          return MaterialPageRoute(builder: (context) => TrapezoidArea());
        } else if (routeName == '/Ellipse') {
          return MaterialPageRoute(builder: (context) => EllipseArea());
        } else if (routeName == '/Pyramid') {
          return MaterialPageRoute(builder: (context) => Pyramid());
        } else if (routeName == '/PyramidSurfaceArea') {
          return MaterialPageRoute(builder: (context) => PyramidSurfaceArea());
        } else if (routeName == '/PercentageCalculator') {
          return MaterialPageRoute(
              builder: (context) => PercentageCalculator());
        } else {
          return MaterialPageRoute(
            builder: (context) =>
                NotFoundScreen(), // ถ้าเส้นทางไม่พบ ให้แสดงหน้าจอไม่พบ
          );
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool>
      onThemeChanged; // ตัวแปร Callback เพื่อแจ้งการเปลี่ยนแปลงธีม

  const HomeScreen({required this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = ""; // ตัวแปรสำหรับเก็บคำค้นหาเพื่อกรองรายการเมนู

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness ==
        Brightness.dark; // ตรวจสอบว่าใช้ธีมมืดหรือสว่าง

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Calculation'),
        actions: [
          // ไอคอนสำหรับสลับระหว่างโหมดมืดและสว่าง
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              widget.onThemeChanged(!isDarkMode); // เปลี่ยนธีมเมื่อกดปุ่ม
            },
          ),
          // ไอคอนสำหรับไปที่หน้าประวัติผู้ใช้
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ช่องกรอกคำค้นหาสำหรับกรองรายการเมนู
            TextField(
              decoration: InputDecoration(
                hintText: 'Search calculations...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // อัปเดตคำค้นหาตามที่พิมพ์
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              // StreamBuilder เพื่อดึงข้อมูลเมนูจาก Firebase
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('menuItems')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No calculations found'));
                  }

                  // กรองเอกสารที่ตรงกับคำค้นหา
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                        child: Text('No matching calculations found'));
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      return MenuCard(
                        title: doc['title'],
                        iconName: doc['icon'],
                        routeName: doc['route'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MenuCard extends StatelessWidget {
//   final String title;
//   final String iconName;
//   final String routeName;

//   const MenuCard({
//     required this.title,
//     required this.iconName,
//     required this.routeName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     IconData icon = _getIconFromName(iconName); // รับไอคอนจากชื่อที่กำหนด

//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(
//             context, routeName); // นำทางไปยังเส้นทางที่กำหนดเมื่อคลิก
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.circular(20), // การตั้งค่ามุมของการ์ดให้กลม
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 50), // Display icon
//             SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12, // Adjust font size if needed
//               ),
//             ), // Display menu name
//           ],
//         ),
//       ),
//     );
//   }

//   // ฟังก์ชันเพื่อจับคู่ชื่อไอคอนกับไอคอนที่แท้จริง
//   IconData _getIconFromName(String iconName) {
//     Map<String, IconData> iconMap = {
//       'Circle': Icons.circle_outlined,
//       'Rectangle': Icons.rectangle_outlined,
//       'CubeVolume': Icons.square,
//       'Triangle': Icons.change_history_sharp,
//       'SphereVolume': Icons.circle_rounded,
//       'ConeVolume': Icons.category_rounded,
//       'Parallelogram': Icons.crop_square,
//       'Trapezoid': Icons.widgets_rounded,
//       'Ellipse': Icons.egg,
//       'PyramidVolume': Icons.change_history_sharp,
//       'PyramidSurfaceArea': Icons.widgets_outlined,
//       'Percentage': Icons.percent_outlined,
//     };

//     return iconMap[iconName] ??
//         Icons.help_outline; // ถ้าไม่พบไอคอนให้ใช้ไอคอนช่วยเหลือ
//   }
// }

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Found'),
      ),
      body: Center(
        child: Text(
          'Page not found', // แสดงข้อความเมื่อไม่พบเส้นทาง
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String iconName;
  final String routeName;

  const MenuCard({
    required this.title,
    required this.iconName,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/$iconName.webp', // โหลดภาพจาก assets/icons/
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: Colors.red, size: 50);
              },
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
