import 'package:admin_dashboard_v3/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:admin_dashboard_v3/controllers/dashboard/dashboard_controoler.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:admin_dashboard_v3/views/orders/old_orders/order_detail.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/enums.dart';
import '../../order_details/order_detail.dart';
import '../../order_details/responsive_screens/order_detail_desktop.dart';


class OrderRows extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    final dashBoardController  = Get.put(DashboardController());
    //order model
    return DataRow2(
        onTap: () => Get.to(() => const OrderDetailScreen()),
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(
            Text(
              '1',
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            ),
          ),
          const DataCell(Text('OrdeDate')),
          const DataCell(Text('Item length')),
          DataCell(TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
                vertical: TSizes.sm, horizontal: TSizes.md),
            backgroundColor:
                THelperFunctions.getOrderStatusColor(OrderStatus.pending)
                    .withOpacity(0.1),
            child: Text(
              'Order  status name',
              style: TextStyle(
                  color: THelperFunctions.getOrderStatusColor(
                      OrderStatus.pending)),
            ),
          )),
          const DataCell(Text('total amount')),
          DataCell(
            TTableActionButtons(
              view: true,
              edit: false,
              onViewPressed: () => Get.to(()=> const OrderDetailScreen()), // TODO use get argument to send data in order detail screen
              onDeletePressed: (){},
            )
          )//orderid
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
