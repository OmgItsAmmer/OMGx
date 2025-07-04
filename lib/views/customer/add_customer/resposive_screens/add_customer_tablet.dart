import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../widget/add_customer_bottom_bar.dart';
import '../widget/customer_basic_info.dart';
import '../widget/customer_thumbnail_info.dart';

class AddCustomerTablet extends StatelessWidget {
  const AddCustomerTablet({super.key, required this.customerModel});

  final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for tablet layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Info
                  Expanded(
                    flex: 3,
                    child: CustomerBasicInfo(),
                  ),

                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Thumbnail Upload
                  Expanded(
                    flex: 2,
                    child: CustomerThumbnailInfo(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AddCustomerBottomBar(customerModel: customerModel),
    );
  }
}
