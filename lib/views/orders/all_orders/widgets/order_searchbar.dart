import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/table/table_search_controller.dart';

class OrderSearchbar extends StatelessWidget {
  const OrderSearchbar({super.key, this.width = 500});
  final double width;
  @override
  Widget build(BuildContext context) {
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'orders');
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: tableSearchController.searchController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Iconsax.search_normal),
          hintText: 'Search by order ID, date, or status',
        ),
        onChanged: (value) {
          tableSearchController.searchTerm.value = value;
        },
      ),
    );
  }
}
