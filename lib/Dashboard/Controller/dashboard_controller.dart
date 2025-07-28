import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:project_gemastik/Dashboard/Model/product_model.dart';
import 'package:project_gemastik/Dashboard/View/ProductPageView.dart';

import '../../Routes/route_names.dart';


class DashboardController extends GetxController {
  CollectionReference products = FirebaseFirestore.instance.collection('products',);
  String role = 'pembeli';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var productList = <ProductModel>[].obs;
  // Example method to fetch data or perform an action
  var userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRole();
    fetchData();
  }
  /// Mengambil data peran (role) dari pengguna yang sedang login.
  /// Mengembalikan role sebagai String, atau null jika tidak ditemukan.
  Future<String?> getUserRole() async {
    try {
      // 1. Dapatkan pengguna yang sedang login saat ini.
      User? currentUser = _auth.currentUser;

      // Pastikan ada pengguna yang login.
      if (currentUser != null) {
        // 2. Dapatkan UID pengguna.
        String uid = currentUser.uid;

        // 3. Cari dokumen di collection 'users' dengan ID yang sama dengan UID.
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();

        // Periksa apakah dokumen tersebut ada.
        if (userDoc.exists) {
          // 4. Ambil nilai dari field 'role'.
          // Gunakan (userDoc.data() as Map<String, dynamic>) untuk keamanan tipe data.
          String role = (userDoc.data() as Map<String, dynamic>)['role'];
          return role;
        } else {
          print("Dokumen pengguna tidak ditemukan di Firestore.");
          return null;
        }
      } else {
        print("Tidak ada pengguna yang sedang login.");
        return null;
      }
    } catch (e) {
      print("Terjadi error saat mengambil role: $e");
      return null;
    }
  }

  /// Fungsi helper untuk memanggil getUserRole dan menyimpannya di variabel reaktif.
  Future<void> fetchUserRole() async {
    String? role = await getUserRole();
    if (role != null) {
      userRole.value = role;
    }
  }


  void fetchData() {
    products
        .get()
        .then((QuerySnapshot querySnapshot) {
          productList.value =
              querySnapshot.docs
                  .map((doc) {
                    try {
                      return ProductModel.fromJson(doc.id,
                        doc.data() as Map<String, dynamic>
                      );
                    } catch (e) {
                      print("Error parsing product data: $e");
                      return null;
                    }
                  })
                  .whereType<ProductModel>()
                  .toList();

          print("Products fetched successfully: ${productList.length} items");
        })
        .catchError((error) {
          print("Error fetching products: $error");
        });
  }

  void addProduct(ProductModel product) async {
    try {
      await products.add(product.toJson());
    } catch (e) {
      print("Error adding product: $e");
    }
  }
  void handleisTap(ProductModel product) {
    Get.toNamed(RouteNames.product, arguments: product);
  }

}
