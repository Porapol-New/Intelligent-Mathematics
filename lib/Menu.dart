// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_loginsystems_1/Cone%20Volume.dart';
import 'package:flutter_loginsystems_1/Cube%20Volume.dart';
import 'package:flutter_loginsystems_1/Ellipse.dart';
import 'package:flutter_loginsystems_1/Parallelogram.dart';
import 'package:flutter_loginsystems_1/Percentage.dart';
import 'package:flutter_loginsystems_1/Pyramid%20Surface%20Area.dart';
import 'package:flutter_loginsystems_1/Pyramid%20Volume.dart';
import 'package:flutter_loginsystems_1/Sphere%20Volume.dart';
import 'package:flutter_loginsystems_1/Trapezoid.dart';
import 'package:flutter_loginsystems_1/Triangle.dart';
import 'package:flutter_loginsystems_1/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Rectangle.dart';
import 'Circle.dart';

void main() async {
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
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme(); // Load theme preference on app start
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

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
          _saveTheme(isDarkMode); // Save theme when changed
        },
      ),
      onGenerateRoute: (RouteSettings settings) {
        final routeName = settings.name;

        return MaterialPageRoute(
          builder: (context) {
            switch (routeName) {
              case '/Circlearea':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: Circlearea());
              case '/Rectangle':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: RectangleCalculator());
              case '/CubeVolume':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: CubeVolume());
              case '/Triangle':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: Triangle());
              case '/Sphere':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: Sphere());
              case '/Cone':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: Cone());
              case '/ParallelogramCalculator':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: ParallelogramCalculator());
              case '/TrapezoidAreaCalculator':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: TrapezoidAreaCalculator());
              case '/Ellipse':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: Ellipse());
              case '/Pyramid':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: Pyramid());
              case '/PyramidSurfaceArea':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: PyramidSurfaceArea());
              case '/PercentageCalculator':
                return Theme(
                    data: _themeMode == ThemeMode.dark
                        ? ThemeData.dark()
                        : ThemeData.light(),
                    child: PercentageCalculator());
              default:
                return NotFoundScreen();
            }
          },
        );
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
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              widget.onThemeChanged(!isDarkMode); // Toggle theme
            },
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(),
                ),
              );
            },
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                      child: Text('No matching calculations found'),
                    );
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
                        imagePath:
                            doc['icon'], // Use image path instead of icon
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
  final String imagePath; // Use imagePath for better clarity
  final String routeName;

  const MenuCard({
    required this.title,
    required this.imagePath,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath, // Use image from assets
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(title),
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
