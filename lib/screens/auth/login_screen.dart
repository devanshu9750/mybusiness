import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mybusiness/screens/components.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '', _password = '';

  _login() {
    Components.showLoading(context);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((value) => Navigator.of(context).pop())
        .catchError((error) {
      context.pop();
      Fluttertoast.showToast(msg: error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: VStack(
          [
            "My Business".text.size(20).make(),
            SizedBox(
              height: 20,
            ),
            VxTextField(
              labelText: "Email",
              borderType: VxTextFieldBorderType.roundLine,
              borderRadius: 10,
              onChanged: (value) => _email = value.trim(),
            ),
            SizedBox(
              height: 20,
            ),
            VxTextField(
              labelText: "Password",
              borderType: VxTextFieldBorderType.roundLine,
              borderRadius: 10,
              obscureText: true,
              onChanged: (value) => _password = value.trim(),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _login(),
              child: "Login".text.make(),
            )
          ],
          crossAlignment: CrossAxisAlignment.center,
        ).p(15),
      ),
    );
  }
}
