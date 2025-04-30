import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstallmentRefundReport extends StatelessWidget {
  const InstallmentRefundReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final installmentController = Get.find<InstallmentController>();

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
              Text(
                'Refund Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: TSizes.sm),

              // Row of toggle switches
              Wrap(
                spacing: TSizes.lg,
                runSpacing: TSizes.sm,
                children: [
                  _buildToggleOption(
                    context,
                    'Include Advance Payment',
                    installmentController.includeAdvancePaymentInRefund,
                    (value) => installmentController.toggleRefundOption(
                        'advance', value),
                  ),
                  _buildToggleOption(
                    context,
                    'Include Shipping',
                    installmentController.includeShippingInRefund,
                    (value) => installmentController.toggleRefundOption(
                        'shipping', value),
                  ),
                  _buildToggleOption(
                    context,
                    'Include Tax',
                    installmentController.includeTaxInRefund,
                    (value) =>
                        installmentController.toggleRefundOption('tax', value),
                  ),
                  _buildToggleOption(
                    context,
                    'Include Doc. Charges',
                    installmentController.includeDocumentChargesInRefund,
                    (value) => installmentController.toggleRefundOption(
                        'document', value),
                  ),
                  _buildToggleOption(
                    context,
                    'Include Other Charges',
                    installmentController.includeOtherChargesInRefund,
                    (value) => installmentController.toggleRefundOption(
                        'other', value),
                  ),
                  _buildToggleOption(
                    context,
                    'Include Commission',
                    installmentController.includeSalesmanCommissionInRefund,
                    (value) => installmentController.toggleRefundOption(
                        'commission', value),
                  ),
                  _buildToggleOption(
                    context,
                    'Include Margin',
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
                  RefundDetailRow(
                    title: 'Total Order Amount',
                    amount:
                        'Rs. ${installmentController.totalOrderAmount.value.toStringAsFixed(2)}',
                  ),
                  const Divider(),

                  // Always show payment breakdown
                  Text(
                    'Payment Details:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: TSizes.xs),

                  RefundDetailRow(
                    title: 'Advance/Down Payment',
                    amount:
                        'Rs. ${installmentController.advancePaymentAmount.value.toStringAsFixed(2)}',
                    color: Colors.blue,
                  ),
                  RefundDetailRow(
                    title: 'Installment Payments',
                    amount:
                        'Rs. ${installmentController.installmentsPaidAmount.value.toStringAsFixed(2)}',
                    color: Colors.blue,
                  ),
                  RefundDetailRow(
                    title: 'Total Paid by Customer',
                    amount:
                        'Rs. ${installmentController.totalPaidAmount.value.toStringAsFixed(2)}',
                    color: Colors.green,
                    isBold: true,
                  ),
                  const Divider(),

                  // Additional charges and components section
                  Text(
                    'Order Components:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: TSizes.xs),

                  // Document charges info
                  if (installmentController.documentChargesAmount.value > 0)
                    RefundDetailRow(
                      title: 'Document Charges',
                      amount:
                          'Rs. ${installmentController.documentChargesAmount.value.toStringAsFixed(2)}',
                      color: Colors.grey.shade700,
                    ),

                  // Other charges info
                  if (installmentController.otherChargesAmount.value > 0)
                    RefundDetailRow(
                      title: 'Other Charges',
                      amount:
                          'Rs. ${installmentController.otherChargesAmount.value.toStringAsFixed(2)}',
                      color: Colors.grey.shade700,
                    ),

                  // Margin info
                  if (installmentController.marginAmount.value > 0)
                    RefundDetailRow(
                      title: 'Margin Amount',
                      amount:
                          'Rs. ${installmentController.marginAmount.value.toStringAsFixed(2)}',
                      color: Colors.grey.shade700,
                    ),

                  // Show salesman commission info
                  if (installmentController.salesmanCommissionAmount.value > 0)
                    RefundDetailRow(
                      title: 'Salesman Commission',
                      amount:
                          'Rs. ${installmentController.salesmanCommissionAmount.value.toStringAsFixed(2)}',
                      color: Colors.grey.shade700,
                    ),

                  // Shipping info
                  if (installmentController.shippingAmount.value > 0)
                    RefundDetailRow(
                      title: 'Shipping',
                      amount:
                          'Rs. ${installmentController.shippingAmount.value.toStringAsFixed(2)}',
                      color: Colors.grey.shade700,
                    ),

                  // Tax info
                  if (installmentController.taxAmount.value > 0)
                    RefundDetailRow(
                      title: 'Tax',
                      amount:
                          'Rs. ${installmentController.taxAmount.value.toStringAsFixed(2)}',
                      color: Colors.grey.shade700,
                    ),

                  const Divider(),

                  // Additions to refund section header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                    child: Text(
                      'Additions to Refund:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),

                  // Conditionally show installment payments (always included)
                  if (installmentController.installmentsPaidAmount.value > 0)
                    RefundDetailRow(
                      title: 'Installment Payments (to refund)',
                      amount:
                          'Rs. ${installmentController.installmentsPaidAmount.value.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),

                  // Conditionally show advance payment if toggled
                  if (installmentController.includeAdvancePaymentInRefund.value)
                    RefundDetailRow(
                      title: 'Advance Payment (to refund)',
                      amount:
                          'Rs. ${installmentController.advancePaymentAmount.value.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),

                  // Conditionally show shipping if included
                  if (installmentController.includeShippingInRefund.value)
                    RefundDetailRow(
                      title: 'Shipping Charges (to refund)',
                      amount:
                          'Rs. ${installmentController.shippingAmount.value.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),

                  // Conditionally show tax if included
                  if (installmentController.includeTaxInRefund.value)
                    RefundDetailRow(
                      title: 'Tax Amount (to refund)',
                      amount:
                          'Rs. ${installmentController.taxAmount.value.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),

                  // Document charges
                  if (installmentController
                      .includeDocumentChargesInRefund.value)
                    RefundDetailRow(
                      title: 'Document Charges (to refund)',
                      amount:
                          'Rs. ${installmentController.documentChargesAmount.value.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),

                  // Other charges
                  if (installmentController.includeOtherChargesInRefund.value)
                    RefundDetailRow(
                      title: 'Other Charges (to refund)',
                      amount:
                          'Rs. ${installmentController.otherChargesAmount.value.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),

                  // Margin amount
                  if (installmentController.includeMarginInRefund.value)
                    RefundDetailRow(
                      title: 'Margin Amount (to refund)',
                      amount:
                          'Rs. ${installmentController.marginAmount.value.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),

                  // Salesman commission
                  if (installmentController
                      .includeSalesmanCommissionInRefund.value)
                    RefundDetailRow(
                      title: 'Salesman Commission (to refund)',
                      amount:
                          'Rs. ${installmentController.salesmanCommissionAmount.value.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),

                  const Divider(),
                  RefundDetailRow(
                    title: 'Total Refund Amount',
                    amount:
                        'Rs. ${installmentController.refundAmount.value.toStringAsFixed(2)}',
                    color: Colors.red,
                    isBold: true,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const Text(
                    'Note: Refund amounts are calculated based on payments received and may be subject to store policy.',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                ],
              ),
            )),
        const SizedBox(height: TSizes.spaceBtwSections),
        Obx(() => ElevatedButton.icon(
              onPressed: installmentController.isProcessingRefund.value
                  ? null
                  : () => installmentController.processRefund(),
              icon: installmentController.isProcessingRefund.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.payments_outlined),
              label: Text(installmentController.isProcessingRefund.value
                  ? 'Processing...'
                  : 'Process Refund'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
            )),
      ],
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
        borderRadius: BorderRadius.circular(10),
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
        horizontal: TSizes.sm,
        vertical: TSizes.xs,
      ),
      child: GetBuilder<InstallmentController>(
        builder: (controller) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 8),
            Switch(
              value: toggleValue.value,
              onChanged: (val) {
                toggleValue.value = val; // Update local value first
                onChanged(val); // Then call controller method
              },
              activeColor: TColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class RefundDetailRow extends StatelessWidget {
  final String title;
  final String amount;
  final Color? color;
  final bool isBold;

  const RefundDetailRow({
    Key? key,
    required this.title,
    required this.amount,
    this.color,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
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
