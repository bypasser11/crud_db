import 'package:crud_db/common_widgets/from_submit_button.dart';
import 'package:crud_db/common_widgets/platform_exception_alert_dialog.dart';
import 'package:crud_db/services/auth.dart';
import 'package:crud_db/sign_in/email_sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_model.dart';

//This whole codes was copied from the Email_sign_in_form.dart and modified
class EmailSignInFormBlocBase extends StatefulWidget  {
  EmailSignInFormBlocBase({@required this.bloc});

  final EmailSigninBloc bloc;

  static Widget create(BuildContext context){
    final AuthBase auth =  Provider.of<AuthBase>(context);
    return Provider<EmailSigninBloc>(
      create: (context) => EmailSigninBloc(auth: auth),
      child: Consumer<EmailSigninBloc>(
        builder: (context,bloc,_) => EmailSignInFormBlocBase(bloc: bloc,) ,
      ),
      dispose: (context,bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBaseState createState() => _EmailSignInFormBlocBaseState();
}

class _EmailSignInFormBlocBaseState extends State<EmailSignInFormBlocBase> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFN = FocusNode();
  final FocusNode _passwordFN = FocusNode();

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

  Future<void> _submit() async {
    //Set state is removed, submit method is now an Future type
    try {
      //widget is used because we extends the bloc from the other class
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign In Failed',
        exception: e,
      ).show(context);
    }  
  }

  void _emailEditingComplete(EmailSignInModel model) {
    //if email is valid == passwordFN will be chosen, means it will skip to password, if not it will stay there
    final newFocus = model.emailValidator.isValid(model.email)
     ? _passwordFN 
     : _emailFN;
    FocusScope.of(context).requestFocus(newFocus);
    //If focus lost in _emailFN, focusscope in _passwordFN
  }

  void _toggleFormType(EmailSignInModel model) {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
  
    return [
      //EMail
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      //Password
      _buildPasswordTextField(model),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit
            ? _submit
            : null, //is submitEnabled true == _submitForm, else null
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? () => _toggleFormType(model) : null,
      ),
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
   
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFN,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading = false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => widget.bloc.updatePassword(password), //either that or just widget.bloc.updatePassword because the required object is the same 
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    
    return TextField(
      controller: _emailController,
      focusNode: _emailFN,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'jeff@gmail.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false, //Disable auto suggest by keyboard
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => widget.bloc.updateEmail(email), //either that or just widget.bloc.updateEmail because the required object is the same 
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //Specify the size of the card as min as possible
            mainAxisSize: MainAxisSize.min,
            //All the children widget will stretch to it's max size of the card
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(model),
          ),
        );
      }
    );
  }
}
