import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../Models/customer/customer_model.dart';
import '../../../../Models/products/product_model.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../orders/order_details/order_detail.dart';

class CustomerRow extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    final customer = CustomerModel.empty();
    return DataRow2(
        onTap: () => Get.toNamed(TRoutes.productsDetail, arguments: customer),
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(Row(
            children: [
              Text(
                customer.fullName.toString(),
                style: Theme.of(Get.context!)
                    .textTheme
                    .bodyLarge!
                    .apply(color: TColors.primary),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields/2,),
              const TRoundedImage(
                width: 50,
                height: 50,
                imageurl: TImages.user,
                isNetworkImage: false,
              )
            ],
          )),
          DataCell(Text(
            customer.email.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            customer.phoneNumber.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          //TODO show brand names
          DataCell(TTableActionButtons(
            view: false,
            edit: true,

            onViewPressed: () => Get.toNamed(TRoutes.productsDetail,
                arguments:
                    customer), // TODO use get argument to send data in order detail screen
            onDeletePressed: () {},
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => 10;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
