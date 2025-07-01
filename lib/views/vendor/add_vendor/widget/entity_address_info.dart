import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntityAddressInfo<T> extends StatelessWidget {
  const EntityAddressInfo({
    super.key,
    required this.controller,
    required this.entityType,
  });

  final dynamic controller; // Use GetX controller
  final EntityType entityType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TRoundedContainer(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Obx(() {
            final addresses = _getAddresses(controller);
            if (addresses.isEmpty) {
              return const Text('No Addresses');
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) =>
                  const SizedBox(height: TSizes.spaceBtwInputFields),
              itemCount: addresses.length,
              itemBuilder: (_, index) {
                return TRoundedContainer(
                  backgroundColor: TColors.primaryBackground,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Address #${index + 1}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputFields),
                      Expanded(
                        child: Text(
                          addresses[index].location ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  List<dynamic> _getAddresses(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        return controller.allCustomerAddresses;
      case EntityType.salesman:
        return controller.allSalesmanAddresses;
      case EntityType.vendor:
        return controller.allVendorAddresses;
      default:  
        return [];
    }
  }
}
