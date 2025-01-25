import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:get/get.dart';

import '../network_manager.dart';
import '../repositories/user/user_repository.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserController());
    Get.put(ProductController());

    // final UserRespository userRespository = Get.find<UserRespository>();

  }
}
