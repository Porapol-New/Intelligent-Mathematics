import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loginsystems_1/home.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser; // ใช้ User? เพื่อรองรับ null safety

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // เปิดใช้งานลูกศรย้อนกลับ
        backgroundColor: Colors.transparent,
        elevation: 0, // ลบเงาเพื่อให้ดูสะอาดตา
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.black), // เปลี่ยนสีตัวอักษรเป็นสีดำ
        ),
        centerTitle: true, // จัดข้อความให้อยู่ตรงกลาง
        iconTheme:
            const IconThemeData(color: Colors.black), // ตั้งสีลูกศรย้อนกลับ
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // ถ้ากำลังโหลดแสดง progress indicator
            : Column(
                mainAxisSize: MainAxisSize.min, // จัดให้อยู่ตรงกลางแนวตั้ง
                children: [
                  if (user != null &&
                      user.email !=
                          null) // ตรวจสอบว่า user และ email ไม่ใช่ null
                    Column(
                      children: [
                        Text(
                          '${user.email}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20), // เพิ่มระยะห่าง
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // สีพื้นหลังปุ่ม
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // ปรับปุ่มให้มีมุมโค้ง
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true; // เริ่มโหลด
                            });
                            await auth.signOut().then((value) {
                              setState(() {
                                isLoading = false; // หยุดโหลด
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHome(),
                                ),
                              );
                            });
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16), // เปลี่ยนสีตัวอักษรเป็นสีขาว
                          ),
                        ),
                      ],
                    )
                  else
                    const Text(
                      'No user is signed in.',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                ],
              ),
      ),
    );
  }
}
