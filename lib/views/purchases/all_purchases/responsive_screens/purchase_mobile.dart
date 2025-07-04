import 'package:ecommerce_dashboard/Models/purchase/purchase_model.dart';
import 'package:ecommerce_dashboard/controllers/purchase/purchase_controller.dart';
import 'package:ecommerce_dashboard/controllers/vendor/vendor_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PurchasesMobileScreen extends StatelessWidget {
  const PurchasesMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();
    final VendorController vendorController = Get.find<VendorController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        final purchases = purchaseController.allPurchases;

        if (purchaseController.isPurchasesFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (purchases.isEmpty) {
          return const Center(
            child: Text(
              'No purchases found',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const Text(
                'Purchase Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              /// Purchase Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: purchases.length,
                itemBuilder: (context, index) {
                  final purchase = purchases[index];
                  final vendor = vendorController.allVendors
                      .firstWhereOrNull((v) => v.vendorId == purchase.vendorId);

                  return PurchaseCard(
                    purchase: purchase,
                    vendorName: vendor?.fullName ?? 'Unknown Vendor',
                    onTap: () =>
                        purchaseController.setUpPurchaseDetails(purchase),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class PurchaseCard extends StatelessWidget {
  final PurchaseModel purchase;
  final String vendorName;
  final VoidCallback onTap;

  const PurchaseCard({
    super.key,
    required this.purchase,
    required this.vendorName,
    required this.onTap,
  });

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Color getPurchaseStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'received':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Purchase #${purchase.purchaseId}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: TColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.sm,
                      vertical: TSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: getPurchaseStatusColor(purchase.status)
                          .withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(TSizes.borderRadiusSm),
                    ),
                    child: Text(
                      purchase.status.toUpperCase(),
                      style: TextStyle(
                        color: getPurchaseStatusColor(purchase.status),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Details
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: TColors.darkGrey),
                  const SizedBox(width: 8),
                  Text(
                    vendorName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: TColors.darkGrey),
                  const SizedBox(width: 8),
                  Text(
                    formatDate(purchase.purchaseDate),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.monetization_on,
                      size: 16, color: TColors.darkGrey),
                  const SizedBox(width: 8),
                  Text(
                    '\$${purchase.subTotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
