import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_gemastik/page_petani/catalog_petani/Model_Catalog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Controller_Catalog extends GetxController {
  final CollectionReference catalog =
  FirebaseFirestore.instance.collection('produk_petani');

  var productList = <Model_Catalog>[].obs;
  var isLoading = true.obs;
  var message = ''.obs;
  var isSuccess = false.obs;

  /// Method untuk menghapus file di server.
  Future<void> deleteFile(List<String> filename) async {
    // 1. Ubah state menggunakan .value, bukan setState()
    isLoading.value = true;
    message.value = '';

    if (filename.isEmpty) {
      message.value = 'Silakan masukkan nama file terlebih dahulu.';
      isLoading.value = false;
      isSuccess.value = false;

      Get.snackbar(
        'Error',
        'Nama file tidak boleh kosong.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final String baseUrl = 'http://147.139.136.133/delItem.php';
    for(int i = 0; i < filename.length; i++) {
        final Uri url =
        Uri.parse('$baseUrl?filename=${Uri.encodeComponent(filename[i])}');
        try {
          final response = await http.get(url);

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = json.decode(response.body);
            message.value = "Sukses menghapus Gambar";
            isSuccess.value = responseData['status'] == 'success';
            if (isSuccess.value) {
              Get.snackbar(
                'Sukses',
                message.value,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } else {
              Get.snackbar('Gagal', message.value, backgroundColor: Colors.orange);
            }
          } else {
            message.value = 'Error Server: ${response.statusCode}';
            isSuccess.value = false;
            Get.snackbar('Error', message.value, backgroundColor: Colors.red);
          }
        } catch (e) {
          message.value = 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
          isSuccess.value = false;
          Get.snackbar('Error', message.value, backgroundColor: Colors.red);
        } finally {
          // 2. Sembunyikan indikator loading
          isLoading.value = false;
        }
    }
  }




  @override
  void onInit() {
    super.onInit();
    fetchCatalog();
  }

  var activeIndex = 0.obs;

  void onPageChanged(int index) {
    activeIndex.value = index;
  }

  // Fungsi untuk mengambil data katalog
  void fetchCatalog() async {
  print("Mengambil data katalog");

  try {
    isLoading.value = true;

    String? currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid == null) {
      Get.snackbar("Error", "User belum login.");
      return;
    }

    QuerySnapshot querySnapshot = await catalog
        .where('uid', isEqualTo: currentUid) // Hanya ambil milik user login
        .get();

    productList.value = querySnapshot.docs
        .map((doc) => Model_Catalog.fromSnapshot(doc))
        .toList();

    print("Produk berhasil diambil: ${productList.length} item");
  } catch (error) {
    print("Error saat mengambil produk: $error");
    Get.snackbar("Error", "Gagal mengambil data produk.");
  } finally {
    isLoading.value = false;
  }
}

  void addProduct(Model_Catalog product) async {
    try {
      await catalog.add(product.toJson());
      fetchCatalog(); // Refresh daftar setelah menambah produk baru
    } catch (e) {
      print("Error saat menambah produk: $e");
    }
  }
  Future <void> deleteProduct(Model_Catalog catalog) async {
    try {
      await this.catalog.doc(catalog.docId).delete();
      await deleteFile(catalog.imageUrl); // Hapus file terkait
      fetchCatalog(); // Refresh daftar setelah menghapus produk
    } catch (e) {
      print("Error saat menghapus produk: $e");
    }
  }
}