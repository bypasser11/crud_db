import 'package:flutter/material.dart';

//This page serve to improve user experience. Instead of showing empty page to the new user, this page will be the substitute

class EmptyContent extends StatelessWidget {
  const EmptyContent(
      {Key key,
      this.message = 'Add new job to get started',
      this.title = 'Nothing here'})
      : super(key: key);

  final String message;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 32.0, color: Colors.black54),
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
