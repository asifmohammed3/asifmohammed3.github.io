import 'package:get/get.dart';

import '../modules/admin_auth/bindings/admin_auth_binding.dart';
import '../modules/admin_auth/views/admin_auth_view.dart';
import '../modules/admin_main/bindings/admin_main_binding.dart';
import '../modules/admin_main/views/admin_main_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/project_detail/bindings/project_detail_binding.dart';
import '../modules/project_detail/views/project_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROJECT_DETAIL,
      page: () => const ProjectDetailView(),
      binding: ProjectDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_AUTH,
      page: () => const AdminAuthView(),
      binding: AdminAuthBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_MAIN,
      page: () => const AdminMainView(),
      binding: AdminMainBinding(),
    ),
  ];
}
