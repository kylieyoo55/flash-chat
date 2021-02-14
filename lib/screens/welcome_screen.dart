import 'package:flash_app/screens/login_screen.dart';
import 'package:flash_app/screens/registration_screen.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeId = '/welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      //upperBound: 100.0,
    );

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    //bounce effect animation
    // animation = CurvedAnimation(
    //   parent: controller,
    //   curve: Curves.decelerate,
    // );
    controller.forward();

    //to make animation in loop
    // controller.addStatusListener((status) {
    //   if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   } else if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1);
    //   }
    // });

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onTaped: () {
                //Go to login screen.
                Navigator.pushNamed(context, LoginScreen.routeId);
              },
              text: 'Log In',
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onTaped: () {
                Navigator.pushNamed(context, RegistrationScreen.routeId);
                //Go to registration screen.
              },
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton({this.color, this.text, this.onTaped});
  final Color color;
  final String text;
  final Function onTaped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onTaped,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
