import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/containers/rounded_container.dart';
import '../../../common/widgets/heading/section_heading.dart';
import '../../../common/widgets/loaders/strip_loader.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TDashBoardCard extends StatelessWidget {
  const TDashBoardCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.value,
    required this.isLoading,
    this.icon = Iconsax.arrow_up_3,
    this.color = TColors.success,
    required this.stats,
    this.onTap,
    required this.iconWidget,
  });

  final String title, subTitle, value;
  final IconData icon;
  final Color color;
  final int stats;
  final void Function()? onTap;
  final TCircularIcon iconWidget;
  final RxBool isLoading;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(TSizes.lg),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Heading
          Row(
            children: [
              iconWidget,
              const SizedBox(width: TSizes.spaceBtwItems),
              isLoading.value
                  ? const TStripLoader(width: 80, height: 20)
                  : TSectionHeading(
                title: title,
                textColor: TColors.textSecondary,
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          /// Value & Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoading.value
                  ? const TStripLoader(width: 60, height: 24)
                  : Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color, size: TSizes.iconSm),
                      isLoading.value
                          ? const TStripLoader(width: 40, height: 20)
                          : Text(
                        '$stats%',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(color: color),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 135,
                    child: isLoading.value
                        ? const TStripLoader(width: 100, height: 16)
                        : Text(
                      subTitle,
                      style:
                      Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      )),
    );
  }
}
