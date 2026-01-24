import 'package:ecommerce_dashboard/Models/salesman/salesman_model.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../widgets/add_salesman_bottom_bar.dart';
import '../widgets/salesman_basic_info.dart';
import '../widgets/salesman_thumbnaiil_info.dart';

class AddSalesmanMobile extends StatelessWidget {
  const AddSalesmanMobile({super.key, required this.salesmanModel});

  final SalesmanModel salesmanModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stacked vertically for mobile
              // Thumbnail first
              SalesmanThumbnailInfo(),

              SizedBox(height: TSizes.spaceBtwSections),

              // Basic Info
              SalesmanBasicInfo(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AddSalesmanBottomBar(salesmanModel: salesmanModel),
    );
  }
}
