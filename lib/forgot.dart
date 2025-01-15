import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class MyForgotPassword extends StatefulWidget {
  const MyForgotPassword({Key? key}) : super(key: key);

  @override
  _MyForgotPasswordState createState() => _MyForgotPasswordState();
}

class _MyForgotPasswordState extends State<MyForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // เซ็นอินด้วยรหัสผ่านเก่าเพื่อยืนยันตัวตน
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _oldPasswordController.text.trim(),
        );

        // ตรวจสอบว่า User ปัจจุบันยังอยู่ในเซสชัน
        if (userCredential.user == null) {
          throw FirebaseAuthException(
              code: 'no-current-user',
              message: 'User session expired. Please login again.');
        }

        // อัปเดตรหัสผ่าน
        await userCredential.user
            ?.updatePassword(_newPasswordController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password reset successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "No user found with this email.";
            break;
          case 'wrong-password':
            errorMessage = "Incorrect old password.";
            break;
          case 'weak-password':
            errorMessage = "New password is too weak.";
            break;
          case 'no-current-user':
            errorMessage = e.message!;
            break;
          default:
            errorMessage = e.message ?? "An unknown error occurred.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        // จัดการข้อผิดพลาดทั่วไป
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An unexpected error occurred: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/forgot.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Reset\nYour password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 33,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.35,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 35),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: MultiValidator([
                                RequiredValidator(errorText: "กรุณากรอกอีเมล"),
                                EmailValidator(
                                    errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                              ]),
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _oldPasswordController,
                              validator: RequiredValidator(
                                  errorText: "กรุณากรอกรหัสผ่านเก่า"),
                              style: TextStyle(color: Colors.black),
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Old password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _newPasswordController,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "กรุณากรอกรหัสผ่านใหม่"),
                                MinLengthValidator(6,
                                    errorText:
                                        "รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัว"),
                              ]),
                              style: TextStyle(color: Colors.black),
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "New password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "กรุณากรอกข้อมูลให้ถูกต้อง";
                                }
                                if (value != _newPasswordController.text) {
                                  return "รหัสผ่านยืนยันไม่ตรงกับรหัสผ่านใหม่";
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.black),
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Confirm password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Confirm',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 65, 65),
                                          fontSize: 27,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Color.fromARGB(255, 255, 65, 65),
                                        child: IconButton(
                                          color: Colors.white,
                                          onPressed: _resetPassword,
                                          icon: Icon(Icons.arrow_forward),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
