import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:project_gemastik/core/navigations/MainScreen.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;


  // Buat GlobalKey untuk setiap tab yang akan memiliki navigasi sendiri.
  // Angka di dalam Get.nestedKey adalah ID unik untuk setiap navigator.  


  final GlobalKey<NavigatorState>? homeNavigatorKey = Get.nestedKey(0);
  final GlobalKey<NavigatorState>? profileNavigatorKey = Get.nestedKey(1);
  final GlobalKey<NavigatorState>? addProduct = Get.nestedKey(2);
  final GlobalKey<NavigatorState>? lihatpenawaran = Get.nestedKey(3);
  final GlobalKey<NavigatorState>? profileNavigatorkeypetaniKoperasi = Get.nestedKey(4);
  
  void changeIndex(int index) {
    print("Selected index changed to: $index");
    selectedIndex.value = index;
  }
}