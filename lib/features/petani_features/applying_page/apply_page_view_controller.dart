// lib/page_petani/applying_page/apply_page_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../authtentications/UserModel.dart';
import 'package:project_gemastik/features/petani_features/proses_tawar_menawar/status_koperasi.dart';

class ApplyPageViewController extends GetxController {
  var activeIndex = 0.obs;
  void onPageChanged(int index) {
    activeIndex.value = index;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var cooperativeList = <StatusKoperasi>[].obs;
  var isLoading = true.obs;
  var isSendingOffer = false.obs;

  final String productId;
  ApplyPageViewController({required this.productId});

  @override
  void onInit() {
    super.onInit();
    fetchCooperatives();
  }

  void fetchCooperatives() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      isLoading.value = true;
      QuerySnapshot cooperativeSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'koperasi')
          .get();

      List<StatusKoperasi> tempList = [];

      for (var doc in cooperativeSnapshot.docs) {
        UserModel cooperative = UserModel.fromSnapshot(doc);

        QuerySnapshot offerCheck = await _firestore
            .collection('penawaran')
            .where('IdPetani', isEqualTo: currentUser.uid)
            .where('IdProduk', isEqualTo: productId)
            .where('IdKoperasi', isEqualTo: cooperative.id)
            .limit(1)
            .get();

        bool hasBeenOffered = offerCheck.docs.isNotEmpty;
        String? penawaranId; // Variabel untuk menyimpan ID
        if (hasBeenOffered) {
          penawaranId = offerCheck.docs.first.id; // Ambil ID dokumen penawaran
        }

        tempList.add(StatusKoperasi(
          koperasi: cooperative,
          hasBeenOffered: hasBeenOffered,
          penawaranId: penawaranId, // Simpan ID-nya
        ));
      }
      cooperativeList.value = tempList;
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data koperasi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPenawaran(String idKoperasi) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar("Error", "Pengguna tidak ditemukan.");
      return;
    }

    try {
      isSendingOffer.value = true;
      Map<String, dynamic> penawaranData = {
        'IdPetani': currentUser.uid,
        'IdKoperasi': idKoperasi,
        'IdProduk': productId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('penawaran').add(penawaranData);
      Get.snackbar("Sukses", "Penawaran berhasil dibuat.",
          backgroundColor: Colors.green, colorText: Colors.white);
      fetchCooperatives(); // Refresh daftar
    } catch (e) {
      Get.snackbar("Error", "Gagal membuat penawaran: $e");
    } finally {
      isSendingOffer.value = false;
    }
  }
}