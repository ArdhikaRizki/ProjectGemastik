import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignInUpController extends GetxController {
  RxBool isRegistering = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> roles = ['pembeli', 'petani', 'koperasi'];
  var selectedRole = 'pembeli'.obs;
  // RxString roleDipilih = ''.obs;
  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  void updateRole(String? newValue) {
    if (newValue != null) {
      selectedRole.value = newValue;
    }
  }

  String getUserRole() {
    return selectedRole.value;
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    String phoneNumber,
    String role,
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
          'role': role, // Add role field
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
