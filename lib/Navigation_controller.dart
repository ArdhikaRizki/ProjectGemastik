import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  // Buat GlobalKey untuk setiap tab yang akan memiliki navigasi sendiri.
  // Angka di dalam Get.nestedKey adalah ID unik untuk setiap navigator.
  final GlobalKey<NavigatorState>? homeNavigatorKey = Get.nestedKey(1);
  final GlobalKey<NavigatorState>? searchNavigatorKey = Get.nestedKey(2);
  final GlobalKey<NavigatorState>? profileNavigatorKey = Get.nestedKey(3);

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}