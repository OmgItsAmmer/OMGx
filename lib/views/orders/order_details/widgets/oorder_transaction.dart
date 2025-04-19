import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/orders/orders_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/validators/validation.dart';

class OrderTransaction extends StatelessWidget {
  const OrderTransaction({super.key, required this.orderModel});
final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    SaleType? saleTypeFromOrder = SaleType.values.firstWhere(
          (e) => e.name == orderModel.saletype,
      orElse: () => SaleType.cash,
    );
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          //Adjust as per your newds
          Row(
            children: [
              Expanded(
                  flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                  child: Row(
                    children: [
                      const TRoundedImage(
                        imageurl: TImages.paypal,
                        isNetworkImage: false,
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputFields,),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sale Type',
                            style: Theme.of(context).textTheme.titleLarge,
                          ), //TODO add payment method to database
                          //Adjust your payment Method Fee if any
                          Text(
                            orderModel.saletype.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ))
                    ],
                  )),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      //Adjust your payment Method Fee if any
                      Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.parse(orderModel.orderDate)),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )),
              Expanded(
                  child: (saleTypeFromOrder != SaleType.installment ) ? Row(

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remaining Amount',
                            style: Theme.of(context).textTheme.labelMedium,
                          ), //TODO add payment method to database
                          //Adjust your payment Method Fee if any
                          Obx(
                              () => Text(
                              (orderController.remainingAmount.value).toStringAsFixed(2),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems,),
                       TRoundedContainer(
                         width: 60,
                           height: 60,
                          onTap: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final remaining = orderController.remainingAmount.value;

      return AlertDialog(
        title: Text(remaining == 0 ? 'Paid' : 'Update Value'),
        content: remaining == 0
            ? const SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'This order is already paid.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            : TextFormField(
                validator: (value) =>
                    TValidator.validateEmptyText('New Value', value),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
                maxLines: 1,
                controller: orderController.newPaidAmount,
                decoration: const InputDecoration(
                  hintText: 'Enter new value',
                  border: OutlineInputBorder(),
                ),
              ),
        actions: [
          Center(
            child: SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (remaining == 0) {
                    Navigator.of(context).pop(); // Just close dialog
                  } else {
                    final newValue = double.parse(orderController.newPaidAmount.text);
                    orderController.updateOrderPaidAmount(orderModel.orderId, newValue);
                    Navigator.of(context).pop(); // Close the dialog
                  }
                },
                icon: Icon(
                  remaining == 0 ? Icons.check_circle : Icons.update,
                  color: TColors.white,
                ),
                label: Text(remaining == 0 ? 'Got it' : 'Update'),
              ),
            ),
          ),
        ],
      );
    },
  );
},



                          backgroundColor: TColors.primary,
                          child: const Icon(Iconsax.edit,color: TColors.white,))
                    ],
                  ) : const SizedBox.shrink()),


            ],
          )
        ],
      ),
    );
  }
}
