import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/purchase/purchase_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/tiles/user_advance_info_tile.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/orders/orders_controller.dart';
import '../../../profile/old/widgets/profile_menu.dart';

class EntityAdvanceInfoCard<T> extends StatelessWidget {
  const EntityAdvanceInfoCard({
    super.key,
    required this.model,
    required this.entityType,
  });

  final T model;
  final EntityType entityType;

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();
    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getEntityName()} Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          // Profile picture and name/email
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                final image = mediaController.displayImage.value;
                if (image != null) {
                  return FutureBuilder<String?>(
                    future: mediaController.getImageFromBucket(
                      _getMediaCategory().toString().split('.').last,
                      image.filename ?? '',
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const TShimmerEffect(width: 80, height: 80);
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return const Icon(Icons.error);
                      } else {
                        return TRoundedImage(
                          isNetworkImage: true,
                          width: 80,
                          height: 80,
                          imageurl: snapshot.data!,
                        );
                      }
                    },
                  );
                }
                return FutureBuilder<String?>(
                  future: mediaController.fetchMainImage(
                    _getEntityId(model),
                    _getMediaCategory().toString().split('.').last,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const TShimmerEffect(width: 80, height: 80);
                    } else if (snapshot.hasError) {
                      return const Text('Error loading image');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return TRoundedImage(
                        isNetworkImage: true,
                        width: 80,
                        height: 80,
                        imageurl: snapshot.data!,
                      );
                    } else {
                      return const TCircularIcon(
                        icon: Iconsax.image,
                        width: 80,
                        height: 80,
                        backgroundColor: TColors.primaryBackground,
                      );
                    }
                  },
                );
              }),
              const SizedBox(width: TSizes.spaceBtwItems),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getFullName(model),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    _getEmail(model),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
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
          const Divider(),
          Row(
            children: [
              Expanded(
                child: OUserAdvanceInfoTile(
                  firstTile: 'Last Purchase',
                  secondTile: (purchaseController.recentPurchaseDay == '0')
                      ? 'No Purchases yet'
                      : purchaseController.recentPurchaseDay,
                ),
              ),
              Expanded(
                child: OUserAdvanceInfoTile(
                  firstTile: 'Average Purchase',
                  secondTile: (purchaseController.averageTotalAmount == '0.0')
                      ? 'No Purchases yet'
                      : purchaseController.averageTotalAmount,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: OUserAdvanceInfoTile(
                  firstTile: 'Registered At',
                  secondTile: _getCreatedAt(model) != null
                      ? DateFormat('dd MMM yyyy, hh:mm a')
                          .format(_getCreatedAt(model)!)
                      : 'N/A',
                ),
              ),
              const Expanded(
                child: OUserAdvanceInfoTile(
                  firstTile: 'Email Marketing',
                  secondTile: 'UnSubscribed',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getEntityName() {
    switch (entityType) {
      case EntityType.customer:
        return 'Customer';
      case EntityType.salesman:
        return 'Salesman';
      case EntityType.vendor:
        return 'Vendor';
      case EntityType.user:
        return 'User';
    }
  }

  MediaCategory _getMediaCategory() {
    switch (entityType) {
      case EntityType.customer:
        return MediaCategory.customers;
      case EntityType.salesman:
        return MediaCategory.salesman;
      case EntityType.vendor:
        return MediaCategory
            .shop; // Note: vendor controller uses 'vendors' string directly
      case EntityType.user:
        return MediaCategory.users;
    }
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

  String _getEmail(T model) {
    switch (entityType) {
      case EntityType.customer:
        return (model as dynamic).email;
      case EntityType.salesman:
        return (model as dynamic).email;
      case EntityType.vendor:
        return (model as dynamic).email;
      case EntityType.user:
        return (model as dynamic).email;
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

  DateTime? _getCreatedAt(T model) {
    switch (entityType) {
      case EntityType.customer:
        return (model as dynamic).createdAt;
      case EntityType.salesman:
        return (model as dynamic).createdAt;
      case EntityType.vendor:
        return (model as dynamic).createdAt;
      case EntityType.user:
        return (model as dynamic).createdAt;
    }
  }

  int _getEntityId(T model) {
    switch (entityType) {
      case EntityType.customer:
        return (model as dynamic).customerId ?? -1;
      case EntityType.salesman:
        return (model as dynamic).salesmanId ?? -1;
      case EntityType.vendor:
        return (model as dynamic).vendorId ?? -1;
      case EntityType.user:
        return -1;
    }
  }
}
