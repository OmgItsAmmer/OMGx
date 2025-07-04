import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/guarantors/guarantor_controller.dart';
import 'package:ecommerce_dashboard/controllers/guarantors/guarantor_image_controller.dart';
import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../table/installment_table.dart';
import '../widgets/charges_form.dart';
import '../widgets/advance_info.dart';
import '../widgets/customer_card.dart';
import '../widgets/duration_info.dart';
import '../widgets/installment_action_buttons.dart';
import '../widgets/installment_footer_buttons.dart';
import '../widgets/guarantor_card.dart';

class InstallmentTablet extends StatelessWidget {
  const InstallmentTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();
    final GuarantorController guarantorController =
        Get.put(GuarantorController());

    if (!Get.isRegistered<GuarantorImageController>()) {
      final guarantorImageController = Get.put(GuarantorImageController());
      // Set to not fetch images from database by default
      guarantorImageController.setFetchFromDatabase(false);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer and Guarantor Info
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  // Customer Info
                  CustomerCard(
                    cardTitle: 'Customer Info',
                    hintText: 'Customer Name',
                    readOnly: true,
                    userNameTextController:
                        salesController.customerNameController,
                    addressTextController:
                        salesController.customerAddressController.value,
                    cnicTextController:
                        salesController.customerCNICController.value,
                    phoneNoTextController:
                        salesController.customerPhoneNoController.value,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Guarantor 1
                  GuarrantorCard(
                    guarrantorIndex: 1,
                    cardTitle: 'Guarantee 1 Info',
                    hintText: 'Guarantee Name',
                    namesList: const ['empty'],
                    addressList: const ['empty'],
                    readOnly: false,
                    onSelectedName: (val) {},
                    userNameTextController: guarantorController.guraante1Name,
                    addressTextController: guarantorController.guraante1Address,
                    cnicTextController: guarantorController.guraante1CNIC,
                    phoneNoTextController: guarantorController.guraante1PhoneNo,
                    formKey: guarantorController.guraante1FormKey,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Guarantor 2
                  GuarrantorCard(
                    guarrantorIndex: 2,
                    cardTitle: 'Guarantee 2 Info',
                    hintText: 'Guarantee Name',
                    namesList: const ['empty'],
                    addressList: const ['empty'],
                    readOnly: false,
                    onSelectedName: (val) {},
                    userNameTextController: guarantorController.guraante2Name,
                    addressTextController: guarantorController.guraante2Address,
                    cnicTextController: guarantorController.guraante2CNIC,
                    phoneNoTextController: guarantorController.guraante2PhoneNo,
                    formKey: guarantorController.guraante2FormKey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Installment Setup
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Installment Setup',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Charges Form
                  const ChargesForm(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Duration Info
                  const DurationInfo(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Advance Info and Action Buttons
                  const AdvanceInfo(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const InstallmentActionButtons(),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Installment Plan Table
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Installment Plan',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const InstallmentTable(),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Footer Buttons
            const InstallmentFooterButtons()
          ],
        ),
      ),
    );
  }
}
