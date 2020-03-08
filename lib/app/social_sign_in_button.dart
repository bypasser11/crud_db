import 'package:crud_db/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends CustomRaisedButton {
  //Constructor of sign in button
  //taking the property of superclass
  SocialSignInButton({
    @required String assetsName,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        assert(assetsName != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetsName),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              Opacity(opacity: 0.0, child: Image.asset(assetsName)),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
