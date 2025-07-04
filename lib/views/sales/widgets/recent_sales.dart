import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RecentSales extends StatelessWidget {
  const RecentSales({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Sales',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const _RecentSaleItem(
            customerName: 'John Doe',
            amount: '\$1,250.00',
            date: '10 Jun 2023',
            status: 'Completed',
            isCompleted: true,
          ),
          const Divider(),
          const _RecentSaleItem(
            customerName: 'Alice Smith',
            amount: '\$780.50',
            date: '8 Jun 2023',
            status: 'Completed',
            isCompleted: true,
          ),
          const Divider(),
          const _RecentSaleItem(
            customerName: 'Robert Johnson',
            amount: '\$350.75',
            date: '5 Jun 2023',
            status: 'Pending',
            isCompleted: false,
          ),
          const Divider(),
          const _RecentSaleItem(
            customerName: 'Emily Davis',
            amount: '\$920.00',
            date: '1 Jun 2023',
            status: 'Completed',
            isCompleted: true,
          ),
        ],
      ),
    );
  }
}

class _RecentSaleItem extends StatelessWidget {
  final String customerName;
  final String amount;
  final String date;
  final String status;
  final bool isCompleted;

  const _RecentSaleItem({
    required this.customerName,
    required this.amount,
    required this.date,
    required this.status,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm / 2),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(
              Iconsax.user,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
