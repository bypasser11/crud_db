import 'package:crud_db/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomRaisedButton {
  //Constructor of sign in button
  //taking the property of superclass
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          onPressed: onPressed,
        );
}
