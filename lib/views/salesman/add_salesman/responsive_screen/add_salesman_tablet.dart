import 'package:ecommerce_dashboard/Models/salesman/salesman_model.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../widgets/add_salesman_bottom_bar.dart';
import '../widgets/salesman_basic_info.dart';
import '../widgets/salesman_thumbnaiil_info.dart';

class AddSalesmanTablet extends StatelessWidget {
  const AddSalesmanTablet({super.key, required this.salesmanModel});

  final SalesmanModel salesmanModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row containing both info sections for tablet
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Info
                  Expanded(
                    flex: 3,
                    child: SalesmanBasicInfo(),
                  ),

                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Thumbnail Upload
                  Expanded(
                    flex: 2,
                    child: SalesmanThumbnailInfo(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AddSalesmanBottomBar(salesmanModel: salesmanModel),
    );
  }
}
