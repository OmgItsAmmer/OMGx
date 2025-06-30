import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

class AddCustomerBottomBar extends StatelessWidget {
   const AddCustomerBottomBar( {
    super.key,
   required this.customerModel,

  });
   final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController = Get.find<CustomerController>();

    return TRoundedContainer(

      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: TDeviceUtils.isDesktopScreen(context) ? 4 : 0,
              child: const SizedBox()),
          Expanded(
            child: SizedBox(
              width: double.infinity,

              child: OutlinedButton(
                onPressed: () {
                  customerController.cleanCustomerDetails();
                  Navigator.of(context).pop();
                },
                child: const Text('Discard'),
              ),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Obx(
              () => ElevatedButton(
                  onPressed: () async {
                    if(customerModel.customerId == null ) { // save
                      // Handle Save action
                    await customerController.insertCustomer();
                    }
                    else{ //update
                   await customerController.updateCustomer(customerModel.customerId!);

                     }
                    Navigator.of(context).pop();
                  },
                  child: (customerController.isUpdating.value) ? const CircularProgressIndicator(color: Colors.white,) : (customerModel.customerId == null) ? const Text('Save') : const Text('Update'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}