// ignore_for_file: implicit_call_tearoffs, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loginsystems_1/forgot.dart';
import 'package:flutter_loginsystems_1/home.dart';
import 'package:flutter_loginsystems_1/register.dart';

import 'Menu.dart';
import 'package:form_field_validator/form_field_validator.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  bool isLoading = false;

  void showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'),
                fit: BoxFit.cover,
              ),
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
                    padding: const EdgeInsets.only(left: 35, top: 130),
                    child: const Text(
                      'Welcome\nBack',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 33,
                      ),
                    ),
                  ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.5,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 35),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: emailController,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText: "กรุณากรอกอีเมล"),
                                        EmailValidator(
                                            errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                                      ]),
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: "Email",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: passwordController,
                                      validator: RequiredValidator(
                                          errorText: "กรุณากรอกรหัสผ่าน"),
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: "Password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 65, 65),
                                            fontSize: 27,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 65, 65),
                                          child: IconButton(
                                            color: Colors.white,
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  isLoading = true;
                                                });

                                                try {
                                                  await FirebaseAuth.instance
                                                      .signInWithEmailAndPassword(
                                                    email: emailController.text
                                                        .trim(),
                                                    password:
                                                        passwordController.text,
                                                  );
                                                  showSnackbar(
                                                    context,
                                                    "Login successful!",
                                                    Colors.green,
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Mymenu()),
                                                  );
                                                } on FirebaseAuthException catch (e) {
                                                  String errorMessage;
                                                  switch (e.code) {
                                                    case 'user-not-found':
                                                      errorMessage =
                                                          "No user found for this email.";
                                                      break;
                                                    case 'wrong-password':
                                                      errorMessage =
                                                          "Incorrect password.";
                                                      break;
                                                    case 'invalid-email':
                                                      errorMessage =
                                                          "Invalid email format.";
                                                      break;
                                                    default:
                                                      errorMessage =
                                                          "An unknown error occurred.";
                                                  }
                                                  showSnackbar(
                                                    context,
                                                    errorMessage,
                                                    Colors.red,
                                                  );
                                                } finally {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                }
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.arrow_forward),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyRegister()),
                                            );
                                          },
                                          child: const Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyForgotPassword()),
                                            );
                                          },
                                          child: const Text(
                                            'Forgot password',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
