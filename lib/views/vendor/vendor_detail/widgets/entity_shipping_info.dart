import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/enums.dart';
import '../../../profile/old/widgets/profile_menu.dart';
import '../../../../controllers/address/address_controller.dart';

class EntityShippingInfo<T> extends StatelessWidget {
  const EntityShippingInfo({
    super.key,
    required this.model,
    required this.entityType,
  });

  final T model;
  final EntityType entityType;

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();

    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TProfilemenu(
            title: "Name",
            value: _getFullName(model),
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TProfilemenu(
            title: "Phone Number",
            value: _getPhoneNumber(model),
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TProfilemenu(
            title: "Address",
            value: _getAddress(addressController, model),
            onPressed: () {},
            isTap: false,
          ),
        ],
      ),
    );
  }

  String _getFullName(T model) {
    switch (entityType) {
      case EntityType.customer:
        return (model as dynamic).fullName;
      case EntityType.salesman:
        return (model as dynamic).fullName;
      case EntityType.vendor:
        return (model as dynamic).fullName;
      case EntityType.user:
        return (model as dynamic).fullName;
    }
  }

  String _getPhoneNumber(T model) {
    switch (entityType) {
      case EntityType.customer:
        return (model as dynamic).phoneNumber;
      case EntityType.salesman:
        return (model as dynamic).phoneNumber;
      case EntityType.vendor:
        return (model as dynamic).phoneNumber;
      case EntityType.user:
        return (model as dynamic).phoneNumber;
    }
  }

  String _getAddress(AddressController controller, T model) {
    switch (entityType) {
      case EntityType.customer:
        return controller.allCustomerAddresses.isNotEmpty
            ? controller.allCustomerAddresses[0].shippingAddress ?? ''
            : 'No address';
      case EntityType.salesman:
        return controller.allSalesmanAddresses.isNotEmpty
            ? controller.allSalesmanAddresses[0].shippingAddress ?? ''
            : 'No address';
      case EntityType.vendor:
        return controller.allVendorAddresses.isNotEmpty
            ? controller.allVendorAddresses[0].shippingAddress ?? ''
            : 'No address';
      case EntityType.user:
        return 'No address';
    }
  }
}
