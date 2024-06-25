import 'package:eztime_app/Page/Home/HomePage.dart';
import 'package:eztime_app/Page/Home/Profile/Profile_Page.dart';

class RouteNames {
  static final Map<String, dynamic> routes = {
    '/home': (context) => Home_Page(),
    '/profile': (context) => Profile_Page(),
    // เพิ่มชื่อหน้าอื่นๆ ตามต้องการ
  };
}
