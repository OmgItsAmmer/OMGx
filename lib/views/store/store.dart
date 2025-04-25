import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/store/resposive_screens/store_desktop.dart';
import 'package:admin_dashboard_v3/views/store/resposive_screens/store_mobile.dart';
import 'package:admin_dashboard_v3/views/store/resposive_screens/store_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/shop/shop_controller.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //   final  shopController = Get.put(ShopController());
    // shopController.fetchShop();
    return const TSiteTemplate(
      desktop: StoreDesktop(),
      tablet: StoreTablet(),
      mobile: StoreMobile(),
    );
  }
}
