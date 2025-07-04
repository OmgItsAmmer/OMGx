import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/dashboard/dashboard_controoler.dart';
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
  final bool isLoading;
  final Rx<DataFetchState> cardState;

  @override
  Widget build(BuildContext context) {
    // Determine icon and color based on stats (logic stays here, just not rendered)
    IconData? statusIcon = icon;
    Color statusColor = color;

    if (stats == 0 && cardState.value == DataFetchState.success) {
      statusIcon = null;
      statusColor = Colors.amber;
    }

    // Handle NaN display for value and stats - only when data is successfully loaded
    String displayValue = value;
    String displayStats = '$stats%';

    // Only show NaN when data has been successfully loaded but values are zero
    if (cardState.value == DataFetchState.success) {
      double? numericValue =
          double.tryParse(value.replaceAll('Rs ', '').replaceAll(',', ''));
      if (numericValue != null && numericValue == 0) {
        displayValue = value.contains('Rs') ? 'Rs 0.00' : '0';
      }
      if (stats == 0) {
        displayStats = '0%';
      }
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
              cardState.value == DataFetchState.loading
                  ? const TStripLoader(width: 100, height: 25)
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
              // Value display with loading state
              cardState.value == DataFetchState.loading
                  ? const TStripLoader(width: 150, height: 30)
                  : Text(
                      displayValue,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

              // Stats with loading state (icon removed)
              Column(
                children: [
                  Row(
                    children: [
                      cardState.value == DataFetchState.loading
                          ? const TStripLoader(width: 50, height: 25)
                          : Text(
                              displayStats,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .apply(color: statusColor),
                            ),
                    ],
                  ),
                  SizedBox(
                    width: 135,
                    child: cardState.value == DataFetchState.loading
                        ? const TStripLoader(width: 130, height: 20)
                        : Text(
                            subTitle,
                            style: Theme.of(context).textTheme.labelMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
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
