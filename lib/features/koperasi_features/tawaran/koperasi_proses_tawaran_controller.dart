// lib/page_koperasi/tawaran/koperasi_proses_tawaran_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'negosiasi_model.dart';

class KoperasiProsesTawaranController extends GetxController {
  final String penawaranId;
  KoperasiProsesTawaranController({required this.penawaranId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var negotiationHistory = <NegosiasiModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNegotiationHistory();
  }

  void fetchNegotiationHistory() {
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
  }

  Future<void> acceptOffer() async {
    if (negotiationHistory.isEmpty) return;
    final lastOfferId = negotiationHistory.first.id;
    final batch = _firestore.batch();
    final negosiasiRef = _firestore.collection('penawaran').doc(penawaranId).collection('negosiasi').doc(lastOfferId);
    batch.update(negosiasiRef, {'status': 'accepted'});
    final penawaranRef = _firestore.collection('penawaran').doc(penawaranId);
    batch.update(penawaranRef, {'status': 'accepted_negotiated'});
    await batch.commit();

    Get.back();
    Get.snackbar("Sukses", "Kesepakatan harga berhasil!", backgroundColor: Colors.green, colorText: Colors.white);
  }

  Future<void> submitCounterOffer(int newPrice) async {
    try {
      await _firestore.collection('penawaran').doc(penawaranId).collection('negosiasi').add({
        'hargaTawar': newPrice,
        'penawar': 'koperasi',
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
      Get.back(); // Tutup dialog
      Get.snackbar("Sukses", "Tawaran balasan berhasil dikirim.", backgroundColor: Colors.blue, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim tawaran balasan: $e");
    }
  }
}