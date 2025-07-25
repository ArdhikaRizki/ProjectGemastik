import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../LoginRegister/Model/UserModel.dart';


class profileController extends GetxController {

  XFile? image;
  Uint8List? _imageBytes;
  final picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get streamAuthStatus => auth.authStateChanges();
  bool _isUploading = false;
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> updateName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateProfile(displayName: name);
      // Optionally, update the Firestore document as well
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': name});
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'phoneNumber': phoneNumber});
    }
  }

  Future<void> updateImage(String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updatePhotoURL(imageUrl);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'urlfoto': imageUrl});

    }
  }


  Future<UserModel> getUserData() async {
    final docSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      // Name, email address, and profile photo URL
      // print(user.email);
      // print(user.displayName);
      final nama = data['name'];
      final email = data['email'];
      final photoUrl = data['urlfoto'];
      final phoneNumber = data['phoneNumber'];

      UserModel userdata = UserModel(
        name: nama ?? '',
        email: email ?? '',
        urlfoto: photoUrl ?? '',
        phoneNumber: phoneNumber ?? '',
      );
    
      // Check if user's email is verified
      // The user's ID, unique to the Firebase project. Do NOT use this value to
      // authenticate with your backend server, if you have one. Use
      // User.getIdToken() instead.
      // final uid = user.uid;
      return userdata;
    } else {
      // No user is signed in.
      print('No user is signed in.');
      return UserModel(name: '', email: '', urlfoto: '');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      _imageBytes = bytes as Uint8List?;
      image = pickedFile;
      update(); // Notify listeners of the state change
    }
    _uploadImage();
  }

  Future<void> _uploadImage() async {
    if (image == null) {
      Get.snackbar(
        "Error",
        "Please select an image first!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    _isUploading = true;
    update();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://13.213.29.164/upload.php"),
    );

    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          _imageBytes!,
          filename: image!.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image!.path,
          filename: image!.name,
        ),
      );
    }

    try {
      var response = await request.send();
      _isUploading = false;
      update();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedBody = jsonDecode(responseBody);
        print("Upload successful: $decodedBody");
        final imageUrl = "http://13.213.29.164/${decodedBody['file_path']}";
        await updateImage(imageUrl);
        Get.snackbar(
          "Success",
          "Upload successful 🎉",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        image = null;
        _imageBytes = null;
        update();
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Upload failed with status: ${response.statusCode}");
        print("Response body: $responseBody");
        Get.snackbar(
          "Error",
          "Upload failed 😢 (Code: ${response.statusCode})",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _isUploading = false;
      update();
      print("An error occurred during upload: $e");
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}
