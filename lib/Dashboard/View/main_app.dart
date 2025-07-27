import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_gemastik/Dashboard/Controller/main_app_controller.dart';
import 'package:project_gemastik/Dashboard/View/ProductPageView.dart';
import 'package:project_gemastik/dashboard/view/dashboard_view.dart';
import 'package:project_gemastik/profile/view/profile_view.dart';

class MainApp extends StatelessWidget {
  final MainAppController controller = Get.put(MainAppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Agri Marketplace')),
      body: Obx(() {
        // Dynamically change the body based on the selected index
        switch (controller.selectedIndex.value) {
          case 0:
            return DashboardView(); // Home Page
          case 1:
            return Productpageview(); // Shop Page
          case 2:
            return _buildProfilePage();
          case 3:
            return ProfileView();
          default:
            return const Center(child: Text('Page Not Found'));
        }
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
        // controller.selectedIndex.value = index;
        controller.navigateBottomBar(index);
          },
          items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
          ],
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.grey[600],
          type: BottomNavigationBarType.fixed,
        );
      }),
    );
  }

  



  Widget _buildProfilePage() {
    return const Center(child: Text('Profile Page'));
  }

  
  

  }


  

  

