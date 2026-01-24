import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/media/responsive_screens/media_desktop.dart';
import 'package:ecommerce_dashboard/views/media/responsive_screens/media_mobile.dart';
import 'package:ecommerce_dashboard/views/media/responsive_screens/media_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/media/media_controller.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaController controller = Get.put(MediaController());
    return const TSiteTemplate(
      desktop: MediaDesktopScreen(),
      tablet: MediaTabletScreen(),
      mobile: MediaMobileScreen(),
    );
  }
}
