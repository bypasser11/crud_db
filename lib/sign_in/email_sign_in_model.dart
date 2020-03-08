import 'package:crud_db/sign_in/validator.dart';

enum EmailSignInType { signIn, register }


class EmailSignInModel with EmailAndPasswordValidators {
  //Constructor
  EmailSignInModel({
      this.email ='',
      this.password ='',
      this.formType = EmailSignInType.signIn,
      this.isLoading = false,
      this.submitted = false,
      });

  final String email;
  final String password;
  final EmailSignInType formType;
 bool isLoading;
  final bool submitted;

  //When updating the model through the bloc, instead of updating and replacing the initial values above, we create a copy and replace the values in the copy.
  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInType formType,
    bool isLoading,
    bool submitted,
  }){
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
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
}

