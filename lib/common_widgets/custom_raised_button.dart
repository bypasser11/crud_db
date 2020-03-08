import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;
  //Dart constructor
  CustomRaisedButton({
    this.borderRadius: 2.0,
    this.child,
    this.color,
    this.onPressed,
    this.height: 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: RaisedButton(
        child: child,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        onPressed: onPressed, //Empty functions
      ),
    );
  }
}
