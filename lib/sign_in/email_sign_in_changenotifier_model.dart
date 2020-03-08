import 'package:crud_db/services/auth.dart';
import 'package:crud_db/sign_in/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangeNotifierModel with EmailAndPasswordValidators, ChangeNotifier {
  //Constructor
  EmailSignInChangeNotifierModel({
      this.email ='',
      this.password ='',
      this.formType = EmailSignInType.signIn,
      this.isLoading = false,
      this.submitted = false,
      @required this.auth
      });

  final AuthBase auth;
   String email;
   String password;
   EmailSignInType formType;
 bool isLoading;
   bool submitted;

  Future<void> submit() async {
    //since this class is not statefull, the setState method is not applicable. so we use the updateWith method which connects us to the model class
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email,password);
      }
      //The navigator popUp and the Platform exception belongs to the UI
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  //When updating the model through the bloc, instead of updating and replacing the initial values above, we create a copy and replace the values in the copy.
  void updateWith({
    String email,
    String password,
    EmailSignInType formType,
    bool isLoading,
    bool submitted,
  }){
      this.email =  email ?? this.email;
      this.password =  password ?? this.password;
      this.formType = formType ?? this.formType;
      this.isLoading = isLoading ?? this.isLoading;
      this.submitted = submitted ?? this.submitted;
      notifyListeners();
  }

//Getter does not need any argument for the method
  String get primaryButtonText{
    return formType == EmailSignInType.signIn ? 'Sign In' : 'Create an account';

  }

  String get secondaryButtonText{
     return formType == EmailSignInType.signIn
        ? 'Not a member? Register'
        : 'Have an account? Sign in';

  }

  bool get canSubmit{
     return !isLoading &&
        emailValidator.isValid(email) &&
        passValidator.isValid(password);
  }

  String get passwordErrorText {
     bool showPasswordValid = submitted && !emailValidator.isValid(password);
     //invalidPAssText comes from validator.dart. accessible because of the with in the class definition
     return showPasswordValid ? invalidPassText : null;
  }

  String get emailErrorText {
    bool showEmailValid = submitted && !emailValidator.isValid(email);
    return showEmailValid ? invalidEmailText : null;
  }

   void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType(){
    updateWith(
      email: '',
      password: '',
      submitted: false,
      isLoading: false,
      formType: this.formType == EmailSignInType.signIn ? EmailSignInType.register : EmailSignInType.signIn
    );
  }


}

