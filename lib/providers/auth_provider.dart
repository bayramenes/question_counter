import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  String? get userId {
    var currentUser = auth.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    }
    return null;
  }

  void logOut() async {
    await auth.signOut();
    notifyListeners();
  }

  Future<void> resetPass(BuildContext context, String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Reset Email sent'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.code == "user-not-found"
                ? "Sorry we couldn't find a user with this email"
                : e.code == "invalid-email"
                    ? "Please Provide a valid email"
                    : "An error occured in our side sorry for the inconvinience :(",
          ),
        ),
      );
    }
  }

  Future<String> singUserIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return '';
    } on FirebaseAuthException catch (error) {
      if (error.code == 'wrong-password') {
        return 'Your email or password is wrong :(';
      } else if (error.code == "invalid-email") {
        return "Please enter a valid email !!";
      } else if (error.code == "user-not-found") {
        return "No user was found with these credentials you might register !!";
      } else {
        return "Something went wrong sorry of the incovenience :(";
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<String> registerUser(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return '';
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
        return "Email is already used by another account";
      } else if (error.code == "invalid-email") {
        return 'Please enter a valid email !!';
      } else {
        return "Something went wrong sorry of the incovenience :(";
      }
    } catch (error) {
      return error.toString();
    }
  }
}
