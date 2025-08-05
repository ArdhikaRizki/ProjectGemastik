import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_gemastik/features/authtentications/SignInUpController.dart';
import 'package:project_gemastik/features/koperasi_features/tawaran/tawaran_view.dart';
import 'package:project_gemastik/features/petani_features/catalog_petani/View_Catalog.dart';
import 'package:project_gemastik/features/profile/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/Dashboard/View/dashboard_view.dart';
import 'Navigation_controller.dart';

class MainScreenController extends GetxController {
  SignInUpController auth = Get.find<SignInUpController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var Role = "pembeli".obs;
  late StreamSubscription<User?> _authSubscription;
  final NavigationController controller = Get.put(
    NavigationController(),
  );
  @override
  void onInit() {
    super.onInit();
    _authSubscription = auth.streamAuthStatus.listen((user) {
      if (user != null) {
        // User is logged in, fetch the role
        fetchUserRole();
      } else {
        controller.selectedIndex.value = 0;
        Role.value = "pembeli"; // Default role or handle accordingly
      }
    });
    fetchUserRole();
  }

  Future<String?> getUserRole() async {
    try {

      User? currentUser = auth.auth.currentUser;
      print("User yang sedang login: ${currentUser?.email}");
      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
        // Periksa apakah dokumen tersebut ada.

          String role = (userDoc.data() as Map<String, dynamic>)['role'];
          print("Role pengguna: $role");
          return role;
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
      Role.value = role;
    }
  }

  @override
  void onClose() {
    // Hentikan listener saat controller ditutup untuk mencegah kebocoran memori.
    _authSubscription.cancel();
    super.onClose();
  }
}
class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  MainScreenController mscreencontroller = Get.put(MainScreenController());

  Widget build(BuildContext context) {
    mscreencontroller.fetchUserRole();
    final NavigationController controller = Get.put(
      NavigationController(),
    );

    List<BottomNavigationBarItem> itemsPembeli = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      // const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    ];
    List<BottomNavigationBarItem> itemsPetani = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.add),
        label: 'Add Product',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];

    List<BottomNavigationBarItem> itemsKoperasi = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.add),
        label: 'Lihat Penawaran',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: [
            Navigator(
              key: controller.homeNavigatorKey,
              onGenerateRoute:
                  (settings) => GetPageRoute(page: () => DashboardView()),
            ),
            mscreencontroller.Role.value == 'pembeli'
                ? Navigator(
                  key: controller.profileNavigatorKey,
                  onGenerateRoute:
                      (settings) =>
                          GetPageRoute(page: () => ProfileView()), //diganti
                ) //Pembeli
                : mscreencontroller.Role.value == 'petani'
                ? Navigator(

                  key: controller.addProduct,
                  onGenerateRoute:
                      (settings) => GetPageRoute(page: () => View_Catalog()),
                )
                : Navigator(
                  key: controller.lihatpenawaran,
                  onGenerateRoute:
                      (settings) =>
                          GetPageRoute(page: () => TawaranView()),
                ),

            //Profile Petani
            mscreencontroller.Role.value == 'petani' || mscreencontroller.Role.value == 'koperasi'
                ? Navigator(
                  key: controller.profileNavigatorkeypetaniKoperasi,
                  onGenerateRoute:
                      (settings) => GetPageRoute(page: () => ProfileView()),
                )
                : Container(),
            //Profile Petani
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          items:
          mscreencontroller.Role.value == 'pembeli'
                  ? itemsPembeli
                  : mscreencontroller.Role.value == 'petani'
                  ? itemsPetani
                  : itemsKoperasi,
        ),
      ),
    );
  }

  Widget buildProfileView() {
    return Container();
  }
}
