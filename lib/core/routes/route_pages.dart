import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:project_gemastik/features/authtentications/RegisterView.dart';
import 'package:project_gemastik/features/Dashboard/View/ProductPageView.dart';
import 'package:project_gemastik/core/routes/route_names.dart';
import 'package:project_gemastik/features/petani_features/add_catalog_petani/addCatalogView.dart';
import 'package:project_gemastik/features/petani_features/applying_page/apply_page_view.dart';
import 'package:project_gemastik/features/profile/profile_view.dart';

import '../../features/Dashboard/View/dashboard_view.dart';

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
