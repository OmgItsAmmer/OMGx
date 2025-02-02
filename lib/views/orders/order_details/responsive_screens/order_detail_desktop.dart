import 'package:admin_dashboard_v3/Models/orders/order_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/installments/table/installment_table.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/customer_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/oorder_transaction.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../Models/orders/order_item_model.dart';
import '../../../../controllers/installments/installments_controller.dart';

class OrderDetailDesktopScreen extends StatelessWidget {
  const OrderDetailDesktopScreen({super.key, required this.orderModel});

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
 //   OrderModel order = OrderModel.empty();
    final InstallmentController installmentController = Get.find<InstallmentController>();

    return  Expanded(
      child: SizedBox(
        //height: 1000,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Bread Crumbs
                //Sizedbox
                //Body
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            //Order Info
                               OrderInfo(orderModel: orderModel ,),
                            const SizedBox(
                              height: TSizes.spaceBtwSections,
                            ),
      
                            //Items
                            OrderItems(order: orderModel),
                            const SizedBox(
                              height: TSizes.spaceBtwSections,
                            ),
                            //Installment table
                            OrderTransaction(orderModel: orderModel,),
                           
                            const SizedBox(height: TSizes.spaceBtwSections,),

                            //Transactions
                          ],
                        )),
                    const SizedBox(
                      width: TSizes.spaceBtwSections,
                    ),
                    // Right Side Order Orders
                    const Expanded(
                        child: Column(
                      children: [
                        //Customer Info
                        CustomerInfo(),
                        SizedBox(
                          height: TSizes.spaceBtwSections,
                        )
                      ],
                    ))
                  ],
                ),
                  Obx(
                    () {
                      if(installmentController.installmentPlans.isNotEmpty)
                      {
                        return TRoundedContainer(

                          // height: 600,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start ,
                              children: [
                                Text('Installment Plans',style: Theme.of(context).textTheme.headlineMedium,),
                                const SizedBox(height: TSizes.spaceBtwSections,),
                                const InstallmentTable(),
                              ],
                            ));
                      }
                      else {
                        return SizedBox();
                      }

                    }
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
