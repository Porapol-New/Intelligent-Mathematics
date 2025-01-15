// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
// import 'dart:io'; // สำหรับเขียนไฟล์

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHome> {
  // // ฟังก์ชันสำหรับบันทึกข้อมูลลงไฟล์
  // Future<void> saveToFile(String data) async {
  //   final directory = Directory.systemTemp; // ใช้โฟลเดอร์ชั่วคราวสำหรับทดสอบ
  //   final file = File('${directory.path}/user_data.txt');

  //   // เขียนข้อมูลลงไฟล์
  //   await file.writeAsString(data, mode: FileMode.append);
  //   debugPrint('Data saved: $data');
  //   debugPrint('File location: ${file.path}');
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/home.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0), // ขยับปุ่มลง
              child: Column(
                mainAxisSize: MainAxisSize.min, // ทำให้ Column มีขนาดพอดี
                children: [
                  ElevatedButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 20, // ขนาดตัวอักษร
                        fontWeight: FontWeight.bold, // น้ำหนักตัวอักษร
                      ),
                    ),
                    onPressed: () {
                      // // บันทึกข้อมูลเมื่อกดปุ่ม
                      // saveToFile('User signed up at ${DateTime.now()}\n');
                      Navigator.pushNamed(context, 'register');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 15), // Padding ที่สมดุล
                      fixedSize: Size(300, 60), // ขนาดของปุ่ม
                      backgroundColor: Color.fromARGB(255, 255, 65, 65),
                      foregroundColor: Colors.white, // สีของฟอนต์
                    ),
                  ),
                  SizedBox(height: 20), // เพิ่มระยะห่างด้านล่างปุ่ม
                  ElevatedButton(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 20, // ขนาดตัวอักษร
                        fontWeight: FontWeight.bold, // น้ำหนักตัวอักษร
                      ),
                    ),
                    onPressed: () {
                      // บันทึกข้อมูลเมื่อกดปุ่ม
                      // saveToFile('User logged in at ${DateTime.now()}\n');
                      Navigator.pushNamed(context, 'login');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 15), // Padding ที่สมดุล
                      fixedSize: Size(300, 60), // ขนาดปุ่ม
                      backgroundColor: Colors.white, // สีพื้นหลัง
                      foregroundColor:
                          Color.fromARGB(255, 255, 65, 65), // สีของฟอนต์
                      side: BorderSide(
                        color: Color.fromARGB(255, 255, 65, 65), // สีขอบ
                        width: 2, // ความกว้างของขอบ
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
