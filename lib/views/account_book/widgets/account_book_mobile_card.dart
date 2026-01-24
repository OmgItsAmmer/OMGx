import 'package:ecommerce_dashboard/Models/account_book/account_book_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AccountBookMobileCard extends StatelessWidget {
  final AccountBookModel entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AccountBookMobileCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Entity Info and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Entity Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.entityName,
                      style: Theme.of(context).textTheme.titleMedium?.apply(
                            fontWeightDelta: 2,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: TSizes.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getEntityTypeColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TSizes.xs),
                      ),
                      child: Text(
                        entry.entityTypeDisplay,
                        style: TextStyle(
                          color: _getEntityTypeColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Iconsax.edit_2, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: TColors.primary.withOpacity(0.1),
                      foregroundColor: TColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Iconsax.trash, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: TColors.error.withOpacity(0.1),
                      foregroundColor: TColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Transaction Type and Amount
          Row(
            children: [
              // Transaction Type Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: entry.isIncoming
                      ? TColors.success.withOpacity(0.1)
                      : TColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.xs),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.isIncoming
                          ? Iconsax.arrow_down_1
                          : Iconsax.arrow_up_3,
                      size: 14,
                      color: entry.isIncoming ? TColors.success : TColors.error,
                    ),
                    const SizedBox(width: TSizes.xs / 2),
                    Text(
                      entry.transactionTypeDisplay,
                      style: TextStyle(
                        color:
                            entry.isIncoming ? TColors.success : TColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Amount
              Text(
                '\$${entry.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.apply(
                      color: entry.isIncoming ? TColors.success : TColors.error,
                      fontWeightDelta: 2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Description
          Text(
            entry.description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Footer with Date and Reference
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date
              Row(
                children: [
                  const Icon(
                    Iconsax.calendar,
                    size: 14,
                    color: TColors.darkGrey,
                  ),
                  const SizedBox(width: TSizes.xs / 2),
                  Text(
                    entry.transactionDate.toString().split(' ')[0],
                    style: Theme.of(context).textTheme.bodySmall?.apply(
                          color: TColors.darkGrey,
                        ),
                  ),
                ],
              ),

              // Reference
              if (entry.reference != null && entry.reference!.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Iconsax.receipt_item,
                      size: 14,
                      color: TColors.darkGrey,
                    ),
                    const SizedBox(width: TSizes.xs / 2),
                    Text(
                      entry.reference!,
                      style: Theme.of(context).textTheme.bodySmall?.apply(
                            color: TColors.darkGrey,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getEntityTypeColor() {
    switch (entry.entityType.toLowerCase()) {
      case 'customer':
        return TColors.primary;
      case 'vendor':
        return TColors.warning;
      case 'salesman':
        return TColors.info;
      default:
        return TColors.darkGrey;
    }
  }
}
