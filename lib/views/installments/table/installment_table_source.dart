import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../common/widgets/containers/rounded_container.dart';
import '../../../controllers/installments/installments_controller.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/validators/validation.dart';

class InstallmentRow extends DataTableSource {
  final InstallmentController installmentController =
      Get.find<InstallmentController>();

  InstallmentRow({required this.installmentCount});
  final installmentCount;

  @override
  DataRow? getRow(int index) {
    final installmentItem =
        installmentController.currentInstallmentPayments[index];
    final dateFormat = DateFormat('dd/MM/yyyy');

    return DataRow2(
        onTap: () {},
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(Text(
            installmentItem.sequenceNo.toString(), //Dummy
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            installmentItem.description == ''
                ? 'Installment# ${installmentItem.sequenceNo}'
                : installmentItem.description,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            dateFormat.format(DateTime.parse(installmentItem.dueDate)),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            installmentItem.paidDate == 'null' ||
                    installmentItem.paidDate == null
                ? '--'
                : dateFormat
                    .format(DateTime.parse(installmentItem.paidDate ?? '--')),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            installmentItem.amountDue,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            installmentItem.paidAmount.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            installmentItem.remarks,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          // DataCell(Text(
          //   installmentItem.remaining,
          //   style: Theme.of(Get.context!)
          //       .textTheme
          //       .bodyLarge!
          //       .apply(color: TColors.primary),
          // )),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: installmentController
                  .getStatusColor(installmentItem.status ?? ''),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              installmentItem.status?.toString() ?? 'unknown',
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.white),
            ),
          )),
          DataCell(TTableActionButtons(
            view: false,
            edit: installmentItem.status?.toLowerCase() != 'completed',
            delete: false,
            onViewPressed: () {},
            onDeletePressed: () {},
            onEditPressed: () {
              // Set initial remaining amount when dialog opens
              installmentController.remainingAmount.value.text =
                  installmentItem.amountDue;

              Get.defaultDialog(
                title: 'Installment No ${installmentItem.sequenceNo}',
                content: TRoundedContainer(
                  width: 400,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: installmentItem.status ==
                          InstallmentStatus.paid.toString().split('.').last
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Paid',
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            ElevatedButton(
                              onPressed: () => Navigator.of(Get.context!).pop(),
                              child: Text(
                                'Got It',
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(color: TColors.white),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                try {
                                  double paidAmount =
                                      double.tryParse(value) ?? 0.0;
                                  double amountDue = double.tryParse(
                                          installmentItem.amountDue) ??
                                      0.0;

                                  if (paidAmount > amountDue) {
                                    installmentController.paidAmount.text =
                                        "0.0";
                                    installmentController.remainingAmount.value
                                        .text = amountDue.toStringAsFixed(2);
                                    TLoaders.errorSnackBar(
                                      title: "Invalid Payment",
                                      message:
                                          "Paid amount cannot exceed the total amount.",
                                    );
                                  } else {
                                    installmentController
                                            .remainingAmount.value.text =
                                        (amountDue - paidAmount)
                                            .toStringAsFixed(2);
                                  }
                                } catch (e) {
                                  if (kDebugMode) {
                                    print("Error parsing double: $e");
                                  }
                                  installmentController
                                      .remainingAmount.value.text = "0.00";
                                }
                              },
                              controller: installmentController.paidAmount,
                              validator: (value) =>
                                  TValidator.validateEmptyText(
                                      'Paid Amount', value),
                              decoration: const InputDecoration(
                                  labelText: 'Paid Amount'),
                              style:
                                  Theme.of(Get.context!).textTheme.bodyMedium,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            Obx(
                              () => TextFormField(
                                readOnly: true,
                                controller:
                                    installmentController.remainingAmount.value,
                                validator: (value) =>
                                    TValidator.validateEmptyText(
                                        'Remaining Amount', value),
                                decoration: const InputDecoration(
                                    labelText: 'Remaining Amount'),
                                style:
                                    Theme.of(Get.context!).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            Row(
                              children: [
                                Expanded(
                                    flex: TDeviceUtils.isDesktopScreen(
                                            Get.context!)
                                        ? 2
                                        : 0,
                                    child: const SizedBox()),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(Get.context!).pop(),
                                    child: Text(
                                      'Cancel',
                                      style: Theme.of(Get.context!)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: TSizes.spaceBtwInputFields),
                                Expanded(
                                  child: Obx(
                                    () => ElevatedButton(
                                      onPressed: installmentController
                                              .isUpdating.value
                                          ? null
                                          : () async {
                                              await installmentController
                                                  .updateInstallmentPayments(
                                                      installmentItem
                                                          .sequenceNo,
                                                      installmentItem.planId);
                                              installmentController
                                                  .resetFormFields();
                                              Navigator.of(Get.context!).pop();
                                            },
                                      child: installmentController
                                              .isUpdating.value
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(TColors.white),
                                              ),
                                            )
                                          : Text(
                                              'Confirm',
                                              style: Theme.of(Get.context!)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .apply(color: TColors.white),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              );
            },
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => installmentCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
