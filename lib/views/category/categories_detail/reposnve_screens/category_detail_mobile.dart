import 'package:ecommerce_dashboard/Models/category/category_model.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../all_categories/widgets/category_info.dart';

class CategoryDetailMobile extends StatelessWidget {
  const CategoryDetailMobile({super.key, required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              child: CategoryInfo(
                categoryModel: categoryModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
