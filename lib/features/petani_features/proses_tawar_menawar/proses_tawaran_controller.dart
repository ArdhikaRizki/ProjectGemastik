// lib/page_petani/applying_page/proses_tawaran_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'negosiasi_model.dart';

class ProsesTawaranController extends GetxController {
  final String penawaranId;
  ProsesTawaranController({required this.penawaranId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var negotiationHistory = <NegosiasiModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNegotiationHistory();
  }

  void fetchNegotiationHistory() async {
    try {
      isLoading.value = true;
      _firestore
          .collection('penawaran')
          .doc(penawaranId)
          .collection('negosiasi')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        negotiationHistory.value = snapshot.docs
            .map((doc) => NegosiasiModel.fromSnapshot(doc))
            .toList();
        isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat negosiasi: $e");
      isLoading.value = false;
    }
  }

  // Petani menerima harga dari koperasi
  Future<void> acceptOffer() async {
    if (negotiationHistory.isEmpty) return;
    final lastOfferId = negotiationHistory.first.id;

    final batch = _firestore.batch();

    // 1. Update status di subcollection negosiasi
    final negosiasiRef = _firestore
        .collection('penawaran')
        .doc(penawaranId)
        .collection('negosiasi')
        .doc(lastOfferId);
    batch.update(negosiasiRef, {'status': 'accepted'});

    // 2. Update status di dokumen utama penawaran
    final penawaranRef = _firestore.collection('penawaran').doc(penawaranId);
    batch.update(penawaranRef, {'status': 'accepted_negotiated'});

    await batch.commit();
    Get.back(); // Kembali ke halaman sebelumnya
    Get.snackbar("Sukses", "Tawaran harga berhasil disetujui!",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  // Petani mengirim tawaran balasan
  Future<void> submitCounterOffer(int newPrice) async {
     try {
        final negotiationCollection = _firestore
          .collection('penawaran')
          .doc(penawaranId)
          .collection('negosiasi');

        await negotiationCollection.add({
          'hargaTawar': newPrice,
          'penawar': 'petani', // Penawar adalah petani
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending', // Menunggu respon koperasi
        });

       Get.back(); // Tutup dialog
       Get.snackbar("Sukses", "Tawaran balasan berhasil dikirim.",
           backgroundColor: Colors.blue, colorText: Colors.white);

     } catch (e) {
        Get.snackbar("Error", "Gagal mengirim tawaran balasan: $e");
     }
  }
}