import 'package:crud_db/app/home/homepage.dart';
import 'package:crud_db/app/sign_in_page.dart';
import 'package:crud_db/services/auth.dart';
import 'package:crud_db/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //listen is false to prevent the landing page to rebuild when the navigation takes place
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged, //from where
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            //Here we use the Bloc create method to implement the BLoC
            return SignInPage.create(context);
          } else {
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                child: HomePage(),
                create: (_) => FirestoreDatabase(uid: user.uid),
              ),
            );
          }
        } else {
          //no data in the snapshot && show spinner to wait
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
