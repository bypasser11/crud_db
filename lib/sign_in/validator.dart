abstract class Validator {
    bool isValid(String value);
}

class NonEmptyStringValidator implements Validator{
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

}

class EmailAndPasswordValidators{
  final Validator emailValidator = NonEmptyStringValidator();
  final Validator passValidator = NonEmptyStringValidator();
  final String invalidEmailText = 'Email can\'t be empty';
  final String invalidPassText = 'Password can\'t be empty';
}