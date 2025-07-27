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
  var imageKey = UniqueKey().obs;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> updateName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateProfile(displayName: name);
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
    imageKey.value = UniqueKey(); // Update key to refresh image widget
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
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      final nama = data['name'];
      final email = data['email'];
      final photoUrl = data['urlfoto'];
      final phoneNumber = data['phoneNumber'];
      final role = data['role'];

      return UserModel(
        name: nama ?? '',
        email: email ?? '',
        urlfoto: photoUrl ?? '',
        phoneNumber: phoneNumber ?? '',
        role: role ?? 'pembeli', // Default role if not set
      );
    } else {
      return UserModel(name: '', email: '', urlfoto: '', phoneNumber: '', role: 'pembeli');
    }
  }

  // PERBAIKAN UTAMA ADA DI SINI
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        _imageBytes = await pickedFile.readAsBytes();
      }
      image = pickedFile;
      // Panggil _uploadImage dan TUNGGU hingga selesai.
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (image == null) {
      Get.snackbar(
        "Error",
        "Please select an image first!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    update(); // Untuk memberitahu listener GetX jika ada

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://13.213.29.164/upload.php"),
    );


    final fileName = userId;

    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          _imageBytes!,
          filename: fileName,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image!.path,
          filename: fileName,
        ),
      );
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedBody = jsonDecode(responseBody);
        print("Upload successful: $decodedBody");
        final imageUrl = "http://13.213.29.164/${decodedBody['file_path']}";
        await updateImage(imageUrl);
        imageKey.value = UniqueKey();

        Get.snackbar(
          "Success",
          "Upload successful 🎉",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        image = null;
        _imageBytes = null;
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
      print("An error occurred during upload: $e");
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      update(); // Untuk memberitahu listener GetX jika ada
    }
  }
}
