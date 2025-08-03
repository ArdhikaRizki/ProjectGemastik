import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:project_gemastik/page_koperasi/proses_tawaran/proses_tawaran_model.dart';

class ProsesTawaranContoller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var incomingOffers = <DetailTawaran>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchIncomingOffers();
  }

  void fetchIncomingOffers() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar("Error", "Anda harus login sebagai koperasi.");
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      // 1. Ambil semua tawaran untuk koperasi yang login
      QuerySnapshot offerSnapshot = await _firestore
          .collection('penawaran')
          .where('IdKoperasi', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'pending')
          .get();
      print("uid koperasi: ${currentUser.uid}");
      print("Jumlah tawaran masuk: ${offerSnapshot.docs.length}");
      List<DetailTawaran> detailedOffers = [];

      // Lakukan "join" untuk setiap tawaran
      for (var offerDoc in offerSnapshot.docs) {
        DataPenawaran dataPenawaran = DataPenawaran.fromSnapshot(offerDoc);

        // 2. Ambil data petani
        DocumentSnapshot farmerDoc = await _firestore.collection('users').doc(dataPenawaran.idPetani).get();
        print("Petani ID: ${dataPenawaran.idPetani}");
        
        // 3. Ambil data produk
        DocumentSnapshot productDoc = await _firestore.collection('produk_petani').doc(dataPenawaran.idProduk).get();

        if (farmerDoc.exists && productDoc.exists) {
          DataPetani farmer = DataPetani.fromSnapshot(farmerDoc);
          DataCatalog product = DataCatalog.fromSnapshot(productDoc);

          // 4. Gabungkan semua data
          detailedOffers.add(DetailTawaran(
            tawaran: dataPenawaran,
            petani: farmer,
            catalog: product,
          ));
        }
      }
      incomingOffers.value = detailedOffers;
      print("Berhasil mengambil ${incomingOffers.length} tawaran masuk.");
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data tawaran: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk menerima tawaran
  void acceptOffer(String offerId) async {
    try {
      await _firestore.collection('penawaran').doc(offerId).update({'status': 'accepted'});
      Get.snackbar("Sukses", "Tawaran berhasil diterima.", backgroundColor: Colors.green, colorText: Colors.white);
      incomingOffers.removeWhere((item) => item.tawaran.offerId == offerId);
    } catch (e) {
      Get.snackbar("Error", "Gagal menerima tawaran: $e");
    }
  }

  // Fungsi untuk menolak tawaran
  void rejectOffer(String offerId) async {
    try {
      await _firestore.collection('penawaran').doc(offerId).update({'status': 'rejected'});
      Get.snackbar("Info", "Tawaran telah ditolak.", backgroundColor: Colors.orange, colorText: Colors.white);
      incomingOffers.removeWhere((item) => item.tawaran.offerId == offerId);
    } catch (e) {
      Get.snackbar("Error", "Gagal menolak tawaran: $e");
    }
  }
}