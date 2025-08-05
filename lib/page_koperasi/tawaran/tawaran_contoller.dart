// lib/page_koperasi/tawaran/tawaran_contoller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_gemastik/page_koperasi/tawaran/tawaran_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TawaranContoller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- PERUBAHAN 1: Tambah list untuk negosiasi ---
  var incomingOffers = <DetailTawaran>[].obs;    // Untuk status 'pending'
  var negotiatingOffers = <DetailTawaran>[].obs; // Untuk status 'negotiating'
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllOffers(); // Ganti nama fungsi fetch
  }

  // --- PERUBAHAN 2: Fungsi fetch diubah untuk mengambil semua status terkait ---
  void fetchAllOffers() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar("Error", "Anda harus login sebagai koperasi.");
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      // Ambil tawaran 'pending' dan 'negotiating' sekaligus
      QuerySnapshot offerSnapshot = await _firestore
          .collection('penawaran')
          .where('IdKoperasi', isEqualTo: currentUser.uid)
          .where('status', whereIn: ['pending', 'negotiating'])
          .get();

      List<DetailTawaran> pendingList = [];
      List<DetailTawaran> negotiatingList = [];

      for (var offerDoc in offerSnapshot.docs) {
        TawaranModel dataPenawaran = TawaranModel.fromSnapshot(offerDoc);
        DocumentSnapshot farmerDoc = await _firestore.collection('users').doc(dataPenawaran.idPetani).get();
        DocumentSnapshot productDoc = await _firestore.collection('produk_petani').doc(dataPenawaran.idProduk).get();

        if (farmerDoc.exists && productDoc.exists) {
          DataPetani farmer = DataPetani.fromSnapshot(farmerDoc);
          DataCatalog product = DataCatalog.fromSnapshot(productDoc);
          final detail = DetailTawaran(
            tawaran: dataPenawaran,
            petani: farmer,
            catalog: product,
          );

          // Pisahkan data ke list yang sesuai berdasarkan status
          if (dataPenawaran.status == 'pending') {
            pendingList.add(detail);
          } else if (dataPenawaran.status == 'negotiating') {
            negotiatingList.add(detail);
          }
        }
      }
      incomingOffers.value = pendingList;
      negotiatingOffers.value = negotiatingList;
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data tawaran: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- PERUBAHAN 3: Panggil fetchAllOffers() setelah aksi untuk refresh ---
  void acceptOffer(String offerId) async {
    try {
      await _firestore.collection('penawaran').doc(offerId).update({'status': 'accepted'});
      Get.snackbar("Sukses", "Tawaran berhasil diterima.", backgroundColor: Colors.green, colorText: Colors.white);
      fetchAllOffers(); // Refresh data
    } catch (e) {
      Get.snackbar("Error", "Gagal menerima tawaran: $e");
    }
  }

  void rejectOffer(String offerId) async {
    try {
      await _firestore.collection('penawaran').doc(offerId).update({'status': 'rejected'});
      Get.snackbar("Info", "Tawaran telah ditolak.", backgroundColor: Colors.orange, colorText: Colors.white);
      fetchAllOffers(); // Refresh data
    } catch (e) {
      Get.snackbar("Error", "Gagal menolak tawaran: $e");
    }
  }
  
  void submitNegotiation(String offerId, int negotiatedPrice) async {
    try {
      final negotiationCollection = _firestore.collection('penawaran').doc(offerId).collection('negosiasi');
      await negotiationCollection.add({
        'hargaTawar': negotiatedPrice,
        'penawar': 'koperasi',
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
      await _firestore.collection('penawaran').doc(offerId).update({'status': 'negotiating'});
      Get.back();
      Get.snackbar("Sukses", "Harga tawaran berhasil dikirim.", backgroundColor: Colors.blue, colorText: Colors.white);
      fetchAllOffers(); // Refresh data
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim harga tawar: $e");
    }
  }

  Future<void> urlWhatsApp(String phoneNumber) async {
    // ... (kode fungsi ini tidak berubah)
  }
}