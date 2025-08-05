import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'history_model.dart';

class HistoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var offerHistoryList = <OfferHistoryModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOfferHistory();
  }

  void fetchOfferHistory() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar("Error", "Anda harus login sebagai petani.");
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      // 1. Ambil semua tawaran dari petani yang login dengan status 'accepted' atau 'rejected'
      QuerySnapshot offerSnapshot = await _firestore
          .collection('penawaran')
          .where('IdPetani', isEqualTo: currentUser.uid)
          .where('status', whereIn: ['accepted', 'rejected', 'pending'])
          .get();

      List<OfferHistoryModel> detailedOffers = [];

      for (var offerDoc in offerSnapshot.docs) {
        OfferData offerData = OfferData.fromSnapshot(offerDoc);

        // 2. Ambil data koperasi
        DocumentSnapshot cooperativeDoc = await _firestore.collection('users').doc(offerData.idKoperasi).get();

        // 3. Ambil data produk
        DocumentSnapshot productDoc = await _firestore.collection('produk_petani').doc(offerData.idProduk).get();

        if (cooperativeDoc.exists && productDoc.exists) {
          CooperativeModel cooperative = CooperativeModel.fromSnapshot(cooperativeDoc);
          ProductModel product = ProductModel.fromSnapshot(productDoc);

          // 4. Gabungkan semua data
          detailedOffers.add(OfferHistoryModel(
            offer: offerData,
            cooperative: cooperative,
            product: product,
          ));
        }
      }
      offerHistoryList.value = detailedOffers;

    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil riwayat tawaran: $e");
    } finally {
      isLoading.value = false;
    }
  }
}