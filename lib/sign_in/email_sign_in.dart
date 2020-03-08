
import 'package:crud_db/sign_in/email_sign_in_form_change_notifier_base.dart';
import 'package:flutter/material.dart';

class EmailSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Sign In'),
          elevation: 2.0,
        ),
        body: SingleChildScrollView(
                  child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: EmailSignInFormChangeNotifierBase.create(context)),
          ),
        ));
  }
}
