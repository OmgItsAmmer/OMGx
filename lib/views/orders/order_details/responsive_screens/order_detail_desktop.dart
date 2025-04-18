import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/installments/table/installment_table.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/customer_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/oorder_transaction.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/orders/order_item_model.dart';
import '../../../../controllers/customer/customer_controller.dart';
import '../../../../controllers/salesman/salesman_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../widgets/guarrantor_card.dart';

class OrderDetailDesktopScreen extends StatelessWidget {
  const OrderDetailDesktopScreen({super.key, required this.orderModel});

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    SaleType? saleTypeFromOrder = SaleType.values.firstWhere(
          (e) => e.name == orderModel.saletype,
      orElse: () => SaleType.cash,
    );


    final CustomerController customerController =
    Get.find<CustomerController>();
    final SalesmanController salesmanController =
    Get.find<SalesmanController>();

    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          OrderInfo(orderModel: orderModel),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          OrderItems(order: orderModel),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          OrderTransaction(orderModel: orderModel),
                          const SizedBox(height: TSizes.spaceBtwSections),
                        ],
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwSections),
                    Expanded(
                      child: Column(
                        children: [
                          UserInfo(
                            mediaCategory: MediaCategory.customers,

                            title: 'Customer',
                            showAddress: true,
                            fullName:
                            customerController.selectedCustomer.value.fullName,
                            email:
                            customerController.selectedCustomer.value.email,
                            phoneNumber: customerController
                                .selectedCustomer.value.phoneNumber,
                            isLoading: customerController.isLoading.value,
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          UserInfo(
                            mediaCategory: MediaCategory.salesman,
                            title: 'Salesman',
                            showAddress: false,
                            fullName: salesmanController
                                .selectedSalesman?.value.fullName ??
                                'Not Found',
                            email: salesmanController
                                .selectedSalesman?.value.email ??
                                'Not Found',
                            phoneNumber: salesmanController
                                .selectedSalesman?.value.phoneNumber ??
                                'Not Found',
                            isLoading: salesmanController.isLoading.value,
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          if (saleTypeFromOrder == SaleType.installment) ...[
                            const GuarantorCard(
                                title: 'Guarantor 1', guarantorIndex: 0),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            const GuarantorCard(
                                title: 'Guarantor 2', guarantorIndex: 1),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (saleTypeFromOrder == SaleType.installment)
                const SizedBox(height: TSizes.spaceBtwSections),
                  TRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Installment Plans',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        const InstallmentTable(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}