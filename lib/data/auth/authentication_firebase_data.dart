import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationFirebaseData {
   FirebaseAuth _auth =FirebaseAuth.instance;
   FirebaseFirestore _firestore = FirebaseFirestore.instance;

   // Future<String> registerUser (final String email, final String password) async {
   //   try {
   //     var userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
   //
   //     // Create a user document in Firestore
   //     await _firestore.collection('users').doc(userCredential.user!.uid).set({
   //       'email': email,
   //       'createdAt': Timestamp.now(),
   //       // Add other user fields as needed
   //     });
   //
   //     // Create a shop owner document in the shopOwners collection
   //     await _firestore.collection('shopOwners').doc(userCredential.user!.uid).set({
   //       'email': email,
   //       'createdAt': Timestamp.now(),
   //       // Add other fields as needed
   //     });
   //
   //     // Create subcollections (optional, you can add them later)
   //     await _firestore.collection('shopOwners').doc(userCredential.user!.uid).collection('salesData').doc('initial').set({});
   //     await _firestore.collection('shopOwners').doc(userCredential.user!.uid).collection('purchaseData').doc('initial').set({});
   //     await _firestore.collection('shopOwners').doc(userCredential.user!.uid).collection('stockData').doc('initial').set({});
   //     await _firestore.collection('shopOwners').doc(userCredential.user!.uid).collection('profile').doc('initial').set({});
   //
   //     return "Registration successful"; // Success message
   //   } on FirebaseAuthException catch (e) {
   //     return e.message ?? "An unknown error occurred"; // Return Firebase error message
   //   }
   // }

   Future<String> registerUser (final String email, final String password,final String name,) async {
     try {
       var userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

       // Create a user document in Firestore
       await _firestore.collection('users').doc(userCredential.user!.uid).set({
         'email': email,
         'createdAt': Timestamp.now(),
         'name' : name,
         // Add other user fields as needed
       });

       // Create a shop owner document in the shopOwners collection
       await _firestore.collection('shopOwners').doc(userCredential.user!.uid);
       //     .set({
       //   'email': email,
       //   'createdAt': Timestamp.now(),
       //   // Add other fields as needed
       // });

       // Do not create any initial documents in salesData or other subcollections
       // They will be created when the user adds data

       return "Registration successful"; // Success message
     } on FirebaseAuthException catch (e) {
       return e.message ?? "An unknown error occurred"; // Return Firebase error message
     }
   }

   Future<String> loginUser (final String email, final String password) async {
     try {
       var user = await _auth.signInWithEmailAndPassword(email: email, password: password);
       return "Login successful"; // Success message
     } on FirebaseAuthException catch (e) {
       return e.message ?? "An unknown error occurred"; // Return Firebase error message
     }
   }

   Future<String> logOutUser () async {
     try {
       var user = await _auth.signOut();
       return "Logout successful"; // Success message
     } on FirebaseAuthException catch (e) {
       return e.message ?? "An unknown error occurred"; // Return Firebase error message
     }
   }

   Future<String> forgotPassword (final String email) async {
     try {
       var user = await _auth.sendPasswordResetEmail (email: email);
       return "Password Updated successful"; // Success message
     } on FirebaseAuthException catch (e) {
       return e.message ?? "An unknown error occurred"; // Return Firebase error message
     }
   }


   Future<String> signInWithGoogle() async {
     // Trigger the authentication flow
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
     try {
       if (googleUser == null) {
         return 'No user found';
       }

       // Obtain the auth details from the request
       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

       // Create a new credential
       final credential = GoogleAuthProvider.credential(
         accessToken: googleAuth.accessToken,
         idToken: googleAuth.idToken,
       );

       // Once signed in, return the UserCredential
       var userAuth = FirebaseAuth.instance.signInWithCredential(credential);
       return 'Successfully Login';
     }
     catch (e) {
       return '$e';
     }
   }

// Future<UserCredential?> signInWithFacebook() async {
//   try {
//     // Trigger the sign-in flow
//     final LoginResult loginResult = await FacebookAuth.instance.login(
//       loginBehavior: LoginBehavior.webOnly,
//     );
//
//     // Check if the user canceled the login
//     if (loginResult.status == LoginStatus.cancelled) {
//       debugPrint('--- LOGIN CANCELLED BY USER ---');
//       return null;
//     }
//
//     // Create a credential from the access token
//     final loginAccessToken = loginResult.accessToken;
//     final OAuthCredential facebookAuthCredential =
//     FacebookAuthProvider.credential(loginAccessToken?.tokenString ?? '');
//
//     // Sign in with the credential
//     final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//
//     // Extract email and display name
//     final String? email = userCredential.user?.email;
//     final String? displayName = userCredential.user?.displayName;
//
//     // You can handle the retrieved email and displayName here or return them if needed
//     // For example:
//     debugPrint('Email: $email');
//     debugPrint('Display Name: $displayName');
//
//     return userCredential; // Return the UserCredential
//   } on Exception catch (e) {
//     debugPrint('--- ERROR OCCURRED ---');
//     debugPrint(e.toString());
//     return null;
//   }
// }


}