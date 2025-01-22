import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ThumbnailInfo extends StatelessWidget {
  const ThumbnailInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TRoundedImage(
                width: 350,
                height: 170,
                imageurl: TImages.productImage1),
            OutlinedButton(
                onPressed: () {},
                child: Text(
                  'Add Thumbnail',
                  style: Theme.of(context).textTheme.titleMedium,
                )),
          ],
        ),
      ),
    );
  }
}
