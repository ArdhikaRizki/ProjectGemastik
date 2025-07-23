import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_gemastik/LoginRegister/Model/UserModel.dart';
import 'package:project_gemastik/LoginRegister/View/RegisterView.dart';

class SignInUpController extends GetxController {
  RxBool isRegistering = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  Future<void> signUp(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    try {
      isRegistering.value = true;
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      await user?.updateProfile(displayName: name);
      await user?.reload(); // Reload to get the updated user info
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'name': name,
          'phoneNumber': phoneNumber,
          'urlfoto': 'https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2247726673.jpg', // Default profile picture URL
        });
      };
      
      await signOut();
      isRegistering.value = false; // Reset the registration state
      Get.snackbar(
        'Success',
        'Registration successful! Please log in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      // isRegistering.value = false;
    } catch (e) {
      print(e);
      isRegistering.value = false; 
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
