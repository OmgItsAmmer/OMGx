import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/vendor/add_vendor/resposive_screens/add_vendor_desktop.dart';
import 'package:ecommerce_dashboard/views/vendor/add_vendor/resposive_screens/add_vendor_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/vendor/vendor_model.dart';
import '../../../controllers/vendor/vendor_controller.dart';
import 'resposive_screens/add_vendor_tablet.dart';

class AddVendorScreen extends StatelessWidget {
  const AddVendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VendorModel vendorModel = Get.arguments ?? VendorModel.empty();
    final VendorController vendorController = Get.find<VendorController>();

    // Load vendor details if editing, or clean details if adding new
    if (vendorModel.vendorId != null) {
      vendorController.setVendorDetail(vendorModel);
    } else {
      vendorController.cleanVendorDetails();
    }

    return TSiteTemplate(
      useLayout: false,
      desktop: AddVendorDesktop(vendorModel: vendorModel),
      tablet: AddVendorTablet(vendorModel: vendorModel),
      mobile: AddVendorMobile(vendorModel: vendorModel),
    );
  }
}
