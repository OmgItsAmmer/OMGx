import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SalesStats extends StatelessWidget {
  const SalesStats({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              _buildStatItem(
                context,
                Iconsax.tag,
                'Total Sales',
                '\$15,850',
                '+12.5%',
                true,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              _buildStatItem(
                context,
                Iconsax.shopping_cart,
                'Orders',
                '256',
                '+25%',
                true,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              _buildStatItem(
                context,
                Iconsax.people,
                'Customers',
                '54',
                '+8.2%',
                true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String change,
    bool isPositive,
  ) {
    return Expanded(
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 20),
                Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Text(title, style: Theme.of(context).textTheme.labelMedium),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
