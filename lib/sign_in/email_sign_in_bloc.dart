import 'dart:async';

import 'package:crud_db/services/auth.dart';
import 'package:crud_db/sign_in/email_sign_in_model.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

class EmailSigninBloc {
  EmailSigninBloc({@required this.auth});

  //using rxdart stream instead of a normal stream
  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());

  //Auth is for the submit method
  final AuthBase auth;
  //final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();

  //Output of streamcontroller
  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  //EmailSignInModel _model = EmailSignInModel();
  EmailSignInModel get _model => _modelSubject.value;

  //Dispose controller
  void dispose(){
    _modelSubject.close();
  }

  //Update model of the stream
  void updateWith({
    String email,
    String password,
    EmailSignInType formType,
    bool isLoading,
    bool submitted,
  }) {
    //Update model
    _modelSubject.add( _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    ));
    //add updated model to _modelController. no longer needed since using rxdart
    //_modelSubject.add(_model);
  }

  //Copied from the email_sign_in_form.dart. this is the logic that should be put inside the bloc
  Future<void> submit() async {
    //since this class is not statefull, the setState method is not applicable. so we use the updateWith method which connects us to the model class
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
      //The navigator popUp and the Platform exception belongs to the UI
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

    //Update email method instead of calling the onChanged: (password) => widget.bloc.updateWith(password: password) in _buildPasswordTextField
  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType(){
    updateWith(
      email: '',
      password: '',
      submitted: false,
      isLoading: false,
      formType: _model.formType == EmailSignInType.signIn ? EmailSignInType.register : EmailSignInType.signIn
    );
  }

}