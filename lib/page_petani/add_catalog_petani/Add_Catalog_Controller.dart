import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../catalog_petani/Controller_Catalog.dart';

class addCatalogController extends GetxController {
  final picker = ImagePicker();
  var selectedImages = <XFile>[].obs;
  var isUploading = false.obs;
  final controllerlistcatalog = Get.find<Controller_Catalog>();

  /// Fungsi untuk memilih BANYAK gambar dari galeri.
  Future<void> pickMultiImageFromGallery() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      selectedImages.addAll(pickedFiles);
    }
  }

  Future<void> pickSingleImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImages.add(pickedFile);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<List<String>> uploadImages() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(
        "Error",
        "Anda harus login terlebih dahulu.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }

    if (selectedImages.isEmpty) {
      Get.snackbar(
        "Error",
        "Silakan pilih setidaknya satu gambar.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }

    isUploading.value = true;
    List<String> uploadedImageUrls = [];

    try {
      // Lakukan perulangan untuk setiap gambar yang dipilih
      for (int i = 0; i < selectedImages.length; i++) {
        XFile imageFile = selectedImages[i];

        var request = http.MultipartRequest(
          'POST',
          Uri.parse("http://147.139.136.133/itemUpload.php"),
        );

        final fileExtension = path.extension(imageFile.path);
        final fileName =
            "${userId}_produk_${DateTime.now().millisecondsSinceEpoch}_$i$fileExtension";

        if (kIsWeb) {
          final bytes = await imageFile.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes('image', bytes, filename: fileName),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              imageFile.path,
              filename: fileName,
            ),
          );
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final decodedBody = jsonDecode(responseBody);
          final imageUrl = "http://147.139.136.133/${decodedBody['file_path']}";
          uploadedImageUrls.add(imageUrl);
          print("Gambar ${i + 1} berhasil diunggah: $imageUrl");
        } else {
          final responseBody = await response.stream.bytesToString();
          Get.snackbar(
            "Error",
            "Gagal mengunggah gambar ${i + 1}. Pesan: $responseBody",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return []; // Hentikan proses jika satu gambar gagal
        }
      }

      // Jika semua gambar berhasil diunggah
      //

      selectedImages.clear(); // Kosongkan daftar setelah berhasil
      return uploadedImageUrls;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi error: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    } finally {
      isUploading.value = false;
    }
  }

  Future<bool> addProductToFirestore({
    required String name,
    required String desc,
    required String price,
    required List<String> imageUrls,
  }) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Get.snackbar("Error", "Pengguna tidak ditemukan.");
      isUploading.value = false;
      return false;
    }

    try {
      // Konversi harga dari String ke int/double jika perlu
      final int harga = int.tryParse(price) ?? 0;

      // Buat Map data yang akan disimpan
      Map<String, dynamic> productData = {
        'name': name,
        'desc': desc,
        'harga': harga,
        'imageUrl': imageUrls,
        'uid': uid,
      };

      // Tambahkan dokumen baru ke collection 'produk_petani'
      await FirebaseFirestore.instance
          .collection('produk_petani')
          .add(productData);

      selectedImages.clear(); // Kosongkan daftar gambar setelah berhasil
      // Anda bisa menambahkan navigasi kembali ke halaman sebelumnya di sini
      // Get.back();
      return true;
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan produk: $e");
      return false;
    }
    // finally {
    // isUploading.value = false;
    // controllerlistcatalog.fetchCatalog(); // Refresh daftar setelah menambah produk baru
    // Get.back();
    // }
  }

  Future<void> saveProduct({
    required String name,
    required String desc,
    required String price,
  }) async {
    // 1. Validasi Input (pindahkan dari view)
    if (selectedImages.isEmpty ||
        name.isEmpty ||
        desc.isEmpty ||
        price.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field harus diisi dan minimal satu foto harus dipilih.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Hentikan fungsi jika validasi gagal
    }

    isUploading.value = true; // Mulai loading

    // 2. Upload Gambar
    final imageUrls = await uploadImages();

    // 3. Cek Hasil Upload
    if (imageUrls.isEmpty) {
      // Snackbar sudah ditampilkan dari dalam fungsi uploadImages,
      // jadi kita hanya perlu menghentikan proses.
      isUploading.value = false; // Hentikan loading
      return; // Hentikan fungsi jika upload gagal
    }

    // 4. Simpan ke Firestore (jika semua berhasil)
    // Fungsi ini sudah memiliki try-catch-finally dan Get.back() di dalamnya
    final bool isSuccess = await addProductToFirestore(
      name: name,
      desc: desc,
      price: price,
      imageUrls: imageUrls,
    );
    isUploading.value = false; // Hentikan loading
    if (isSuccess) {
      controllerlistcatalog.fetchCatalog();
      Get.back();
      Get.snackbar(
        "Sukses",
        "Produk '$name' berhasil ditambahkan!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }

  }
}
