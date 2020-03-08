import 'package:crud_db/common_widgets/platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog(
      {@required String title, @required PlatformException exception})
      : super(
            content: _message(exception), title: title, defaultActionText: 'OK');

  static String _message(PlatformException exception){
    if(exception.message == 'FIRFirestoreErrorDomain') {
      if(exception.code == 'Error 7') {
        return 'Missing or insufficient permissions';
      }
    }
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String,String> _errors = {
    'ERROR_WRONG_PASSWORD':'The password is invalid',
  };
}
