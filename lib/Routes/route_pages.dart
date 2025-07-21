import 'package:get/get_navigation/get_navigation.dart';
import 'package:project_gemastik/LoginRegister/View/RegisterView.dart';
import 'package:project_gemastik/ProductPage/View/ProductPageView.dart';
import 'package:project_gemastik/Routes/route_names.dart';
import 'package:project_gemastik/profile/view/profile_view.dart';

import '../Dashboard/View/dashboard_view.dart';

class RoutesPage {
  static List<GetPage> page = [
    GetPage(name: RouteNames.SignInUp , page: () => Registerview()),
    GetPage(name: RouteNames.home , page: () => dashboardView()),
    GetPage(name: RouteNames.product , page: () => Productpageview()),
    GetPage(name: RouteNames.profile , page: () => ProfileView()),
  ];
}
