import 'package:firebase_auth/firebase_auth.dart';

import '../../data/auth/authentication_firebase_data.dart';
import '../../providers/bottom_navigation_provider.dart';

class AuthController {

  /// Method to sign up a new user with password and email
  Future<String> signUpUser({
    required String firstName,
    // required String lastName,
    required String email,
    required String password,
  }) async {
      final msg = await AuthenticationFirebaseData().registerUser(
        email,
        password,
        firstName,
      );
      return msg;
  }

  /// Method to sign out a  user
  Future<String> signOutUser() async {
    final msg = await AuthenticationFirebaseData().logOutUser();
    return msg;
  }

  /// Method to sign in (Login) user
  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    final msg = await AuthenticationFirebaseData().loginUser(
      email,
      password,
    );
    return msg;
  }

  /// Method to forgot password
  Future<String> forgotUserPassword({
    required String email,
  }) async {
    final msg = await AuthenticationFirebaseData().forgotPassword(
      email,
    );
    return msg;
  }

  /// Method to sign in with google
  Future<String> signInWithGoogle() async {
    final msg = await AuthenticationFirebaseData().signInWithGoogle();
    return msg;
  }


}