import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../common/widgets/containers/rounded_container.dart';
import '../../../controllers/installments/installments_controller.dart';
import '../../../controllers/sales/sales_controller.dart';
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
    final saleItem = installmentController.installmentPlans[index];
    return DataRow2(
        onTap: () {
          TLoader.successSnackBar(title: index);
        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(Text(
            saleItem.sequenceNo.toString(), //Dummy
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.description == ''
                ? 'Installment No${saleItem.sequenceNo}'
                : saleItem.description,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.dueDate.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.paidDate.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.amountDue,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.paidAmount.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.remarks,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.remaining,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            saleItem.status.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(TTableActionButtons(
            view: false,
            edit: true,
            delete: false,
            onViewPressed: () {},
            onDeletePressed: () {},
            onEditPressed: () {

              Get.defaultDialog(
                title: 'Installment No ${saleItem.sequenceNo}',
                content: TRoundedContainer(
                  width: 400,
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: saleItem.status == 'paid'
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Paid',
                        style: Theme.of(Get.context!).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      ElevatedButton(
                        onPressed: () => Navigator.of(Get.context!).pop(),
                        child: Text(
                          'Got It',
                          style: Theme.of(Get.context!).textTheme.bodyMedium!.apply(color: TColors.white),
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
                            double paidAmount = double.tryParse(installmentController.paidAmount.value.text) ?? 0.0;
                            double amountDue = double.tryParse(saleItem.amountDue) ?? 0.0;

                            if (paidAmount > amountDue) {
                              installmentController.paidAmount.text = "0.0";
                              installmentController.remainingAmount.value.text = amountDue.toStringAsFixed(2);
                              TLoader.errorSnackBar(
                                title: "Invalid Payment",
                                message: "Paid amount cannot exceed the total amount.",
                              );
                            } else {
                              installmentController.remainingAmount.value.text = (amountDue - paidAmount).toStringAsFixed(2);
                            }
                          } catch (e) {
                            print("Error parsing double: $e");
                            installmentController.remainingAmount.value.text = "0.00";
                          }
                        },
                        controller: installmentController.paidAmount,
                        validator: (value) => TValidator.validateEmptyText('Paid Amount', value),
                        decoration: const InputDecoration(labelText: 'Paid Amount'),
                        style: Theme.of(Get.context!).textTheme.bodyMedium,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Obx(
                            () => TextFormField(
                          readOnly: true,
                          controller: installmentController.remainingAmount.value,
                          validator: (value) => TValidator.validateEmptyText('Remaining Amount', value),
                          decoration: const InputDecoration(labelText: 'Remaining Amount'),
                          style: Theme.of(Get.context!).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Row(
                        children: [
                          Expanded(
                              flex: TDeviceUtils.isDesktopScreen(Get.context!) ? 2 : 0,
                              child: SizedBox()),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(Get.context!).pop(),
                              child: Text(
                                'Cancel',
                                style: Theme.of(Get.context!).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          const SizedBox(width: TSizes.spaceBtwInputFields),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle payment confirmation logic
                                installmentController.updateInstallmentPlan(saleItem.sequenceNo,saleItem.planId);
                                Navigator.of(Get.context!).pop();
                              },
                              child: Text(
                                'Confirm',
                                style: Theme.of(Get.context!).textTheme.bodyMedium!.apply(color: TColors.white),
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
