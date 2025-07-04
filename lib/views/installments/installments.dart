import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/installments/responsive_screens/installment_desktop.dart';
import 'package:ecommerce_dashboard/views/installments/responsive_screens/installment_tablet.dart';
import 'package:ecommerce_dashboard/views/installments/responsive_screens/installment_mobile.dart';
import 'package:flutter/material.dart';

class InstallmentsScreen extends StatelessWidget {
  const InstallmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: InstallmentDesktop(),
      tablet: InstallmentTablet(),
      mobile: InstallmentMobile(),
    );
  }
}
