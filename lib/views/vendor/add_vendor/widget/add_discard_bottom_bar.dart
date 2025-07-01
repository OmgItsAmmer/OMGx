import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

// Step 1: Create the EntityType enum


// Step 2: Refactor the component
class AddDiscardBottomBar<T> extends StatelessWidget {
  const AddDiscardBottomBar({
    super.key,
    required this.model,
    required this.controller,
    required this.entityType,
  });

  final T model;
  final dynamic controller; // Use GetX controller
  final EntityType entityType;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: TDeviceUtils.isDesktopScreen(context) ? 4 : 0,
            child: const SizedBox(),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _cleanDetails(controller);
                  Navigator.of(context).pop();
                },
                child: const Text('Discard'),
              ),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    await _handleSaveOrUpdate(controller, model, entityType);
                    Navigator.of(context).pop();
                  },
                  child: (controller.isUpdating.value)
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_getButtonText(model, entityType)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _cleanDetails(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        controller.cleanCustomerDetails();
        break;
      case EntityType.salesman:
        controller.cleanSalesmanDetails();
        break;
      case EntityType.vendor:
        controller.cleanVendorDetails();
        break;
      case EntityType.user:
        break;
      }
  }

  Future<void> _handleSaveOrUpdate(
      dynamic controller, T model, EntityType entityType) async {
    switch (entityType) {
      case EntityType.customer:
        if ((model as dynamic).customerId == null) {
          await controller.insertCustomer();
        } else {
          await controller.updateCustomer((model as dynamic).customerId!);
        }
        break;
      case EntityType.salesman:
        if ((model as dynamic).salesmanId == null) {
          await controller.insertSalesman();
        } else {
          await controller.updateSalesman((model as dynamic).salesmanId!);
        }
        break;
      case EntityType.vendor:
        if ((model as dynamic).vendorId == null) {
          await controller.insertVendor();
        } else {
          await controller.updateVendor((model as dynamic).vendorId!);
        }
        break;
      case EntityType.user:
        break;

    }
  }

  String _getButtonText(T model, EntityType entityType) {
    switch (entityType) {
      case EntityType.customer:
        return (model as dynamic).customerId == null ? 'Save' : 'Update';
      case EntityType.salesman:
        return (model as dynamic).salesmanId == null ? 'Save' : 'Update';
      case EntityType.vendor:
      case EntityType.user:
        return 'Save';
        return (model as dynamic).vendorId == null ? 'Save' : 'Update';
    }
  }
}
