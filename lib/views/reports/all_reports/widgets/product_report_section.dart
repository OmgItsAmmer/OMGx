import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Models/installments/installment_table_model/installment_table_model.dart';
import '../../../../common/widgets/cards/hover_able_card.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../controllers/report/report_controller.dart';
import '../../../../utils/constants/sizes.dart';
import '../../specific_reports/installment_plans/installment_plan_report.dart';

class ProductReportSection extends StatelessWidget {
  const ProductReportSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReportController reportController = Get.find<ReportController>();
    final ProductController productController = Get.find<ProductController>();
    final OrderController orderController = Get.find<OrderController>();
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          Wrap(
            spacing: TSizes.spaceBtwItems, // Horizontal space between items
            runSpacing: TSizes.spaceBtwItems, // Vertical space between rows
            children: [
              HoverableCard(
                text: 'Stock Summary Report',
                animation: TImages.docerAnimation,
                onPressed: () {
                  reportController.getStockSummaryReport();

                },
              ),
              HoverableCard(
                text: 'Stock Summary Report',
                animation: TImages.docerAnimation,
                onPressed: () {
                  reportController.showDateRangePickerDialogPnL(context);

                },
              ),
              // HoverableCard(
              //   text: 'Product Profitability Report',
              //   animation:
              //       TImages.docerAnimation, // Replace with your animation
              //   onPressed: () {
              //     // Open a dialog when the card is pressed
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           title: const Text('Product Profitability Report'),
              //           content:  Column(
              //             mainAxisSize: MainAxisSize
              //                 .min, // Ensure the column doesn't expand
              //             children: [
              //               SizedBox(
              //                 width: 300,
              //                 //  height: 60,
              //                 child: AutoCompleteTextField(
              //                   titleText: 'Product Name',
              //                   optionList: productController.productNames,
              //                   textController: reportController.selectedProduct ,
              //                   parameterFunc: (val){
              //
              //                   },
              //                 ),
              //               ),
              //               const SizedBox(height: TSizes.spaceBtwSections,),
              //               SizedBox(
              //                 width: 300,
              //                 height: 300,
              //                 child: SfDateRangePicker(
              //                   rangeSelectionColor: TColors.primary.withValues(alpha: 0.4),
              //                   selectionMode: DateRangePickerSelectionMode.range,
              //                   //rangeTextStyle: ,
              //                   endRangeSelectionColor: TColors.primary,
              //                   startRangeSelectionColor:TColors.primary ,
              //                   onSelectionChanged: (val) {
              //                    // print(val);
              //                     reportController.startDate = val.value.startDate;
              //                     reportController.endDate = val.value.endDate;
              //
              //
              //
              //                   },
              //
              //                 ),
              //               ),
              //
              //             ],
              //
              //           ),
              //           actions: [
              //             TextButton(
              //               onPressed: () async {
              //                 // Find the product ID using the product name
              //                 int productId = productController.findProductIdByName(reportController.selectedProduct.text) ?? -1;
              //
              //                 // Get the list of order IDs from the product ID
              //                 final orderIds = await orderController.getOrderIdsByProductIdService(productId);
              //
              //                 // Filter out the orders from allOrders using the retrieved order IDs
              //                 List<OrderModel> filteredOrders = orderController.allOrders
              //                     .where((order) => orderIds.contains(order.orderId))
              //                     .toList();
              //
              //                 // filter them on the basis of aate
              //               },
              //
              //               child: const Text('Confirm'),
              //             ), TextButton(
              //               onPressed: () {
              //                 Navigator.of(context).pop(); // Close the dialog
              //               },
              //               child: const Text('Close'),
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   },
              // ),
              // HoverableCard(
              //   text: 'Stock Movement Report',
              //   animation: TImages.docerAnimation,
              //   onPressed: () {
              //     Get.to(() => InstallmentReportPage(
              //           installmentPlans: [InstallmentTableModel.empty()],
              //           cashierName: 'Ammer',
              //           companyName: 'OMGz',
              //           branchName: 'MAIN',
              //         ));
              //   },
              // ),
              // HoverableCard(
              //   text: 'Top Selling Products Report',
              //   animation: TImages.docerAnimation,
              //   onPressed: () {
              //     Get.to(() => InstallmentReportPage(
              //           installmentPlans: [InstallmentTableModel.empty()],
              //           cashierName: 'Ammer',
              //           companyName: 'OMGz',
              //           branchName: 'MAIN',
              //         ));
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
