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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // เปิดใช้งานลูกศรย้อนกลับ
        backgroundColor: isDarkMode
            ? Colors.black
            : Colors.white, // เปลี่ยนสีพื้นหลัง AppBar ตามธีม
        elevation: 0, // ลบเงาเพื่อให้ดูสะอาดตา
        title: Text(
          'Account',
          style: TextStyle(
              color: isDarkMode
                  ? Colors.white
                  : Colors.black), // ปรับสีตัวอักษรตามธีม
        ),
        centerTitle: true, // จัดข้อความให้อยู่ตรงกลาง
        iconTheme: IconThemeData(
            color:
                isDarkMode ? Colors.white : Colors.black), // ปรับสีไอคอนตามธีม
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // ถ้ากำลังโหลดแสดง progress indicator
            : Column(
                mainAxisSize: MainAxisSize.min, // จัดให้อยู่ตรงกลางแนวตั้ง
                children: [
                  if (user != null && user.email != null)
                    Column(
                      children: [
                        // ใช้ Icon แทน CircleAvatar
                        Icon(
                          Icons.account_circle,
                          size: 100, // ปรับขนาดของ Icon
                          color: isDarkMode
                              ? Colors.white
                              : Colors.black, // ปรับสีของ Icon
                        ),
                        const SizedBox(height: 5),
                        // ชื่อผู้ใช้
                        Text(
                          '${user.displayName ?? "No name"}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // อีเมลของผู้ใช้
                        Text(
                          '${user.email}',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDarkMode ? Colors.white : Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await auth.signOut().then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHome(),
                                ),
                              );
                            });
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: isDarkMode ? Colors.black : Colors.white,
                              fontSize: 16,
                            ),
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
