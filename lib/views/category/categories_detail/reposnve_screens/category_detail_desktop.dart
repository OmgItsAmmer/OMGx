import 'package:admin_dashboard_v3/Models/category/category_model.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../all_categories/widgets/category_info.dart';


class CategoryDetailDesktop extends StatelessWidget {
  const CategoryDetailDesktop({super.key, required this.categoryModel});
  final CategoryModel categoryModel;
  @override
  Widget build(BuildContext context) {

    return  Expanded(child: Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,


            children: [
              Expanded(


                child: TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: CategoryInfo(categoryModel: categoryModel,),
                ),
              ),
              Expanded(flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 0, child: const SizedBox())
            ],
          ),
        ),
      ) ,
    ));
  }
}

