import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../widget/add_customer_bottom_bar.dart';
import '../widget/customer_basic_info.dart';
import '../widget/customer_thumbnail_info.dart';

class AddCustomerMobile extends StatelessWidget {
  const AddCustomerMobile({super.key, required this.customerModel});

  final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stacked vertically for mobile
              // Thumbnail first
              const CustomerThumbnailInfo(),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Basic Info
              const CustomerBasicInfo(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AddCustomerBottomBar(customerModel: customerModel),
    );
  }
}
