import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loginsystems_1/login.dart';
import 'home.dart';
import 'profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '', username: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
            ),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/register.png'), fit: BoxFit.cover),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHome()),
                    );
                  },
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 35, top: 30),
                    child: Text(
                      'Create\nAccount',
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 35, right: 35),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  // ฟิลด์สำหรับ Username
                                  TextFormField(
                                    validator: RequiredValidator(
                                        errorText: "กรุณากรอก Username"),
                                    onSaved: (String? username) {
                                      if (username != null) {
                                        profile.username = username;
                                      }
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  // ฟิลด์สำหรับ Email
                                  TextFormField(
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: "กรุณากรอกอีเมล"),
                                      EmailValidator(
                                          errorText: "กรุณากรอกอีเมลให้ถูกต้อง")
                                    ]),
                                    onSaved: (String? email) {
                                      if (email != null) {
                                        profile.email = email;
                                      }
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  // ฟิลด์สำหรับ Password
                                  TextFormField(
                                    validator: RequiredValidator(
                                        errorText: "กรุณากรอกรหัสผ่าน"),
                                    onSaved: (String? password) {
                                      if (password != null) {
                                        profile.password = password;
                                      }
                                    },
                                    style: TextStyle(color: Colors.white),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  // ปุ่มสมัครสมาชิก
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 27,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Color(0xff4c505b),
                                        child: IconButton(
                                          color: Colors.white,
                                          onPressed: () async {
                                            if (formKey.currentState != null &&
                                                formKey.currentState!
                                                    .validate()) {
                                              formKey.currentState!.save();

                                              setState(() {
                                                isLoading = true;
                                              });

                                              try {
                                                // สร้างบัญชีผู้ใช้ด้วย Firebase Authentication
                                                UserCredential userCredential =
                                                    await FirebaseAuth.instance
                                                        .createUserWithEmailAndPassword(
                                                  email: profile.email,
                                                  password: profile.password,
                                                );

                                                // รับผู้ใช้ที่สร้างขึ้น
                                                User? user =
                                                    userCredential.user;

                                                // อัปเดตชื่อผู้ใช้ใน Firebase Authentication
                                                await user?.updateDisplayName(
                                                    profile.username);

                                                // เก็บข้อมูลผู้ใช้ลง Firestore
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(user?.uid)
                                                    .set({
                                                  'username': profile.username,
                                                  'email': profile.email,
                                                  'uid': user?.uid,
                                                });

                                                formKey.currentState!.reset();
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                        builder: (context) {
                                                  return MyHome();
                                                }));

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "Account created successfully!"),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              } on FirebaseAuthException catch (e) {
                                                String errorMessage = e
                                                        .message ??
                                                    "An unknown error occurred.";

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(errorMessage),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } finally {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Please fill in all fields correctly."),
                                                  backgroundColor:
                                                      Colors.orange,
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icon(Icons.arrow_forward),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyLogin()),
                                          );
                                        },
                                        child: Text(
                                          'Sign In',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isLoading)
                                    Center(child: CircularProgressIndicator()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: Text("Unexpected state."),
          ),
        );
      },
    );
  }
}
