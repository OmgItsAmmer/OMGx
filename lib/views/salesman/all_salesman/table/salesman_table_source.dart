import 'package:admin_dashboard_v3/Models/salesman/salesman_model.dart';
import 'package:admin_dashboard_v3/Models/salesman/salesman_model.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../controllers/address/address_controller.dart';
import '../../../../controllers/orders/orders_controller.dart';
import '../../../../utils/constants/enums.dart';

class SalesmanRow extends DataTableSource {
  SalesmanRow({required this.itemCount, required this.filteredSalesmen});

  final int itemCount;
  final List<SalesmanModel> filteredSalesmen;
  final AddressController addressController = Get.find<AddressController>();
  final OrderController orderController = Get.find<OrderController>();
  // final ProductImagesController productImagesController = Get.find<ProductImagesController>();
  final SalesmanController salesmanController = Get.find<SalesmanController>();

  @override
  DataRow? getRow(int index) {
    final SalesmanModel salesman = filteredSalesmen[index];
    return DataRow2(
        onTap: () async {
          await addressController.fetchEntityAddresses(
              salesman.salesmanId!, EntityType.salesman);
          await orderController.fetchEntityOrders(
              salesman.salesmanId!, EntityType.salesman);
          orderController.setRecentOrderDay();
          // orderController.setAverageTotalAmount();
          //  productImagesController.setDesiredImage(MediaCategory.salesman, salesman.salesmanId);
          Get.toNamed(TRoutes.salesmanDetails, arguments: salesman);
        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(Row(
            children: [
              Text(
                salesman.fullName.toString(),
                style: Theme.of(Get.context!)
                    .textTheme
                    .bodyLarge!
                    .apply(color: TColors.primary),
              ),
              // const SizedBox(width: TSizes.spaceBtwInputFields/2,),
              // const TRoundedImage(
              //   width: 50,
              //   height: 50,
              //   imageurl: TImages.user,
              //   isNetworkImage: false,
              // )
            ],
          )),
          DataCell(Text(
            salesman.email.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            salesman.phoneNumber.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(TTableActionButtons(
            view: false,
            edit: true,
            delete: true,
            onEditPressed: () async {
              // await addressController.fetchEntityAddresses(salesman.salesmanId,'Salesman');
              salesmanController.setSalesmanDetail(salesman);
              // productImagesController.setDesiredImage(MediaCategory.salesman, salesman.salesmanId);
              Get.toNamed(TRoutes.addSalesman, arguments: salesman);
            },
            onDeletePressed: () async {
              Get.defaultDialog(
                title: "Confirm Delete",
                middleText:
                    "Are you sure you want to delete ${salesman.fullName}?",
                textConfirm: "Delete",
                textCancel: "Cancel",
                confirmTextColor: Colors.red,
                buttonColor: Colors.black,
                onConfirm: () async {
                  Navigator.of(Get.context!).pop(); // Close the dialog

                  await salesmanController.deleteSalesman(salesman.salesmanId!);
                },
                onCancel: () {
                  Navigator.of(Get.context!).pop(); // Close the dialog
                },
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
  int get rowCount => itemCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
