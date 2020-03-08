import 'dart:async';

import 'package:crud_db/services/auth.dart';
import 'package:flutter/material.dart';

class SignInBloc {
  SignInBloc({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  //Authentication stuffs that was inside the sign_in_page.dart

  Future<User> _signIn (Future<User> Function() signInMethod) async {
    //This method accept function / another method as its argument WOW
    //Returning function of type future user and signInMethod as it's argument
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally{
      isLoading.value = false;
    }
  }

  Future<User> signInAnonymously() {
    return _signIn(auth.signInAnonymously);
  }

  Future<User> signInWithGoogle() {
    return _signIn(auth.signInWithGoogle);
  }

}