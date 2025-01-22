import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/basic_info.dart';
import '../widgets/extra_images.dart';
import '../widgets/product_brand&category.dart';
import '../widgets/thumbnail_info.dart';
import '../widgets/variation_info.dart';

class ProductDetailDesktop extends StatelessWidget {
  const ProductDetailDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: SingleChildScrollView(
        child: SizedBox(
          // height: 760,

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Basic Info
                    BasicInfo(),
                    SizedBox(height: TSizes.spaceBtwSections,),
                    //Variation Info
                    VariationInfo(),


                  ],
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwSections,),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   // Thumbnail Upload
                    ThumbnailInfo(),

                    // Extra Images
                    const SizedBox(height: TSizes.spaceBtwSections,),
                    ExtraImages(),
                    //Brand & Category & visibility
                    const SizedBox(height: TSizes.spaceBtwSections,),
                    ProductBrandcCategory(),


                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
