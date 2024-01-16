import 'package:flashh_chat/screens/login_screen.dart';
import 'package:flashh_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashh_chat/components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {

  //adding static now means id is not an object anymore, it is associated with class
  // so instead of LoginScreen().id it will be LoginScreen.id
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

   late AnimationController controller ;
   late Animation animation ;

  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation =
        ColorTween(begin: Colors.pink, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // dispose controller everytime we exit this screen
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
                    height: 65.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                TypewriterAnimatedTextKit(
                  isRepeatingAnimation: false,
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    color: Colors.black54,
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
                title: 'LOG INNN', colour: Colors.blueAccent, onpressed: (){
                  print("jaya idiot");
                  Navigator.pushNamed( context ,LoginScreen.id);},),
            RoundedButton(
                title: 'Registaaarrrr', colour: Colors.blueAccent, onpressed: (){ Navigator.pushNamed( context , RegistrationScreen.id);},),
          ],
        ),
      ),
    );
  }
}
