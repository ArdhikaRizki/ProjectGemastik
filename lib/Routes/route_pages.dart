import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:project_gemastik/LoginRegister/RegisterView.dart';
import 'package:project_gemastik/Dashboard/View/ProductPageView.dart';
import 'package:project_gemastik/routes/route_names.dart';
import 'package:project_gemastik/page_petani/add_catalog_petani/addCatalogView.dart';
import 'package:project_gemastik/page_petani/applying_page/apply_page_view.dart';
import 'package:project_gemastik/profile/profile_view.dart';

import '../Dashboard/View/dashboard_view.dart';

class RoutePages {
  static List<GetPage> page = [
    GetPage(name: RouteNames.SignInUp , page: () => Registerview()),
    GetPage(name: RouteNames.home , page: () => DashboardView()),
    GetPage(name: RouteNames.product , page: () => Productpageview()),
    GetPage(name: RouteNames.profile , page: () => ProfileView()),
    GetPage(name: RouteNames.addCatalog, page: () => addCatalogView()),
    GetPage(name: RouteNames.applyCatalog, page: () => Applypageview()), // Assuming applyCatalog redirects to ProductPageView
  ];
}
