import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/collection/collection_model.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../routes/routes.dart';

class CollectionTableSource extends DataTableSource {
  CollectionTableSource({
    required this.collections,
  });

  final List<CollectionModel> collections;
  final CollectionController collectionController = Get.find<CollectionController>();

  @override
  DataRow? getRow(int index) {
    if (index >= collections.length) return null;
    
    final collection = collections[index];

    return DataRow2(
      onTap: () async {
        collectionController.setCollectionDetail(collection);
        Get.toNamed(TRoutes.collectionDetails);
      },
      onSelectChanged: (value) {
        // Handle selection if needed
      },
      cells: [
        DataCell(
          Text(
            collection.name,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          ),
        ),
        DataCell(
          Text(
            collection.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(Get.context!).textTheme.bodyMedium,
          ),
        ),
        DataCell(
          Text(
            collection.displayOrder.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(
                collection.isActive ? Iconsax.tick_circle : Iconsax.close_circle,
                color: collection.isActive ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                collection.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: collection.isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(
                collection.isFeatured ? Iconsax.star1 : Iconsax.star,
                color: collection.isFeatured ? Colors.amber : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                collection.isFeatured ? 'Yes' : 'No',
                style: TextStyle(
                  color: collection.isFeatured ? Colors.amber : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(
                collection.isPremium ? Iconsax.crown1 : Iconsax.crown,
                color: collection.isPremium ? Colors.purple : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                collection.isPremium ? 'Yes' : 'No',
                style: TextStyle(
                  color: collection.isPremium ? Colors.purple : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: true,
            delete: true,
            onViewPressed: () {
              collectionController.setCollectionDetail(collection);
              Get.toNamed(TRoutes.collectionDetails);
            },
            onEditPressed: () {
              collectionController.setCollectionDetail(collection);
              Get.toNamed(TRoutes.collectionDetails);
            },
            onDeletePressed: () {
              _showDeleteConfirmation(collection);
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(CollectionModel collection) {
    Get.defaultDialog(
      title: 'Delete Collection',
      middleText: 'Are you sure you want to delete "${collection.name}"?\n\nThis will also remove all items in this collection.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: TColors.primary,
      onConfirm: () async {
        Get.back(); // Close dialog
        await collectionController.deleteCollection(collection.collectionId);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => collections.length;

  @override
  int get selectedRowCount => 0;
}
