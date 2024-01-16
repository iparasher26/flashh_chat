import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  RoundedButton({required this.title, required this.colour, required this.onpressed});

  final String title;
  final Color colour;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onpressed,
          //Go to registration screen.
          // example- Navigator.pushNamed( context , RegistrationScreen.id);
          minWidth: 200.0,
          height: 42.0,
          child: Text(title,
          style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}