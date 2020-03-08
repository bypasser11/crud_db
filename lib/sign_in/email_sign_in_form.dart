import 'package:crud_db/common_widgets/from_submit_button.dart';
import 'package:crud_db/common_widgets/platform_exception_alert_dialog.dart';
import 'package:crud_db/services/auth.dart';
import 'package:crud_db/sign_in/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_model.dart';

//This class is not in use anymore. It exists to compare itself with the BLoCs method
class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFN = FocusNode();
  final FocusNode _passwordFN = FocusNode();

  String get _email => _emailController.text;
  String get _pass => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  //Default form type of the page
  EmailSignInType _formType = EmailSignInType.signIn;

  @override
  void dispose(){
    //Properly dispossing the widgets
    _emailController.dispose();
    _passwordController.dispose();
    _emailFN.dispose();
    _passwordFN.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true; //Set this to true just before the submit method down below
    });
    try {
      final auth = Provider.of<AuthBase>(context);
      if (_formType == EmailSignInType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _pass);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _pass);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign In Failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        //in case of failure, reset back
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    //if email is valid == passwordFN will be chosen, means it will skip to password, if not it will stay there
    final newFocus =
        widget.emailValidator.isValid(_email) ? _passwordFN : _emailFN;
    FocusScope.of(context).requestFocus(newFocus);
    //If focus lost in _emailFN, focusscope in _passwordFN
  }

  void _toggleFormType() {
    setState(() {
      //If register account button is toggled == reset value of submitted (if it ever was true)
      _submitted = false;
      _formType = _formType == EmailSignInType.signIn
          ? //Is it equal to that? if not second choice
          EmailSignInType.register
          : EmailSignInType.signIn;
    });

    _emailController.clear();
    _passwordController.clear();
  }

//Build children whenever the user pop up the sign in via email button
  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInType.signIn ? 'Sign In' : 'Create an account';

    final secondaryType = _formType == EmailSignInType.signIn
        ? 'Not a member? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = !_isLoading &&
        widget.emailValidator.isValid(_email) &&
        widget.passValidator.isValid(_pass);

    return [
      //EMail
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      //Password
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled
            ? _submit
            : null, //is submitEnabled true == _submitForm, else null
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(secondaryType),
        onPressed: !_isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showPasswordValid =
        _submitted && !widget.emailValidator.isValid(_pass);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFN,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showPasswordValid ? widget.invalidPassText : null,
        enabled: _isLoading = false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) =>
          _updateState(), //to update the state and rebuild if there's changes in the textfield
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showEmailValid = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFN,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'jeff@gmail.com',
        errorText: showEmailValid ? widget.invalidEmailText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false, //Disable auto suggest by keyboard
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        //Specify the size of the card as min as possible
        mainAxisSize: MainAxisSize.min,
        //All the children widget will stretch to it's max size of the card
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
