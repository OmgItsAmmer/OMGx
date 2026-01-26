import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/Models/orders/order_address_model.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';

/// Widget that displays an interactive map showing the delivery location for an order
class OrderLocationMap extends StatelessWidget {
  const OrderLocationMap({
    super.key,
    required this.orderAddress,
    this.height = 300,
    this.showFullAddress = true,
  });

  final OrderAddressModel orderAddress;
  final double height;
  final bool showFullAddress;

  @override
  Widget build(BuildContext context) {
    // Check if coordinates are valid
    if (!orderAddress.hasValidCoordinates()) {
      return TRoundedContainer(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 48,
                color: TColors.grey,
              ),
              const SizedBox(height: TSizes.md),
              Text(
                'Location not available',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: TColors.textSecondary,
                    ),
              ),
              const SizedBox(height: TSizes.xs),
              Text(
                'Coordinates not set for this order',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Create LatLng from address coordinates
    final LatLng orderLocation = LatLng(
      orderAddress.latitude!,
      orderAddress.longitude!,
    );

    return TRoundedContainer(
      height: height,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Map Container
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TSizes.cardRadiusLg),
                topRight: Radius.circular(TSizes.cardRadiusLg),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: orderLocation,
                  initialZoom: 15.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  // Tile Layer (OpenStreetMap)
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.omg.ecommerce_dashboard',
                    maxZoom: 19,
                  ),
                  // Marker Layer
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: orderLocation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Delivery',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: TColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Attribution
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Address and Coordinate Info
          if (showFullAddress) ...[
            Container(
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(TSizes.cardRadiusLg),
                  bottomRight: Radius.circular(TSizes.cardRadiusLg),
                ),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Address
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: TColors.textSecondary,
                      ),
                      const SizedBox(width: TSizes.xs),
                      Expanded(
                        child: Text(
                          orderAddress.displayAddress,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: TColors.textSecondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.xs),
                  // Coordinates Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.sm,
                      vertical: TSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.gps_fixed,
                          size: 12,
                          color: TColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ', ',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
