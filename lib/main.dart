import 'package:crud_db/services/auth.dart';
import 'package:crud_db/sign_in/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
          title: 'Crud',
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: LandingPage()),
    );
  }
}
