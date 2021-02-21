import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeId = '/register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
                //Do something with the user input.
              },
              decoration:
                  kInputDecoration.copyWith(hintText: "Enter your Email"),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
                //Do something with the user input.
              },
              decoration:
                  kInputDecoration.copyWith(hintText: "Enter your Password"),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              text: "Register",
              onTaped: () {
                print(email);
                print(password);
                //Implement registration functionality.
              },
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
