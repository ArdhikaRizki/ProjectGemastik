import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project_gemastik/LoginRegister/Controlller/SignInUpController.dart';
import 'package:project_gemastik/Routes/route_names.dart';
import 'package:project_gemastik/Routes/route_pages.dart';
import 'package:project_gemastik/Dashboard/View/dashboard_view.dart';

import 'LoginRegister/View/RegisterView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(SignInUpController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authC.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot);
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Agri Marketplace',
            getPages: RoutesPage.page,
            // initialRoute: snapshot.data != null ? RouteNames.home : RouteNames.SignInUp,
            home: Obx(() {
              if (authC.isRegistering.value) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return snapshot.data != null /*&& !authC.isRegistering.value */
                  ? DashboardView()
                  : Registerview();
            }),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
