import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_controller.dart';
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

class InstallmentDesktop extends StatelessWidget {
  const InstallmentDesktop({super.key});

  @override
  Widget build(BuildContext context) {
   // final InstallmentController installmentController = Get.find<InstallmentController>();
    final SalesController salesController = Get.find<SalesController>();
    final GuarantorController guarantorController = Get.put(GuarantorController());


    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Row(
                   // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Expanded(
                        flex: 1,
                        child: CustomerCard(
                          cardTitle: 'Customer Info',
                          hintText: 'Customer Name',
                          readOnly: true,
                          userNameTextController: salesController.customerNameController,
                          addressTextController: salesController.customerAddressController.value,
                          cnicTextController: salesController.customerCNICController.value,
                          phoneNoTextController: salesController.customerPhoneNoController.value,

                        ),

                      ),


                      const SizedBox(
                        width: TSizes.spaceBtwSections, // Replace TSizes.spaceBtwSections if needed
                      ),
                      Expanded(
                        flex: 2,
                        child: GuarrantorCard(
                          cardTitle: 'Guarantee 1 Info',
                          hintText: 'Guarantee Name',
                          namesList: const ['empty'],
                          addressList: const ['empty'],
                          readOnly: false,
                          onSelectedName: (val){},
                          userNameTextController: guarantorController.guraante1Name,
                          addressTextController: guarantorController.guraante1Address,
                          cnicTextController: guarantorController.guraante1CNIC,
                          phoneNoTextController: guarantorController.guraante1PhoneNo,
                          formKey: guarantorController.guraante1FormKey,

                        ),
                      ),
                      const SizedBox(
                        width: TSizes.spaceBtwSections, // Replace TSizes.spaceBtwSections if needed
                      ),
                      Expanded(
                        flex: 2,
                        child: GuarrantorCard(

                          cardTitle: 'Guarantee 2 Info',
                          hintText: 'Guarantee Name',
                          namesList: const ['empty'],
                          addressList: const ['empty'],
                          readOnly: false,
                          onSelectedName: (val){},
                          userNameTextController: guarantorController.guraante2Name,
                          addressTextController: guarantorController.guraante2Address,
                          cnicTextController: guarantorController.guraante2CNIC,
                          phoneNoTextController: guarantorController.guraante2PhoneNo,
                          formKey: guarantorController.guraante2FormKey,


                        ),
                      ),
                      const SizedBox(
                        width: TSizes.spaceBtwSections, // Replace\ TSizes.spaceBtwSections if needed
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Installment Setup',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections,),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Charges
                          Expanded(child: SizedBox(
                            //  height: 530,
                              child: ChargesForm())),

                          SizedBox(width: TSizes.spaceBtwSections,),

                          // Duration / Time

                          Expanded(child: DurationInfo()),

                          SizedBox(width: TSizes.spaceBtwSections,),
                          // Generate Button
                          Expanded(
                            child: Column(
                              children: [
                                AdvanceInfo(),
                                SizedBox(height: TSizes.spaceBtwSections,),
                                InstallmentActionButtons()
                              ],
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections,),

                 TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Tab;e Header
                      Text(
                        'Installment Plan',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections,),
                      //Table
                      const InstallmentTable(),


                    ],

                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections,),
                 const InstallmentFooterButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

