import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MainAppController extends GetxController {  
  final user = FirebaseAuth.instance.currentUser;
  final userData = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  var selectedIndex = 0.obs;
  

  void navigateBottomBar(int index) {
    selectedIndex.value = index;
    // switch (index) {
    //   case 0:
    //     Get.toNamed(RouteNames.home);
    //     break;
    //   case 1:
    //     Get.toNamed(RouteNames.product);
    //     break;
    //   case 2:
    //     Get.toNamed('/blog');
    //     break;
    //   case 3:
    //     Get.toNamed(RouteNames.profile);
    //     break;
    //   default:
    //     Get.toNamed(RouteNames.home);
    // }
  }
}