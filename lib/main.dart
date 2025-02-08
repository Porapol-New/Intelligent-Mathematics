import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_loginsystems_1/Menu.dart';
import 'Circle.dart';
import 'firebase_options.dart';
import 'userinfo.dart';
import 'forgot.dart';
import 'home.dart';
import 'login.dart';
import 'register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHome(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'forgot': (context) => MyForgotPassword(),
      'home': (context) => MyHome(),
      'userinfo': (context) => UserProfile(),
      'Mymenu': (context) => Mymenu(),
    },
  ));
}
