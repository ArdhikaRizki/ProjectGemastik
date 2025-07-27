import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_gemastik/LoginRegister/Controlller/SignInUpController.dart';
import 'package:project_gemastik/LoginRegister/Model/UserModel.dart';
import 'package:project_gemastik/profile/Controller/profileController.dart';
import 'package:project_gemastik/profile/view/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Dashboard/View/dashboard_view.dart';
import 'Navigation_controller.dart';

class MainScreen extends StatelessWidget {
  String role;

  MainScreen({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(role + " role di MainScreen");

    final NavigationController controller = Get.put(
      NavigationController(role: role),
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
        label: 'Add Product',
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
            role == 'pembeli'
                ? Navigator(
                  key: controller.profileNavigatorKey,
                  onGenerateRoute:
                      (settings) =>
                          GetPageRoute(page: () => ProfileView()), //diganti
                ) //Pembeli
                : role == 'petani'
                ? Navigator(
                  key: controller.addProduct,
                  onGenerateRoute:
                      (settings) => GetPageRoute(page: () => buildProfileView()),
                )
                : Navigator(
                  key: controller.lihatpenawaran,
                  onGenerateRoute:
                      (settings) =>
                          GetPageRoute(page: () => buildProfileView()),
                ),

            //Profile Petani
            role == 'petani' || role == 'koperasi'
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
              role == 'pembeli'
                  ? itemsPembeli
                  : role == 'petani'
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
