import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CustomerMobile extends StatelessWidget {
  const CustomerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for customers
    if (!Get.isRegistered<TableSearchController>(tag: 'customers')) {
      Get.put(TableSearchController(), tag: 'customers');
    }

    final tableSearchController =
        Get.find<TableSearchController>(tag: 'customers');
    final customerController = Get.find<CustomerController>();
    final mediaController = Get.find<MediaController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Customers',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Controls
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(TRoutes.addCustomer,
                            arguments: CustomerModel.empty());
                      },
                      child: Text(
                        'Add New Customer',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: TColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Search field with refresh icon
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: tableSearchController.searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.search_normal),
                            hintText: 'Search by name, email, or phone',
                          ),
                          onChanged: (value) {
                            tableSearchController.searchTerm.value = value;
                          },
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      TCircularIcon(
                        icon: Iconsax.refresh,
                        backgroundColor: TColors.primary,
                        color: TColors.white,
                        onPressed: () {
                          customerController.refreshCustomers();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Customer Cards List
            Obx(() {
              // Get the search term from the controller
              String searchTerm =
                  tableSearchController.searchTerm.value.toLowerCase();

              // Create a filtered customers list based on search term
              var filteredCustomers = [
                ...customerController.allCustomers
              ]; // Create a copy
              if (searchTerm.isNotEmpty) {
                filteredCustomers =
                    customerController.allCustomers.where((customer) {
                  return customer.fullName.toLowerCase().contains(searchTerm) ||
                      customer.email.toLowerCase().contains(searchTerm) ||
                      customer.phoneNumber.toLowerCase().contains(searchTerm);
                }).toList();
              }

              if (filteredCustomers.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Text(
                      'No customers found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  return CustomerCard(
                    customer: customer,
                    mediaController: mediaController,
                    onView: () async {
                      await customerController
                          .prepareCustomerDetails(customer.customerId);
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final MediaController mediaController;
  final VoidCallback onView;

  const CustomerCard({
    Key? key,
    required this.customer,
    required this.mediaController,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely get customer ID for image retrieval
    final int customerId = customer.customerId is int
        ? customer.customerId as int
        : int.tryParse(customer.customerId?.toString() ?? '-1') ?? -1;

    return TRoundedContainer(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Customer image
              FutureBuilder<String?>(
                future: mediaController.fetchMainImage(
                  customerId,
                  MediaCategory.customers.toString().split('.').last,
                ),
                builder: (context, snapshot) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TSizes.sm),
                    ),
                    child: snapshot.hasData && snapshot.data != null
                        ? TRoundedImage(
                            width: 60,
                            height: 60,
                            isNetworkImage: true,
                            imageurl: snapshot.data!,
                          )
                        : const CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Iconsax.user,
                              size: 30,
                              color: TColors.white,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(width: TSizes.sm),

              // Customer name and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.sms,
                          size: 14,
                          color: TColors.white,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            customer.email,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.sm),
          const Divider(),

          // Contact details
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              children: [
                const Icon(
                  Iconsax.call,
                  size: 16,
                  color: TColors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  customer.phoneNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              children: [
                const Icon(
                  Iconsax.card,
                  size: 16,
                  color: TColors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  customer.cnic.isNotEmpty ? customer.cnic : 'No CNIC provided',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.sm),

          // View details button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onView,
              icon: const Icon(Iconsax.eye),
              label: const Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: TColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
