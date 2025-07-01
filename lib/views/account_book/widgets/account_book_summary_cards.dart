import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/account_book/account_book_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AccountBookSummaryCards extends StatelessWidget {
  const AccountBookSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AccountBookController.instance;

    return Obx(() {
      if (controller.isSummaryLoading.value) {
        return const Row(
          children: [
            Expanded(
                child: Card(child: Center(child: CircularProgressIndicator()))),
            SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
                child: Card(child: Center(child: CircularProgressIndicator()))),
            SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
                child: Card(child: Center(child: CircularProgressIndicator()))),
          ],
        );
      }

      return Row(
        children: [
          // Total Incoming Payments Card
          Expanded(
            child: _SummaryCard(
              title: 'Total Incoming',
              amount: controller.totalIncoming.value,
              icon: Iconsax.arrow_down_1,
              color: TColors.success,
              isIncoming: true,
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),

          // Total Outgoing Payments Card
          Expanded(
            child: _SummaryCard(
              title: 'Total Outgoing',
              amount: controller.totalOutgoing.value,
              icon: Iconsax.arrow_up_3,
              color: TColors.error,
              isIncoming: false,
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),

          // Net Balance Card
          Expanded(
            child: _SummaryCard(
              title: 'Net Balance',
              amount: controller.netBalance.value,
              icon: Iconsax.wallet_3,
              color: controller.netBalance.value >= 0
                  ? TColors.success
                  : TColors.error,
              isBalance: true,
            ),
          ),
        ],
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isIncoming;
  final bool isBalance;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.isIncoming = false,
    this.isBalance = false,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.apply(
                          color: TColors.darkGrey,
                        ),
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.apply(
                          color: color,
                          fontWeightDelta: 2,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(TSizes.sm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.sm),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.sm),

          // Additional info based on card type
          if (isBalance)
            Text(
              amount >= 0 ? 'Positive Balance' : 'Negative Balance',
              style: Theme.of(context).textTheme.bodySmall?.apply(
                    color: color,
                  ),
            )
          else
            Text(
              isIncoming ? 'Money Received' : 'Money Paid',
              style: Theme.of(context).textTheme.bodySmall?.apply(
                    color: TColors.darkGrey,
                  ),
            ),
        ],
      ),
    );
  }
}
