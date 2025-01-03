import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../controllers/auth/auth_controller.dart';

class MyAuthProvider extends ChangeNotifier {
  bool _isLoaderShow = false;
  String? _errorMessage;

  bool get isLoaderShow => _isLoaderShow;
  String? get errorMessage => _errorMessage;

  void toggleLoader() {
    _isLoaderShow = !_isLoaderShow;
    notifyListeners();
  }

  Future<String> signUpUser ({
    required String firstName,
    required String email,
    required String password,
  }) async {
    toggleLoader(); // Show loader
    try {
      String msg = await AuthController().signUpUser (
        firstName: firstName,
        email: email,
        password: password,
      );
      return msg;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return _errorMessage!;
    } finally {
      toggleLoader(); // Hide loader
      notifyListeners();
    }
  }

  Future<String> signOutUser () async {
    toggleLoader(); // Show loader
    try {
      String msg = await AuthController().signOutUser ();

      return msg;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return _errorMessage!;
    } finally {
      toggleLoader(); // Hide loader
      notifyListeners();
    }
  }

  Future<String> signInUser ({
    required String email,
    required String password,
  }) async {
    toggleLoader(); // Show loader
    try {
      String msg = await AuthController().signInUser (
        email: email,
        password: password,
      );
      return msg;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return _errorMessage!;
    } finally {
      toggleLoader(); // Hide loader
      notifyListeners();
    }
  }

  Future<String> forgotPassword({
    required String email,
  }) async {
    toggleLoader(); // Show loader
    try {
      String msg = await AuthController().forgotUserPassword(
        email: email,
      );
      return msg;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return _errorMessage!;
    } finally {
      toggleLoader(); // Hide loader
      notifyListeners();
    }
  }

  Future<String> signInWithGoogle() async {
    toggleLoader(); // Show loader
    try {
      String msg = await AuthController().signInWithGoogle();
      return msg;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return _errorMessage!;
    } finally {
      toggleLoader(); // Hide loader
      notifyListeners();
    }
  }


}