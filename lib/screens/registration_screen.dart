import 'package:flashh_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flashh_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {

  //adding static now means id is not an object anymore, it is associated with class
  // so instead of LoginScreen().id it will be LoginScreen.id
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  late String email;
  late String password;
  bool spinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress ,
                onChanged: (value) {
                  email=value;
                },
                decoration: ktextField.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                keyboardType: TextInputType.emailAddress ,
                onChanged: (value) {
                  password=value;
                },
                decoration: ktextField.copyWith(hintText: 'Enter your password'),),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Register', colour: Colors.blueAccent,
                  onpressed: ()
                  {
                try{
                  setState(() {
                    spinner = true;
                  });

                  final newUser = _auth.createUserWithEmailAndPassword(email: email, password: password);
                  if (newUser!=null){
                    Navigator.pushNamed( context , ChatScreen.id);
                  }
                  setState(() {
                    spinner = false;
                  });
                }
                catch(e){
                  print(e);
                }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}