import 'package:crud_db/app/sign_in_button.dart';
import 'package:crud_db/common_widgets/platform_exception_alert_dialog.dart';
import 'package:crud_db/services/auth.dart';
import 'package:crud_db/sign_in/email_sign_in.dart';
import 'package:crud_db/sign_in/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:crud_db/app/social_sign_in_button.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc, @required this.isLoading}) : super(key: key);

  final SignInBloc bloc;
  final bool isLoading;

  //this method actually split the stateful widget into 2 part of builder(SignInBloc) and the child(SignInPage)
  //And will be used in the BLoC implementations
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);

    //to use the ValueNotifier in the bloc data
    return ChangeNotifierProvider<ValueNotifier<bool>>(
        create: (_) => ValueNotifier<bool>(false),
        //consumer is used to register the value changes. SO it will reload the new updates
        child: Consumer<ValueNotifier<bool>>(
          builder: (_, isLoading, __) => Provider<SignInBloc>(
            //Underscore is arguments that are not in need
            create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
            child: Consumer<SignInBloc>(
              builder: (context, bloc, _) => SignInPage( bloc: bloc, isLoading: isLoading.value,)),
      ),
      ),
    );
  }

  void showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnon(BuildContext context) async {
    try {  
      await bloc.signInAnonymously();
    } on PlatformException catch (e) {
      showSignInError(context, e);
    } 
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        showSignInError(context, e);
      }
    } 
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0), //EdgeInsets accepts double value!
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, //Streches the column size! it ovverides the width of the column
        mainAxisAlignment: MainAxisAlignment.center, //Vertical alignment
        children: <Widget>[
          //sized box --> Fixed spaces between container
          SizedBox(height: 50.0, child: _buildHeader()),
          SizedBox(height: 48.0),
          SocialSignInButton(
            text: 'Sign in with Google',
            assetsName: 'images/2.0x/google-logo.png',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: 'Sign in with Facebook',
            assetsName: 'images/2.0x/facebook-logo.png',
            textColor: Colors.white,
            color: Colors.grey,//Color(0xFF334D92),
            onPressed: null,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.black87,
            color: Colors.teal[700],
            onPressed: () => isLoading ? null : _signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'or',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in Anonymously',
            textColor: Colors.black87,
            color: Colors.lime[300],
            onPressed: () => isLoading ? null : _signInAnon(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
