import 'package:admin_dashboard_v3/Models/purchase/purchase_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/purchase/purchase_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/loaders/tloaders.dart';

class PurchaseInfo extends StatelessWidget {
  const PurchaseInfo({super.key, required this.purchaseModel});

  final PurchaseModel purchaseModel;

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();

    // Initialize the PurchaseController status based on purchase status
    PurchaseStatus purchaseStatus = PurchaseStatus.values.firstWhere(
      (status) => status.toString().split('.').last == purchaseModel.status,
      orElse: () => PurchaseStatus.pending,
    );
    purchaseController.selectedStatus.value = purchaseStatus;

    // Check if we're on a small screen (mobile or small tablet)
    final bool isSmallScreen = TDeviceUtils.isMobileScreen(context) ||
        MediaQuery.of(context).size.width < 600;

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Purchase Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // For small screens, use a column layout instead of row to prevent overflow
          isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Padding(
                      padding: const EdgeInsets.only(bottom: TSizes.sm),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text('Date'),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(purchaseModel.purchaseDate)),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Items
                    Padding(
                      padding: const EdgeInsets.only(bottom: TSizes.sm),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text('Items'),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              purchaseModel.purchaseItems?.length.toString() ??
                                  '0',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status
                    Padding(
                      padding: const EdgeInsets.only(bottom: TSizes.sm),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text('Status'),
                          ),
                          Expanded(
                            flex: 3,
                            child: _buildStatusDropdown(
                                context, purchaseController),
                          ),
                        ],
                      ),
                    ),

                    // Purchase ID
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text('Purchase ID'),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '#${purchaseModel.purchaseId}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Date'),
                          Text(
                            DateFormat('dd-MM-yyyy').format(
                                DateTime.parse(purchaseModel.purchaseDate)),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Items'),
                          Text(
                            purchaseModel.purchaseItems?.length.toString() ??
                                '0',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status'),
                          _buildStatusDropdown(context, purchaseController),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                      child: Column(
                        children: [
                          const Text('Purchase ID'),
                          Text(
                            '#${purchaseModel.purchaseId}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // Extracted dropdown into a separate method for reuse
  Widget _buildStatusDropdown(
      BuildContext context, PurchaseController purchaseController) {
    // Constrain dropdown width based on screen size
    final double dropdownWidth = TDeviceUtils.isMobileScreen(context)
        ? 120 // For mobile
        : MediaQuery.of(context).size.width < 1200
            ? 150 // For tablets
            : 200; // For desktops

    return SizedBox(
      width: dropdownWidth,
      child: TRoundedContainer(
        radius: TSizes.cardRadiusSm,
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: TSizes.sm,
        ),
        backgroundColor: THelperFunctions.getPurchaseStatusColor(
                purchaseController.selectedStatus.value)
            .withValues(alpha: 0.1),
        child: Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton<PurchaseStatus>(
              isDense: true,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(vertical: 0),
              value: purchaseController.selectedStatus.value,
              items: PurchaseStatus.values.map((PurchaseStatus status) {
                return DropdownMenuItem<PurchaseStatus>(
                  value: status,
                  child: Text(
                    status.name.capitalize.toString(),
                    style: TextStyle(
                      fontSize: TDeviceUtils.isMobileScreen(context) ? 12 : 14,
                      color: THelperFunctions.getPurchaseStatusColor(status),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (PurchaseStatus? newValue) async {
                if (newValue != null) {
                  try {
                    // Get the new status string (e.g., "pending", "cancelled")
                    final newStatusString = newValue.toString().split('.').last;

                    // Update the status in the database and get confirmation back
                    final updatedStatus = await purchaseController.updateStatus(
                      purchaseModel.purchaseId,
                      newStatusString,
                    );

                    // If we got a valid status back, update the UI
                    if (updatedStatus.isNotEmpty) {
                      // Convert string to enum and update UI dropdown
                      final updatedPurchaseStatus =
                          PurchaseStatus.values.firstWhere(
                        (status) =>
                            status.toString().split('.').last == updatedStatus,
                        orElse: () => purchaseController.selectedStatus.value,
                      );

                      // Update the controller status
                      purchaseController.selectedStatus.value =
                          updatedPurchaseStatus;
                    }
                  } catch (e) {
                    TLoaders.errorSnackBar(
                        title: 'Status Update Failed',
                        message:
                            'Could not update purchase status: ${e.toString()}');

                    // Revert dropdown to previous value if there was an error
                    final revertStatus = PurchaseStatus.values.firstWhere(
                      (status) =>
                          status.toString().split('.').last ==
                          purchaseModel.status,
                      orElse: () => purchaseController.selectedStatus.value,
                    );
                    purchaseController.selectedStatus.value = revertStatus;
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
