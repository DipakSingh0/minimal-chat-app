import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      //sign the user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //save user info if it doesnt exists
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info in a separate doc
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // print('error');
      throw Exception(e.code);
    }
  }

  // //save the name of user  -- additional detail
  // Future<void> saveUserDetails({
  //   required String uid,
  //   required String firstName,
  //   required String lastName,
  // }) async {
  //   try {
  //     await firestore.collection("Users").doc(uid).update({
  //       'firstName': firstName,
  //       'lastName': lastName,
  //     });
  //   } catch (e) {
  //     throw Exception('Failed to save user details: $e');
  //   }
  // }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Errors
  // ...
}
