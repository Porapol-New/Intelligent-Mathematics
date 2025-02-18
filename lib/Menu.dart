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
import 'rectangle.dart';
import 'circle.dart';
import 'formula_manager.dart'; // หน้า FormulaManager สำหรับจัดการสูตรคำนวณ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'menuApp',
    options: FirebaseOptions(
      apiKey: "AIzaSyBCxHLO6YkKfy1Rz5lruP9d7ohqwfPFUnk",
      appId: "1:376512958685:ios:3b66d3ce14218e69ae8b34",
      messagingSenderId: "376512958685",
      projectId: "fluttercalculator-8fe21",
    ),
  );
  runApp(Mymenu());
}

class Mymenu extends StatefulWidget {
  @override
  _MymenuState createState() => _MymenuState();
}

class _MymenuState extends State<Mymenu> {
  // ตัวแปรสำหรับธีม (แสงหรือมืด)
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: HomeScreen(
        onThemeChanged: (bool isDarkMode) {
          setState(() {
            _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
          });
        },
      ),
      onGenerateRoute: (RouteSettings settings) {
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
        } else if (routeName == '/FormulaManager') {
          // เส้นทางสำหรับหน้าจัดการสูตรคำนวณ
          return MaterialPageRoute(builder: (context) => FormulaManager());
        } else {
          return MaterialPageRoute(
            builder: (context) => NotFoundScreen(),
          );
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({required this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Calculation'),
        actions: [
          // ไอคอนสำหรับสูตรคำนวณ (Formula Manager)
          IconButton(
            icon: Icon(Icons.functions),
            tooltip: 'สูตรคำนวณของฉัน',
            onPressed: () {
              Navigator.pushNamed(context, '/FormulaManager');
            },
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              widget.onThemeChanged(!isDarkMode);
            },
          ),
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
            // ช่องค้นหา
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
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              // ดึงรายการเมนูจาก Firestore
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
                      // กรองไม่ให้แสดงเมนูสูตรคำนวณใน GridView
                      if (doc['route'] == '/FormulaManager') {
                        return SizedBox.shrink();
                      }
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
              'assets/icons/$iconName.webp',
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

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Found'),
      ),
      body: Center(
        child: Text(
          'Page not found',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
