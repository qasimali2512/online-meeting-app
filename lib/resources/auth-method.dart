import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoom/utilis.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const String webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth state change stream
  Stream<User?> get authChanges => _auth.authStateChanges();

  // Current user
  User? get user => _auth.currentUser;

  // ---------------- GOOGLE SIGN-IN ----------------
  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? webClientId : null,
        scopes: ['email', 'profile'],
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'username': user.displayName ?? 'Guest',
            'email': user.email ?? '',
            'uid': user.uid,
            'profilePhoto': user.photoURL ?? '',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? "Authentication failed");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return res;
  }

  // ---------------- EMAIL SIGN-UP ----------------
  Future<bool> signUpWithEmail(
      String email, String password, String username, BuildContext context) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user != null) {
        // Update FirebaseAuth displayName
        await user.updateDisplayName(username);

        // Save user in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'uid': user.uid,
          'profilePhoto': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      showSnackBar(context, "✅ Signup successful!");
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? "Signup failed");
      return false;
    }
  }

  // ---------------- EMAIL SIGN-IN ----------------
  Future<bool> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      showSnackBar(context, "✅ Login successful!");
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? "Login failed");
      return false;
    }
  }

  // ---------------- PASSWORD RESET ----------------
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackBar(context, "🔗 Password reset link sent to $email");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? "Failed to send reset email");
    }
  }

  // ---------------- SIGN OUT ----------------
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
