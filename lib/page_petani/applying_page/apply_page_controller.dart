import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../LoginRegister/UserModel.dart';
import '../catalog_petani/Model_Catalog.dart';

class ApplyPageViewController extends GetxController {


  var activeIndex = 0.obs;
  void onPageChanged(int index) {
    activeIndex.value = index;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Variabel reaktif
  var cooperativeList = <StatusKoperasi>[].obs;
  var isLoading = true.obs;
  var isSendingOffer = false.obs;

  // ID produk yang akan ditawarkan (didapat dari halaman sebelumnya)
  final String productId;
  ApplyPageViewController({required this.productId});

  @override
  void onInit() {
    super.onInit();
    fetchCooperatives();
  }

  /// Mengambil daftar koperasi dan mengecek apakah produk ini sudah ditawarkan.
  void fetchCooperatives() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      isLoading.value = true;
      // 1. Ambil semua pengguna dengan peran 'koperasi'
      QuerySnapshot cooperativeSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'koperasi')
          .get();

      List<StatusKoperasi> tempList = [];

      // 2. Lakukan perulangan untuk setiap koperasi
      for (var doc in cooperativeSnapshot.docs) {
        UserModel cooperative = UserModel.fromSnapshot(doc);

        // 3. Cek apakah sudah ada tawaran untuk produk dan koperasi ini
        QuerySnapshot offerCheck = await _firestore
            .collection('penawaran')
            .where('IdPetani', isEqualTo: currentUser.uid)
            .where('IdProduk', isEqualTo: productId)
            .where('IdKoperasi', isEqualTo: cooperative.id)
            .limit(1)
            .get();

        bool hasBeenOffered = offerCheck.docs.isNotEmpty;

        tempList.add(StatusKoperasi(
          koperasi: cooperative,
          hasBeenOffered: hasBeenOffered,
        ));
      }
      cooperativeList.value = tempList;

    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data koperasi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fungsi untuk mengirim tawaran baru ke koperasi yang dipilih.
  Future<bool> addPenawaran(String idKoperasi) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar("Error", "Pengguna tidak ditemukan.");
      return false;
    }

    try {
      isSendingOffer.value = true;
      // Buat Map data untuk penawaran
      Map<String, dynamic> penawaranData = {
        'IdPetani': currentUser.uid,
        'IdKoperasi': idKoperasi,
        'IdProduk': productId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('penawaran').add(penawaranData);

      Get.snackbar("Sukses", "Penawaran berhasil dibuat.", backgroundColor: Colors.green, colorText: Colors.white);

      // Refresh daftar untuk menonaktifkan tombol
      fetchCooperatives();
      return true;
    } catch (e) {
      Get.snackbar("Error", "Gagal membuat penawaran: $e");
      return false;
    } finally {
      isSendingOffer.value = false;
    }
  }

}
