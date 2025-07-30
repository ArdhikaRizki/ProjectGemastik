import 'package:get/get.dart';
import 'package:project_gemastik/page_petani/catalog_petani/Model_Catalog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Controller_Catalog extends GetxController {
  final CollectionReference catalog =
  FirebaseFirestore.instance.collection('produk_petani');

  var productList = <Model_Catalog>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCatalog();
  }

  // Fungsi untuk mengambil data katalog
  void fetchCatalog() async {
    print("Mengambil data katalog");
    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await catalog.get();

      // Gunakan factory constructor yang sudah diperbaiki
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
}