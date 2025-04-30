import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/installments/refund/installment_refund_report.dart';
import 'package:admin_dashboard_v3/views/installments/table/installment_table.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/customer_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/oorder_transaction.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_info.dart';
import 'package:admin_dashboard_v3/views/orders/order_details/widgets/order_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/orders/order_item_model.dart';
import '../../../../controllers/customer/customer_controller.dart';
import '../../../../controllers/guarantors/guarantor_controller.dart';
import '../../../../controllers/salesman/salesman_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../widgets/guarrantor_card.dart';

class OrderDetailTabletScreen extends StatelessWidget {
  const OrderDetailTabletScreen({super.key, required this.orderModel});

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    SaleType? saleTypeFromOrder = SaleType.values.firstWhere(
      (e) => e.name == orderModel.saletype,
      orElse: () => SaleType.cash,
    );

    final OrderController orderController = Get.find<OrderController>();
    final InstallmentController installmentController =
        Get.find<InstallmentController>();
    final CustomerController customerController =
        Get.find<CustomerController>();
    final SalesmanController salesmanController =
        Get.find<SalesmanController>();
    final GuarantorController guarantorController =
        Get.find<GuarantorController>();

    if (saleTypeFromOrder == SaleType.installment) {
      guarantorController.fetchGuarantors(orderModel.orderId);
    }

    // Listen for status changes to initialize refund data when order is cancelled
    ever(orderController.selectedStatus, (status) {
      if (status == OrderStatus.cancelled &&
          saleTypeFromOrder == SaleType.installment) {
        installmentController.initializeRefundData(orderModel);
      } else {
        installmentController.shouldShowRefundReport.value = false;
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Information Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Order info and items
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      OrderInfo(orderModel: orderModel),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      OrderItems(order: orderModel),
                    ],
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                // Right column - Customer and Salesman info
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      UserInfo(
                        mediaCategory: MediaCategory.customers,
                        title: 'Customer',
                        showAddress: true,
                        fullName:
                            customerController.selectedCustomer.value.fullName,
                        email: customerController.selectedCustomer.value.email,
                        phoneNumber: customerController
                            .selectedCustomer.value.phoneNumber,
                        isLoading: customerController.isLoading.value,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      UserInfo(
                        mediaCategory: MediaCategory.salesman,
                        title: 'Salesman',
                        showAddress: false,
                        fullName: salesmanController
                                .selectedSalesman?.value.fullName ??
                            'Not Found',
                        email:
                            salesmanController.selectedSalesman?.value.email ??
                                'Not Found',
                        phoneNumber: salesmanController
                                .selectedSalesman?.value.phoneNumber ??
                            'Not Found',
                        isLoading: salesmanController.isLoading.value,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Transaction Section
            OrderTransaction(orderModel: orderModel),

            // Guarantor Section (if installment)
            if (saleTypeFromOrder == SaleType.installment) ...[
              const SizedBox(height: TSizes.spaceBtwSections),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: const [
                        GuarantorCard(title: 'Guarantor 1', guarantorIndex: 0),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Column(
                      children: const [
                        GuarantorCard(title: 'Guarantor 2', guarantorIndex: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            // Installment Section (if installment)
            if (saleTypeFromOrder == SaleType.installment) ...[
              const SizedBox(height: TSizes.spaceBtwSections),
              TRoundedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final isCancelled =
                          orderController.selectedStatus.value ==
                              OrderStatus.cancelled;
                      return Text(
                        isCancelled ? 'Payment Refund' : 'Installment Plans',
                        style: Theme.of(context).textTheme.headlineMedium,
                      );
                    }),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Obx(() {
                      if (installmentController.shouldShowRefundReport.value) {
                        return const InstallmentRefundReport();
                      } else {
                        return const InstallmentTable();
                      }
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
