import 'package:get/get_navigation/get_navigation.dart';
import 'package:project_gemastik/LoginRegister/View/RegisterView.dart';
import 'package:project_gemastik/Routes/route_names.dart';

import '../dashboard/dashboardView.dart';

class RoutesPage {
  static List<GetPage> page = [
    GetPage(name: RouteNames.SignInUp , page: () => Registerview()),
    GetPage(name: RouteNames.home , page: () => dashboardView())
  ];
}
