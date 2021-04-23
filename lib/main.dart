import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mybusiness/screens/home_screen.dart';
import 'package:mybusiness/screens/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isAndroid) runApp(MyAndroidApp());
}

class MyAndroidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null)
              return LoginScreen();
            else
              return HomeScreen();
          }
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
