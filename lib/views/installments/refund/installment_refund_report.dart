import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstallmentRefundReport extends StatelessWidget {
  const InstallmentRefundReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final installmentController = Get.find<InstallmentController>();

    return Obx(() {
      // Check if data is available
      final bool hasData = installmentController
                  .currentInstallmentPlan.value.installmentPlanId !=
              null &&
          installmentController.totalPaidAmount.value > 0;

      // Check if we're loading data
      final bool isLoading = installmentController.isLoading.value;

      if (isLoading) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading refund data...'),
            ],
          ),
        );
      }

      if (!hasData) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No refund data available',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Try to reload the data, but don't depend on specific controller structure
                  installmentController.isLoading.value = true;
                  // Force a UI refresh which will trigger data reload
                  installmentController.shouldShowRefundReport.value = false;
                  // Then show it again after a short delay
                  Future.delayed(const Duration(milliseconds: 300), () {
                    installmentController.shouldShowRefundReport.value = true;
                    installmentController.isLoading.value = false;
                  });
                },
                child: const Text('Reload Data'),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Refund Summary',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Toggle switches for refund options
          Padding(
            padding: const EdgeInsets.all(TSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Refund Options',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: TSizes.md),
                    Text(
                      '(Toggle items to include in refund)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.sm),

                // Row of toggle switches
                Wrap(
                  spacing: TSizes.md,
                  runSpacing: TSizes.xs,
                  children: [
                    _buildToggleOption(
                      context,
                      'Advance Payment',
                      installmentController.includeAdvancePaymentInRefund,
                      (value) => installmentController.toggleRefundOption(
                          'advance', value),
                    ),
                    _buildToggleOption(
                      context,
                      'Shipping',
                      installmentController.includeShippingInRefund,
                      (value) => installmentController.toggleRefundOption(
                          'shipping', value),
                    ),
                    _buildToggleOption(
                      context,
                      'Tax',
                      installmentController.includeTaxInRefund,
                      (value) => installmentController.toggleRefundOption(
                          'tax', value),
                    ),
                    _buildToggleOption(
                      context,
                      'Doc. Charges',
                      installmentController.includeDocumentChargesInRefund,
                      (value) => installmentController.toggleRefundOption(
                          'document', value),
                    ),
                    _buildToggleOption(
                      context,
                      'Other Charges',
                      installmentController.includeOtherChargesInRefund,
                      (value) => installmentController.toggleRefundOption(
                          'other', value),
                    ),
                    _buildToggleOption(
                      context,
                      'Commission',
                      installmentController.includeSalesmanCommissionInRefund,
                      (value) => installmentController.toggleRefundOption(
                          'commission', value),
                    ),
                    _buildToggleOption(
                      context,
                      'Margin',
                      installmentController.includeMarginInRefund,
                      (value) => installmentController.toggleRefundOption(
                          'margin', value),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwItems),
          Obx(() => TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: TColors.primary.withOpacity(0.1),
                child: Column(
                  children: [
                    // Order total
                    RefundDetailRow(
                      title: 'Total Order Amount',
                      amount:
                          'Rs. ${installmentController.totalOrderAmount.value.toStringAsFixed(2)}',
                      color: Colors.black87,
                      isBold: true,
                    ),
                    const Divider(),

                    // Payment details
                    Text(
                      'Payment Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: TSizes.xs),

                    // Always show installment payments
                    RefundDetailRow(
                      title: 'Installments Paid',
                      amount:
                          'Rs. ${installmentController.installmentsPaidAmount.value.toStringAsFixed(2)}',
                      color: Colors.blue,
                      isIncluded: true,
                      includedText: 'Always included in refund',
                    ),

                    // Advance payment - color will change based on inclusion
                    RefundDetailRow(
                      title: 'Advance/Down Payment',
                      amount:
                          'Rs. ${installmentController.advancePaymentAmount.value.toStringAsFixed(2)}',
                      color: installmentController
                              .includeAdvancePaymentInRefund.value
                          ? Colors.green
                          : Colors.grey,
                      isIncluded: installmentController
                          .includeAdvancePaymentInRefund.value,
                    ),

                    RefundDetailRow(
                      title: 'Total Paid by Customer',
                      amount:
                          'Rs. ${installmentController.totalPaidAmount.value.toStringAsFixed(2)}',
                      color: Colors.black,
                      isBold: true,
                    ),
                    const Divider(),

                    // Order components and charges
                    Text(
                      'Order Components',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: TSizes.xs),
                    const Text(
                      'Items in green are included in refund calculation',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: TSizes.xs),
                    const Text(
                      'Note: Document charges, other charges and margin are already included in installment payments',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: Colors.orange),
                    ),
                    const SizedBox(height: TSizes.sm),

                    // Document charges - shown once, colored based on inclusion
                    if (installmentController.documentChargesAmount.value > 0)
                      RefundDetailRow(
                        title: 'Document Charges',
                        amount:
                            'Rs. ${installmentController.documentChargesAmount.value.toStringAsFixed(2)}',
                        color: installmentController
                                .includeDocumentChargesInRefund.value
                            ? Colors.green
                            : Colors.grey,
                        isIncluded: installmentController
                            .includeDocumentChargesInRefund.value,
                      ),

                    // Other charges - shown once, colored based on inclusion
                    if (installmentController.otherChargesAmount.value > 0)
                      RefundDetailRow(
                        title: 'Other Charges',
                        amount:
                            'Rs. ${installmentController.otherChargesAmount.value.toStringAsFixed(2)}',
                        color: installmentController
                                .includeOtherChargesInRefund.value
                            ? Colors.green
                            : Colors.grey,
                        isIncluded: installmentController
                            .includeOtherChargesInRefund.value,
                      ),

                    // Margin - shown once, colored based on inclusion
                    if (installmentController.marginAmount.value > 0)
                      RefundDetailRow(
                        title: 'Margin Amount',
                        amount:
                            'Rs. ${installmentController.marginAmount.value.toStringAsFixed(2)}',
                        color: installmentController.includeMarginInRefund.value
                            ? Colors.green
                            : Colors.grey,
                        isIncluded:
                            installmentController.includeMarginInRefund.value,
                      ),

                    // Commission - shown once, colored based on inclusion
                    if (installmentController.salesmanCommissionAmount.value >
                        0)
                      RefundDetailRow(
                        title: 'Salesman Commission',
                        amount:
                            'Rs. ${installmentController.salesmanCommissionAmount.value.toStringAsFixed(2)}',
                        color: installmentController
                                .includeSalesmanCommissionInRefund.value
                            ? Colors.green
                            : Colors.grey,
                        isIncluded: installmentController
                            .includeSalesmanCommissionInRefund.value,
                      ),

                    // Shipping - shown once, colored based on inclusion
                    if (installmentController.shippingAmount.value > 0)
                      RefundDetailRow(
                        title: 'Shipping Charges',
                        amount:
                            'Rs. ${installmentController.shippingAmount.value.toStringAsFixed(2)}',
                        color:
                            installmentController.includeShippingInRefund.value
                                ? Colors.green
                                : Colors.grey,
                        isIncluded:
                            installmentController.includeShippingInRefund.value,
                      ),

                    // Tax - shown once, colored based on inclusion
                    if (installmentController.taxAmount.value > 0)
                      RefundDetailRow(
                        title: 'Tax Amount',
                        amount:
                            'Rs. ${installmentController.taxAmount.value.toStringAsFixed(2)}',
                        color: installmentController.includeTaxInRefund.value
                            ? Colors.green
                            : Colors.grey,
                        isIncluded:
                            installmentController.includeTaxInRefund.value,
                      ),

                    const Divider(),

                    // Total refund amount
                    RefundDetailRow(
                      title: 'Total Refund Amount',
                      amount:
                          'Rs. ${installmentController.refundAmount.value.toStringAsFixed(2)}',
                      color: Colors.red,
                      isBold: true,
                    ),
                    const SizedBox(height: TSizes.xs),
                    const Text(
                      'Note: Refund amounts are based on payments received and store policy.',
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                  ],
                ),
              )),
          // const SizedBox(height: TSizes.spaceBtwSections),
          // Obx(() => ElevatedButton.icon(
          //       onPressed: installmentController.isProcessingRefund.value
          //           ? null
          //           : () => installmentController.processRefund(),
          //       icon: installmentController.isProcessingRefund.value
          //           ? const SizedBox(
          //               width: 20,
          //               height: 20,
          //               child: CircularProgressIndicator(
          //                 strokeWidth: 2,
          //                 valueColor:
          //                     AlwaysStoppedAnimation<Color>(Colors.white),
          //               ),
          //             )
          //           : const Icon(Icons.payments_outlined),
          //       label: Text(installmentController.isProcessingRefund.value
          //           ? 'Processing...'
          //           : 'Process Refund'),
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: TColors.primary,
          //         foregroundColor: Colors.white,
          //         minimumSize: const Size(200, 50),
          //       ),
          //     )),
        ],
      );
    }

    );
  }

  Widget _buildToggleOption(
    BuildContext context,
    String label,
    RxBool toggleValue,
    Function(bool) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.xs,
        vertical: TSizes.xs,
      ),
      child: Obx(() => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 4),
              Switch(
                value: toggleValue.value,
                onChanged: onChanged,
                activeColor: TColors.primary,
              ),
            ],
          )),
    );
  }
}

class RefundDetailRow extends StatelessWidget {
  final String title;
  final String amount;
  final Color? color;
  final bool isBold;
  final bool isIncluded;
  final String? includedText;

  const RefundDetailRow({
    Key? key,
    required this.title,
    required this.amount,
    this.color,
    this.isBold = false,
    this.isIncluded = false,
    this.includedText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    color: color,
                  ),
                ),
                if (isIncluded && includedText == null)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child:
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                  ),
                if (includedText != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      includedText!,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 11,
                          color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
