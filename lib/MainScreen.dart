import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_gemastik/profile/Controller/profileController.dart';
import 'package:project_gemastik/profile/view/profile_view.dart';

import 'Dashboard/View/dashboard_view.dart';
import 'Navigation_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: controller.selectedIndex.value,
          children: [
            // --- PERUBAHAN 2: BUNGKUS SETIAP HALAMAN DENGAN NAVIGATOR ---
            // Setiap Navigator memiliki key dan onGenerateRoute sendiri.
            Navigator(
              key: controller.homeNavigatorKey,
              onGenerateRoute: (settings) => GetPageRoute(
                page: () => DashboardView(),
              ),
            ),
            Navigator(
              key: controller.profileNavigatorKey,
              onGenerateRoute: (settings) => GetPageRoute(
                page: () => const ProfileView(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}