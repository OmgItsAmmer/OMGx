import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_controller.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_image_controller.dart';
import 'package:admin_dashboard_v3/controllers/sales/sales_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
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

class InstallmentMobile extends StatelessWidget {
  const InstallmentMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();
    final GuarantorController guarantorController =
        Get.put(GuarantorController());

    if (!Get.isRegistered<GuarantorImageController>()) {
      Get.put(GuarantorImageController());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Info
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              child: CustomerCard(
                cardTitle: 'Customer Info',
                hintText: 'Customer Name',
                readOnly: true,
                userNameTextController: salesController.customerNameController,
                addressTextController:
                    salesController.customerAddressController.value,
                cnicTextController:
                    salesController.customerCNICController.value,
                phoneNoTextController:
                    salesController.customerPhoneNoController.value,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Guarantor 1
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              child: GuarrantorCard(
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
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Guarantor 2
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              child: GuarrantorCard(
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
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Installment Setup
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Installment Setup',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Charges Form
                  const ChargesForm(),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Duration Info
                  const DurationInfo(),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Advance Info and Action Buttons
                  const AdvanceInfo(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const InstallmentActionButtons(),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Installment Plan Table
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Installment Plan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: InstallmentTable(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Footer Buttons
            const InstallmentFooterButtons()
          ],
        ),
      ),
    );
  }
}
