import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../LoginRegister/Model/UserModel.dart';

class ApplyPageViewController extends GetxController {
  var activeIndex = 0.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variabel reaktif untuk menyimpan daftar koperasi dan status loading
  var cooperativeList = <UserModel>[].obs;
  var isLoading = true.obs;

  void onPageChanged(int index) {
    activeIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCooperatives();
  }

  void fetchCooperatives() async {
    try {
      isLoading.value = true;

      // 1. Buat query ke collection 'users'
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
      // 2. Filter dokumen di mana field 'role' sama dengan 'koperasi'
          .where('role', isEqualTo: 'koperasi')
          .get();

      // 3. Ubah hasil query menjadi daftar UserModel
      cooperativeList.value = querySnapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();

      print("Berhasil mengambil ${cooperativeList.length} data koperasi.");

    } catch (e) {
      print("Terjadi error saat mengambil data koperasi: $e");
      Get.snackbar("Error", "Gagal mengambil data koperasi.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addPenawaran(String idPetani, String IdKoperasi, String IdProduk) async {
    try {
      // 1. Buat Map data untuk penawaran
      Map<String, dynamic> penawaranData = {
        'IdPetani': idPetani,
        'IdKoperasi': IdKoperasi,
        'IdProduk': IdProduk,
        'status': 'pending', // Status awal penawaran
      };

      await _firestore.collection('penawaran').add(penawaranData);

      Get.snackbar("Sukses", "Penawaran berhasil dibuat.");
      return true;
    } catch (e) {
      Get.snackbar("Error", "Gagal membuat penawaran: $e");
      return false;
    }
  }

}
