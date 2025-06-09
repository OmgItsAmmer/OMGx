import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/dropdown_search/enhanced_autocomplete.dart';
import '../../../common/widgets/icons/t_circular_icon.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/validators/validation.dart';

class SalesSalemanInfo extends StatelessWidget {
  const SalesSalemanInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();
    final SalesmanController salesmanController =
        Get.find<SalesmanController>();

    return Form(
      key: salesController.salesmanFormKey,
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salesman Information',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TCircularIcon(
                  icon: Iconsax.refresh,
                  backgroundColor: TColors.primary.withOpacity(0.1),
                  color: TColors.primary,
                  onPressed: () {
                    // Use the dedicated method for resetting salesman fields
                    // This is a safer implementation that won't cause navigation issues
                    salesController.resetSalesmanFields();
                  },
                ),
              ],
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            SizedBox(
              width: 300,
              child: EnhancedAutocomplete<String>(
                showOptionsOnFocus: true,
                labelText: 'Salesman',
                hintText: 'Select a salesman',
                options: salesmanController.allSalesmanNames,
                externalController: salesController.salesmanNameController,
                displayStringForOption: (String option) => option,
                validator: (value) =>
                    TValidator.validateEmptyText('Salesman', value),
                onSelected: (String val) {
                  if (val.isEmpty) {
                    return;
                  }

                  final selectedSalesman = salesmanController.allSalesman
                      .firstWhere((user) => user.fullName == val);

                  salesController.selectedSalesmanId =
                      selectedSalesman.salesmanId!;
                  salesController.salesmanCityController.value.text =
                      selectedSalesman.city;
                  salesController.salesmanAreaController.value.text =
                      selectedSalesman.area;
                },
                onManualTextEntry: (String text) {
                  if (text.isEmpty) {
                    // Reset logic when field is cleared
                    salesController.selectedSalesmanId = -1;
                    salesController.salesmanCityController.value.text = '';
                    salesController.salesmanAreaController.value.text = '';
                  }
                },
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => TextFormField(
                  onChanged: (value) {},
                  readOnly: true,
                  controller: salesController.salesmanCityController.value,
                  validator: (value) =>
                      TValidator.validateEmptyText('City', value),
                  decoration: const InputDecoration(labelText: 'City'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => TextFormField(
                  onChanged: (value) {},
                  readOnly: true,
                  controller: salesController.salesmanAreaController.value,
                  validator: (value) =>
                      TValidator.validateEmptyText('Area', value),
                  decoration: const InputDecoration(labelText: 'Area'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            //   const SizedBox(height: TSizes.spaceBtwItems,),
          ],
        ),
      ),
    );
  }
}
