import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/store/resposive_screens/store_desktop.dart';
import 'package:ecommerce_dashboard/views/store/resposive_screens/store_mobile.dart';
import 'package:ecommerce_dashboard/views/store/resposive_screens/store_tablet.dart';
import 'package:flutter/material.dart';


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
