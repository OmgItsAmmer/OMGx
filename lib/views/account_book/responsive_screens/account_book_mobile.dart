import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/account_book/account_book_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/account_book_summary_cards.dart';
import '../widgets/account_book_mobile_card.dart';
import '../widgets/add_account_book_dialog.dart';

class AccountBookMobile extends StatelessWidget {
  const AccountBookMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final accountBookController = AccountBookController.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account Book',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Row(
                    children: [
                      TCircularIcon(
                        icon: Iconsax.add,
                        backgroundColor: TColors.primary,
                        color: TColors.white,
                        onPressed: () {
                          _showAddEntryDialog(context, accountBookController);
                        },
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
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Summary Cards
              const AccountBookSummaryCards(),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Search Bar
              TextFormField(
                controller: accountBookController.searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.search_normal),
                  hintText: 'Search entries...',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Filters
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: TSizes.sm),

                    // Entity Type Filter
                    Obx(() => DropdownButtonFormField<EntityType>(
                          initialValue: accountBookController.filterEntityType.value,
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
                            ...EntityType.values.map((type) => DropdownMenuItem(
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
                    const SizedBox(height: TSizes.sm),

                    // Transaction Type Filter
                    Obx(() => DropdownButtonFormField<TransactionType>(
                          initialValue:
                              accountBookController.filterTransactionType.value,
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
                                      child: Text(type == TransactionType.buy
                                          ? 'Incoming'
                                          : 'Outgoing'),
                                    )),
                          ],
                          onChanged: (value) {
                            accountBookController.filterTransactionType.value =
                                value;
                          },
                        )),
                    const SizedBox(height: TSizes.sm),

                    // Date Range Filters
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
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
                        ),
                        const SizedBox(width: TSizes.sm),
                        Expanded(
                          child: TextFormField(
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
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Account Book Entries as Cards
              Obx(() {
                if (accountBookController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (accountBookController.filteredEntries.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(
                          Iconsax.receipt_item,
                          size: 64,
                          color: TColors.grey,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Text(
                          'No account book entries found',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.apply(color: TColors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: accountBookController.filteredEntries.length,
                  itemBuilder: (context, index) {
                    final entry = accountBookController.filteredEntries[index];
                    return AccountBookMobileCard(
                      entry: entry,
                      onEdit: () {
                        accountBookController.loadEntryForEditing(entry);
                        _showAddEntryDialog(context, accountBookController);
                      },
                      onDelete: () {
                        _showDeleteConfirmation(context, accountBookController,
                            entry.accountBookId!);
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEntryDialog(
      BuildContext context, AccountBookController controller) {
    showDialog(
      context: context,
      builder: (context) => const AddAccountBookDialog(),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, AccountBookController controller, int entryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
            'Are you sure you want to delete this account book entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAccountBookEntry(entryId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
