import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../Models/brand/brand_model.dart';
import '../widgets/brand_info.dart';

class BrandDetailTablet extends StatelessWidget {
  const BrandDetailTablet({super.key, required this.brandModel});
  final BrandModel brandModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: BrandInfo(
                brandModel: brandModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
