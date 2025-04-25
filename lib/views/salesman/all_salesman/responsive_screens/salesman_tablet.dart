import 'package:admin_dashboard_v3/Models/salesman/salesman_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/salesman/all_salesman/table/salesman_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SalesmanTablet extends StatelessWidget {
  const SalesmanTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for salesmen
    if (!Get.isRegistered<TableSearchController>(tag: 'salesmen')) {
      Get.put(TableSearchController(), tag: 'salesmen');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'salesmen');

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(
                'Salesman',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              //Table
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 180,
                          child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(TRoutes.addSalesman,
                                    arguments: SalesmanModel.empty());
                              },
                              child: Text(
                                'Add New Salesman',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(color: TColors.white),
                              )),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: TSizes.md),
                            child: TextFormField(
                              controller:
                                  tableSearchController.searchController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Iconsax.search_normal),
                                  hintText: 'Search by name, email, or phone'),
                              onChanged: (value) {
                                // Update the search term
                                tableSearchController.searchTerm.value = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwSections,
                    ),
                    const SalesmanTable(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
