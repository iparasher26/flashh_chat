
import 'package:flashh_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flashh_chat/constants.dart';
import 'package:flashh_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashh_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {

  //adding static now means id is not an object anymore, it is associated with class
  // so instead of LoginScreen().id it will be LoginScreen.id
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{

  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  bool spinner = false ;

  @override
  void initState() {
    print(('inside init'));
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',  //text
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),

              const SizedBox(height: 48.0),

              TextField(
                textAlign: TextAlign.center,
               // obscureText: true,
                keyboardType: TextInputType.emailAddress ,
                onChanged: (value) {
                  email = value;
                },
                decoration: ktextField.copyWith(hintText: 'Enter your email'),
              ),

              const SizedBox(height: 8.0),

              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                keyboardType: TextInputType.emailAddress ,
                onChanged: (value) {
                  password = value;
                },
                decoration : ktextField.copyWith(hintText: 'Enter your password'),
              ),

              const SizedBox(height: 24.0),
              RoundedButton(title: 'Log In', colour: Colors.lightBlueAccent,
                  onpressed: () async {
                print('inside onpressed');
                try{
                  setState(() {
                    spinner = true;
                  });
                  final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  if (newUser!=null)  {
                    print("about to jump to chat screen");
                    Navigator.pushNamed( context , ChatScreen.id);
                    setState(() {
                      spinner = false;
                    });
                  }
                  else {
                    print('daya kuch toh gadbad hai');
                  }
                }
                catch (e){
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