import 'package:get/get.dart';
import '../pages/partners/controllers/partners_controller.dart';
import '../pages/switches/controllers/switches_controller.dart';
import 'get_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<GetController>(GetController(), permanent: true);
    Get.lazyPut(() => SwitchesController());
    Get.lazyPut(() => PartnersController());
  }
}
