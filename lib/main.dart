import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project_gemastik/Routes/route_names.dart';
import 'package:project_gemastik/Routes/route_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: RoutesPage.page,
      initialRoute: RouteNames.register,

    );
  }
}