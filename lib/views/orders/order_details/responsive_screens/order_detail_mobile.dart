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

class OrderDetailMobileScreen extends StatelessWidget {
  const OrderDetailMobileScreen({super.key, required this.orderModel});

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
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info with a custom wrapper for mobile
            Theme(
              // Override theme for the order info section to fix status dropdown
              data: Theme.of(context).copyWith(
                dropdownMenuTheme: DropdownMenuThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    constraints: const BoxConstraints(
                      maxWidth: 120, // Constrain width for mobile
                    ),
                  ),
                ),
              ),
              child: OrderInfo(orderModel: orderModel),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Order Items with custom scaling for mobile
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  // Use a fixed width container for horizontal scrolling
                  width: MediaQuery.of(context).size.width * 1.2,
                  child: OrderItems(order: orderModel),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Transaction Info
            OrderTransaction(orderModel: orderModel),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Customer Info
            UserInfo(
              mediaCategory: MediaCategory.customers,
              title: 'Customer',
              showAddress: true,
              fullName: customerController.selectedCustomer.value.fullName,
              email: customerController.selectedCustomer.value.email,
              phoneNumber:
                  customerController.selectedCustomer.value.phoneNumber,
              isLoading: customerController.isLoading.value,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Salesman Info
            UserInfo(
              mediaCategory: MediaCategory.salesman,
              title: 'Salesman',
              showAddress: false,
              fullName: salesmanController.selectedSalesman?.value.fullName ??
                  'Not Found',
              email: salesmanController.selectedSalesman?.value.email ??
                  'Not Found',
              phoneNumber:
                  salesmanController.selectedSalesman?.value.phoneNumber ??
                      'Not Found',
              isLoading: salesmanController.isLoading.value,
            ),

            // Guarantor Info (if installment)
            if (saleTypeFromOrder == SaleType.installment) ...[
              const SizedBox(height: TSizes.spaceBtwSections),
              const GuarantorCard(title: 'Guarantor 1', guarantorIndex: 0),
              const SizedBox(height: TSizes.spaceBtwItems),
              const GuarantorCard(title: 'Guarantor 2', guarantorIndex: 1),
            ],

            // Installment Plans (if installment)
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
                    const SizedBox(height: TSizes.spaceBtwItems),
                    // Add horizontal scrolling for refund report to prevent overflow
                    Obx(() {
                      if (installmentController.shouldShowRefundReport.value) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            // Make refund report wider than screen width to enable horizontal scrolling
                            width: MediaQuery.of(context).size.width * 1.2,
                            child: const InstallmentRefundReport(),
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            // Set fixed width to allow scrolling
                            width: MediaQuery.of(context).size.width * 1.2,
                            child: const InstallmentTable(),
                          ),
                        );
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
