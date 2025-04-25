import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/dashboard/dashboard_controoler.dart';
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
    required this.cardState,
  });

  final String title, subTitle, value;
  final IconData icon;
  final Color color;
  final int stats;
  final void Function()? onTap;
  final TCircularIcon iconWidget;
  final RxBool isLoading;
  final Rx<DataFetchState> cardState;

  @override
  Widget build(BuildContext context) {
    // Determine icon and color based on stats
    IconData statusIcon = icon;
    Color statusColor = color;

    // For zero values, use a neutral icon/color instead of down arrow
    if (stats == 0) {
      statusIcon = Iconsax.status; // Neutral icon
      statusColor = Colors.amber; // Yellow/amber color
    }

    return TRoundedContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(TSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Heading
          Row(
            children: [
              iconWidget,
              const SizedBox(width: TSizes.spaceBtwItems),
              Obx(() => cardState.value == DataFetchState.loading
                  ? const TStripLoader(width: 100, height: 25) // Larger loader
                  : TSectionHeading(
                      title: title,
                      textColor: TColors.textSecondary,
                    )),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          /// Value & Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Value display with loading state
              Obx(() => cardState.value == DataFetchState.loading
                  ? const TStripLoader(width: 150, height: 30) // Larger loader
                  : Text(
                      value,
                      style: Theme.of(context).textTheme.headlineMedium,
                    )),

              // Stats with loading state
              Column(
                children: [
                  Row(
                    children: [
                      Obx(() => Icon(
                          cardState.value == DataFetchState.loading
                              ? Iconsax.timer_1
                              : statusIcon,
                          color: cardState.value == DataFetchState.loading
                              ? Colors.grey
                              : statusColor,
                          size: TSizes.iconSm)),
                      Obx(() => cardState.value == DataFetchState.loading
                          ? const TStripLoader(
                              width: 50, height: 25) // Larger loader
                          : Text(
                              '$stats%',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .apply(color: statusColor),
                            )),
                    ],
                  ),
                  SizedBox(
                    width: 135,
                    child: Obx(() => cardState.value == DataFetchState.loading
                        ? const TStripLoader(
                            width: 130, height: 20) // Larger loader
                        : Text(
                            subTitle,
                            style: Theme.of(context).textTheme.labelMedium,
                            overflow: TextOverflow.ellipsis,
                          )),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
