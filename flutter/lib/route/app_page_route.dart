import 'package:get/get.dart';
import 'package:nodejs_test/route/route_name.dart';
import 'package:nodejs_test/view/create_activities.dart';
import 'package:nodejs_test/view/home_page.dart';
import 'package:nodejs_test/view/login_page.dart';
import 'package:nodejs_test/view/register_page.dart';

class AppPageRoute {
  static final pages = [
    GetPage(
      name: RouteName.goLoginPage,
      page: () => LoginPage(),
    ),
    GetPage(
      name: RouteName.goHomePage,
      page: () => HomePage(),
    ),
    GetPage(
      name: RouteName.goRegisterPage,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: RouteName.goCreateActivities,
      page: () => CreateActivitiesPage(),
    )
  ];
}
