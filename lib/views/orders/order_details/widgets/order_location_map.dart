import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/Models/address/order_address_model.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';

/// Widget that displays an OpenStreetMap with a marker showing the order delivery location
/// Uses OpenStreetMap raster tiles and shows the exact coordinates from the order address
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
    // Check if valid coordinates exist
    if (!orderAddress.hasValidCoordinates()) {
      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.map_outlined, 
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(
                  'Delivery Location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      'Location not available',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      'Coordinates not set for this order',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final LatLng orderLocation = LatLng(
      orderAddress.latitude!,
      orderAddress.longitude!,
    );

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.map_outlined, 
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  'Delivery Location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // Coordinates badge
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
                      '${orderAddress.latitude!.toStringAsFixed(6)}, ${orderAddress.longitude!.toStringAsFixed(6)}',
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
          
          const SizedBox(height: TSizes.spaceBtwItems),

          // Map
          ClipRRect(
            borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            child: SizedBox(
              height: height,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: orderLocation,
                  initialZoom: 15.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                  // Enable interactions
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  // OpenStreetMap tiles
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.omg.ecommerce_dashboard',
                    maxZoom: 19,
                  ),
                  
                  // Marker for order location
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: orderLocation,
                        child: Column(
                          children: [
                            // Custom marker with shadow
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
                            // Label
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Attribution layer (required for OSM)
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () {}, // Could open OSM copyright page
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Address details (if enabled)
          if (showFullAddress) ...[
            const SizedBox(height: TSizes.spaceBtwItems),
            Container(
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: TSizes.xs),
                  Expanded(
                    child: Text(
                      orderAddress.formattedAddress ?? 
                      orderAddress.shippingAddress ?? 
                      'Address not available',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
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
