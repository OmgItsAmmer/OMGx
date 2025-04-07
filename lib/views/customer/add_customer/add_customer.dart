import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';
import 'package:admin_dashboard_v3/views/customer/add_customer/resposive_screens/add_customer_desktop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerModel = Get.arguments;
    return  TSiteTemplate(

      desktop: AddCustomerDesktop(customerModel: customerModel,),
    );
  }
}
