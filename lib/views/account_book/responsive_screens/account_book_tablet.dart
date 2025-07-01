import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/account_book/account_book_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/account_book_summary_cards.dart';
import '../widgets/account_book_table.dart';
import '../widgets/add_account_book_dialog.dart';

class AccountBookTablet extends StatelessWidget {
  const AccountBookTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for account book
    if (!Get.isRegistered<TableSearchController>(tag: 'account_book')) {
      Get.put(TableSearchController(), tag: 'account_book');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'account_book');
    final accountBookController = AccountBookController.instance;

    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Account Book',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Summary Cards
                const AccountBookSummaryCards(),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Main Table Container
                TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Add Button and Search
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showAddEntryDialog(
                                        context, accountBookController);
                                  },
                                  child: Text(
                                    'Add New Entry',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(color: TColors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: TSizes.sm),
                              TCircularIcon(
                                icon: Iconsax.refresh,
                                backgroundColor: TColors.primary,
                                color: TColors.white,
                                onPressed: () {
                                  accountBookController.refreshData();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),

                          // Search Bar
                          TextFormField(
                            controller: accountBookController.searchController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.search_normal),
                              hintText:
                                  'Search by entity name, description, or reference',
                            ),
                            onChanged: (value) {
                              // Search is handled automatically by the controller
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      // Filters Grid
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: TSizes.sm,
                        mainAxisSpacing: TSizes.sm,
                        children: [
                          // Entity Type Filter
                          Obx(() => DropdownButtonFormField<EntityType>(
                                value: accountBookController
                                    .filterEntityType.value,
                                decoration: const InputDecoration(
                                  labelText: 'Entity Type',
                                  border: OutlineInputBorder(),
                                ),
                                hint: const Text('All Types'),
                                items: [
                                  const DropdownMenuItem<EntityType>(
                                    value: null,
                                    child: Text('All Types'),
                                  ),
                                  ...EntityType.values
                                      .map((type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(type
                                                .toString()
                                                .split('.')
                                                .last
                                                .capitalize!),
                                          )),
                                ],
                                onChanged: (value) {
                                  accountBookController.filterEntityType.value =
                                      value;
                                },
                              )),

                          // Transaction Type Filter
                          Obx(() => DropdownButtonFormField<TransactionType>(
                                value: accountBookController
                                    .filterTransactionType.value,
                                decoration: const InputDecoration(
                                  labelText: 'Transaction Type',
                                  border: OutlineInputBorder(),
                                ),
                                hint: const Text('All Transactions'),
                                items: [
                                  const DropdownMenuItem<TransactionType>(
                                    value: null,
                                    child: Text('All Transactions'),
                                  ),
                                  ...TransactionType.values
                                      .map((type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(
                                                type == TransactionType.buy
                                                    ? 'Incoming'
                                                    : 'Outgoing'),
                                          )),
                                ],
                                onChanged: (value) {
                                  accountBookController
                                      .filterTransactionType.value = value;
                                },
                              )),

                          // Start Date Filter
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Iconsax.calendar),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                accountBookController.filterStartDate.value =
                                    date;
                              }
                            },
                            controller: TextEditingController(
                              text: accountBookController.filterStartDate.value
                                      ?.toString()
                                      .split(' ')[0] ??
                                  '',
                            ),
                          ),

                          // End Date Filter
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Iconsax.calendar),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                accountBookController.filterEndDate.value =
                                    date;
                              }
                            },
                            controller: TextEditingController(
                              text: accountBookController.filterEndDate.value
                                      ?.toString()
                                      .split(' ')[0] ??
                                  '',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Clear Filters Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            accountBookController.clearFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.grey,
                          ),
                          child: const Text('Clear Filters'),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Account Book Table
                      const AccountBookTable(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEntryDialog(
      BuildContext context, AccountBookController controller) {
    controller.clearForm();
    showDialog(
      context: context,
      builder: (context) => const AddAccountBookDialog(),
    );
  }
}
