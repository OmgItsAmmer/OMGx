import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

class AddSalesmanBottomBar extends StatelessWidget {
  const AddSalesmanBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SalesmanController salesmanController = Get.find<SalesmanController>();

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
                  salesmanController.cleanSalesmanDetails();
                  Get.back();
                },
                child: const Text('Discard'),
              ),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Save action
                  salesmanController.saveOrUpdateSalesman();
                },
                child: const Text('Save'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}