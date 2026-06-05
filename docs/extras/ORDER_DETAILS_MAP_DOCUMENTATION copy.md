# Order Details Map Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Database Schema](#database-schema)
4. [Packages and Dependencies](#packages-and-dependencies)
5. [Data Flow](#data-flow)
6. [Code Structure](#code-structure)
7. [Component Details](#component-details)
8. [Responsive Implementation](#responsive-implementation)
9. [Error Handling](#error-handling)
10. [Usage Examples](#usage-examples)

---

## Overview

The Order Details Map feature displays an interactive map showing the delivery location for orders in the ecommerce dashboard. The implementation uses **OpenStreetMap** (OSM) via the `flutter_map` package to render maps with markers indicating the exact delivery coordinates stored in the database.

### Key Features
- Interactive map with zoom and pan capabilities
- Visual marker showing delivery location
- Coordinate display badge
- Full address display
- Graceful fallback when coordinates are unavailable
- Responsive design for desktop, tablet, and mobile

---

## Architecture

### High-Level Flow

```
Order Detail Screen
    ↓
Fetch Order Address (with coordinates)
    ↓
OrderRepository.fetchOrderAddressWithCoordinates()
    ↓
Query order_addresses or addresses table
    ↓
OrderAddressModel (with latitude/longitude)
    ↓
OrderLocationMap Widget
    ↓
FlutterMap (OpenStreetMap tiles)
    ↓
MarkerLayer (Delivery location marker)
```

### Component Hierarchy

```
OrderDetailScreen (Main Entry)
├── OrderDetailDesktopScreen
│   └── OrderLocationMap (height: 350)
├── OrderDetailTabletScreen
│   └── OrderLocationMap (height: 300)
└── OrderDetailMobileScreen
    └── OrderLocationMap (height: 250)
```

---

## Database Schema

### Tables Involved

#### 1. `orders` Table
Stores order information and references the address via `address_id`.

| Column | Type | Description |
|--------|------|-------------|
| `order_id` | integer | Primary key |
| `address_id` | integer | Foreign key to `order_addresses` or `addresses` |
| `order_date` | date | Order creation date |
| `sub_total` | numeric | Order subtotal |
| `status` | USER-DEFINED | Order status enum |
| `saletype` | text | Sale type (cash/installment) |
| `customer_id` | integer | Customer reference |
| `salesman_id` | integer | Salesman reference |
| ... | ... | Other order fields |

#### 2. `order_addresses` Table
Primary table for order delivery addresses with geographic coordinates.

| Column | Type | Description |
|--------|------|-------------|
| `order_address_id` | integer | Primary key |
| `address_id` | integer | Reference ID |
| `shipping_address` | text | Full shipping address text |
| `phone_number` | text | Contact phone number |
| `postal_code` | text | Postal/ZIP code |
| `city` | text | City name |
| `country` | text | Country name |
| `full_name` | text | Recipient full name |
| `customer_id` | integer | Customer reference |
| `vendor_id` | integer | Vendor reference |
| `salesman_id` | integer | Salesman reference |
| `user_id` | integer | User reference |
| **`latitude`** | **numeric** | **Geographic latitude coordinate** |
| **`longitude`** | **numeric** | **Geographic longitude coordinate** |
| `place_id` | text | Google Places API place ID (optional) |
| `formatted_address` | text | Formatted address string |

#### 3. `addresses` Table (Fallback)
Alternative table with same structure as `order_addresses`, used as fallback if address not found in `order_addresses`.

| Column | Type | Description |
|--------|------|-------------|
| `address_id` | integer | Primary key |
| `latitude` | numeric | Geographic latitude |
| `longitude` | numeric | Geographic longitude |
| ... | ... | Same fields as `order_addresses` |

### Schema Relationships

```
orders (address_id) → order_addresses (address_id)
                    → addresses (address_id) [fallback]
```

---

## Packages and Dependencies

### Core Map Packages

#### 1. `flutter_map: ^7.0.2`
- **Purpose**: Main mapping library for Flutter
- **Features**: 
  - Raster tile rendering
  - Marker support
  - Interactive controls (zoom, pan)
  - Customizable layers
- **Documentation**: https://pub.dev/packages/flutter_map
- **License**: BSD-3-Clause

#### 2. `latlong2: ^0.9.1`
- **Purpose**: Geographic coordinate handling
- **Features**:
  - `LatLng` class for coordinates
  - Distance calculations
  - Coordinate validation
- **Documentation**: https://pub.dev/packages/latlong2
- **License**: MIT

### Supporting Packages

#### 3. `supabase_flutter: ^2.8.3`
- **Purpose**: Database access for fetching address data
- **Usage**: Used in `OrderRepository` to query address tables

#### 4. `get: ^4.6.5`
- **Purpose**: State management and dependency injection
- **Usage**: Controller access and reactive state updates

### Package Installation

```yaml
dependencies:
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  supabase_flutter: ^2.8.3
  get: ^4.6.5
```

---

## Data Flow

### Step-by-Step Process

#### 1. **Order Detail Screen Initialization**

```dart
// File: lib/views/orders/order_details/order_detail.dart
class OrderDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final order = Get.arguments; // OrderModel passed via route
    return TSiteTemplate(
      desktop: OrderDetailDesktopScreen(orderModel: order),
      tablet: OrderDetailTabletScreen(orderModel: order),
      mobile: OrderDetailMobileScreen(orderModel: order),
    );
  }
}
```

#### 2. **Address Fetching in Responsive Screens**

Each responsive screen (Desktop/Tablet/Mobile) follows the same pattern:

```dart
// Example from OrderDetailDesktopScreen
class _OrderDetailDesktopScreenState extends State<OrderDetailDesktopScreen> {
  OrderAddressModel? orderAddress;
  bool isLoadingAddress = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderAddress();
  }

  Future<void> _fetchOrderAddress() async {
    if (widget.orderModel.addressId != null) {
      final orderRepository = OrderRepository();
      final address = await orderRepository.fetchOrderAddressWithCoordinates(
        widget.orderModel.addressId,
      );
      setState(() {
        orderAddress = address;
        isLoadingAddress = false;
      });
    } else {
      setState(() {
        isLoadingAddress = false;
      });
    }
  }
}
```

#### 3. **Repository Layer - Address Fetching**

```dart
// File: lib/repositories/order/order_repository.dart
Future<OrderAddressModel?> fetchOrderAddressWithCoordinates(int? addressId) async {
  try {
    if (addressId == null) return null;

    // First try: order_addresses table
    final orderAddressResponse = await supabase
        .from('order_addresses')
        .select()
        .eq('address_id', addressId)
        .maybeSingle();

    if (orderAddressResponse != null) {
      return OrderAddressModel.fromJson(orderAddressResponse);
    }

    // Fallback: addresses table
    final addressResponse = await supabase
        .from('addresses')
        .select()
        .eq('address_id', addressId)
        .maybeSingle();

    if (addressResponse != null) {
      return OrderAddressModel.fromJson(addressResponse);
    }

    return null;
  } catch (e) {
    return null; // Graceful failure
  }
}
```

#### 4. **Model Parsing**

```dart
// File: lib/Models/address/order_address_model.dart
factory OrderAddressModel.fromJson(Map<String, dynamic> json) {
  return OrderAddressModel(
    // ... other fields
    latitude: json['latitude'] != null 
        ? (json['latitude'] is num 
            ? (json['latitude'] as num).toDouble() 
            : double.tryParse(json['latitude'].toString()))
        : null,
    longitude: json['longitude'] != null
        ? (json['longitude'] is num
            ? (json['longitude'] as num).toDouble()
            : double.tryParse(json['longitude'].toString()))
        : null,
    // ... other fields
  );
}

bool hasValidCoordinates() {
  return latitude != null && 
         longitude != null && 
         latitude != 0.0 && 
         longitude != 0.0;
}
```

#### 5. **Map Widget Rendering**

```dart
// File: lib/views/orders/order_details/widgets/order_location_map.dart
if (!orderAddress.hasValidCoordinates()) {
  // Show fallback UI
} else {
  // Render map with marker
  final LatLng orderLocation = LatLng(
    orderAddress.latitude!,
    orderAddress.longitude!,
  );
  // ... FlutterMap widget
}
```

---

## Code Structure

### File Organization

```
lib/
├── views/
│   └── orders/
│       └── order_details/
│           ├── order_detail.dart                    # Main entry point
│           ├── responsive_screens/
│           │   ├── order_detail_desktop.dart       # Desktop layout
│           │   ├── order_detail_tablet.dart         # Tablet layout
│           │   └── order_detail_mobile.dart         # Mobile layout
│           └── widgets/
│               └── order_location_map.dart          # Map widget
├── Models/
│   └── address/
│       └── order_address_model.dart                 # Address data model
└── repositories/
    └── order/
        └── order_repository.dart                    # Data fetching logic
```

---

## Component Details

### 1. OrderLocationMap Widget

**Location**: `lib/views/orders/order_details/widgets/order_location_map.dart`

#### Constructor Parameters

```dart
const OrderLocationMap({
  super.key,
  required this.orderAddress,      // OrderAddressModel with coordinates
  this.height = 300,                 // Map container height
  this.showFullAddress = true,      // Toggle address display
});
```

#### Key Features

##### A. Coordinate Validation

```dart
if (!orderAddress.hasValidCoordinates()) {
  return TRoundedContainer(
    // Fallback UI with "Location not available" message
  );
}
```

**Validation Logic**:
- Checks if `latitude` and `longitude` are not null
- Ensures coordinates are not `0.0` (invalid default)
- Returns early if invalid, showing fallback UI

##### B. Map Configuration

```dart
FlutterMap(
  options: MapOptions(
    initialCenter: orderLocation,    // LatLng from address
    initialZoom: 15.0,              // Zoom level (street level)
    minZoom: 5.0,                   // Minimum zoom (country level)
    maxZoom: 18.0,                  // Maximum zoom (building level)
    interactionOptions: const InteractionOptions(
      flags: InteractiveFlag.all,   // Enable all interactions
    ),
  ),
  children: [
    // Tile layer, marker layer, attribution
  ],
)
```

**Zoom Levels**:
- `5.0`: Country/region view
- `10.0`: City view
- `15.0`: Street view (default)
- `18.0`: Building detail view

##### C. Tile Layer (OpenStreetMap)

```dart
TileLayer(
  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  subdomains: const ['a', 'b', 'c'],  // Load balancing
  userAgentPackageName: 'com.omg.ecommerce_dashboard',
  maxZoom: 19,
)
```

**Tile URL Structure**:
- `{s}`: Subdomain (a, b, or c) for load balancing
- `{z}`: Zoom level (0-19)
- `{x}`: Tile X coordinate
- `{y}`: Tile Y coordinate

**OpenStreetMap Usage**:
- Free and open-source
- No API key required
- Requires attribution (handled by `RichAttributionWidget`)
- Rate limits apply (mitigated by subdomain rotation)

##### D. Marker Layer

```dart
MarkerLayer(
  markers: [
    Marker(
      width: 80.0,
      height: 80.0,
      point: orderLocation,
      child: Column(
        children: [
          // Red location pin icon
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
          // "Delivery" label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [/* ... */],
            ),
            child: Text('Delivery', /* ... */),
          ),
        ],
      ),
    ),
  ],
)
```

**Marker Design**:
- Red location pin icon (`Icons.location_on`)
- Shadow for depth
- White label container with "Delivery" text
- Positioned at exact coordinates

##### E. Attribution Widget

```dart
RichAttributionWidget(
  attributions: [
    TextSourceAttribution(
      'OpenStreetMap contributors',
      onTap: () {}, // Optional: Open OSM copyright page
    ),
  ],
)
```

**Purpose**: Required by OpenStreetMap license to credit data contributors.

##### F. Address Display

```dart
if (showFullAddress) ...[
  Container(
    padding: const EdgeInsets.all(TSizes.sm),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Row(
      children: [
        Icon(Icons.location_on_outlined, /* ... */),
        Expanded(
          child: Text(
            orderAddress.formattedAddress ?? 
            orderAddress.shippingAddress ?? 
            'Address not available',
          ),
        ),
      ],
    ),
  ),
]
```

**Address Priority**:
1. `formattedAddress` (if available)
2. `shippingAddress` (fallback)
3. "Address not available" (final fallback)

##### G. Coordinate Badge

```dart
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
      const Icon(Icons.gps_fixed, size: 12, color: TColors.primary),
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
)
```

**Format**: Coordinates displayed with 6 decimal places (approximately 10cm precision).

---

## Responsive Implementation

### Desktop Layout

**File**: `lib/views/orders/order_details/responsive_screens/order_detail_desktop.dart`

```dart
// Map positioned in left column, below order items
if (!isLoadingAddress && orderAddress != null)
  OrderLocationMap(
    orderAddress: orderAddress!,
    height: 350,              // Taller for desktop
    showFullAddress: true,
  ),
```

**Layout**:
- Two-column layout (flex: 2, flex: 1)
- Map in left column
- Height: 350px

### Tablet Layout

**File**: `lib/views/orders/order_details/responsive_screens/order_detail_tablet.dart`

```dart
// Map in full-width section
if (!isLoadingAddress && orderAddress != null)
  OrderLocationMap(
    orderAddress: orderAddress!,
    height: 300,              // Medium height
    showFullAddress: true,
  ),
```

**Layout**:
- Two-column layout (flex: 3, flex: 2)
- Map in full-width section below transaction
- Height: 300px

### Mobile Layout

**File**: `lib/views/orders/order_details/responsive_screens/order_detail_mobile.dart`

```dart
// Map in vertical stack
if (!isLoadingAddress && orderAddress != null)
  OrderLocationMap(
    orderAddress: orderAddress!,
    height: 250,              // Compact for mobile
    showFullAddress: true,
  ),
```

**Layout**:
- Single-column vertical stack
- Map positioned after transaction info
- Height: 250px (optimized for small screens)

---

## Error Handling

### 1. Missing Address ID

```dart
if (widget.orderModel.addressId != null) {
  // Fetch address
} else {
  setState(() {
    isLoadingAddress = false;
  });
  // Map widget won't render (conditional check)
}
```

**Result**: Map widget is not rendered if `addressId` is null.

### 2. Invalid Coordinates

```dart
if (!orderAddress.hasValidCoordinates()) {
  return TRoundedContainer(
    // Fallback UI with icon and message
  );
}
```

**Fallback UI**:
- Grey container
- Location off icon
- "Location not available" message
- "Coordinates not set for this order" subtitle

### 3. Database Query Failures

```dart
try {
  // Database query
} catch (e) {
  if (kDebugMode) {
    print('Error fetching order address: $e');
  }
  return null; // Graceful failure, no error snackbar
}
```

**Strategy**: Silent failure - map simply doesn't render if address fetch fails.

### 4. Coordinate Parsing Errors

```dart
latitude: json['latitude'] != null 
    ? (json['latitude'] is num 
        ? (json['latitude'] as num).toDouble() 
        : double.tryParse(json['latitude'].toString()))
    : null,
```

**Handling**:
- Checks if value is numeric type first
- Falls back to string parsing if needed
- Returns null if parsing fails

---

## Usage Examples

### Basic Usage

```dart
OrderLocationMap(
  orderAddress: orderAddressModel,
)
```

### Custom Height

```dart
OrderLocationMap(
  orderAddress: orderAddressModel,
  height: 400,
)
```

### Hide Address Display

```dart
OrderLocationMap(
  orderAddress: orderAddressModel,
  showFullAddress: false,
)
```

### Complete Integration Example

```dart
class MyOrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  
  @override
  State<MyOrderDetailScreen> createState() => _MyOrderDetailScreenState();
}

class _MyOrderDetailScreenState extends State<MyOrderDetailScreen> {
  OrderAddressModel? orderAddress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    if (widget.order.addressId != null) {
      final repo = OrderRepository();
      final address = await repo.fetchOrderAddressWithCoordinates(
        widget.order.addressId,
      );
      setState(() {
        orderAddress = address;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Other widgets
          if (!isLoading && orderAddress != null)
            OrderLocationMap(
              orderAddress: orderAddress!,
              height: 300,
              showFullAddress: true,
            ),
        ],
      ),
    );
  }
}
```

---

## Technical Details

### Coordinate System

- **Format**: WGS84 (World Geodesic System 1984)
- **Latitude Range**: -90 to +90 (South to North)
- **Longitude Range**: -180 to +180 (West to East)
- **Precision**: 6 decimal places ≈ 10cm accuracy

### Map Tile System

- **Projection**: Web Mercator (EPSG:3857)
- **Tile Size**: 256x256 pixels
- **Zoom Levels**: 0-19
- **Tile Calculation**: 
  - Tiles per dimension at zoom `z`: `2^z`
  - Total tiles at zoom `z`: `4^z`

### Performance Considerations

1. **Tile Caching**: FlutterMap caches tiles automatically
2. **Lazy Loading**: Tiles load on-demand as map is panned
3. **Subdomain Rotation**: Distributes load across OSM servers
4. **Marker Optimization**: Single marker, minimal overhead

### OpenStreetMap Usage Policy

- **Attribution**: Required (handled by `RichAttributionWidget`)
- **Rate Limits**: ~2 requests/second per IP
- **Commercial Use**: Allowed with attribution
- **Tile Usage**: Free for reasonable use

---

## Troubleshooting

### Map Not Displaying

1. **Check coordinates**:
   ```dart
   print('Lat: ${orderAddress.latitude}, Lng: ${orderAddress.longitude}');
   ```

2. **Verify address fetch**:
   ```dart
   final address = await orderRepository.fetchOrderAddressWithCoordinates(addressId);
   print('Address: $address');
   ```

3. **Check network connectivity**: OSM tiles require internet

### Invalid Coordinates

- Ensure `latitude` and `longitude` are not `0.0`
- Verify coordinates are within valid ranges:
  - Latitude: -90 to 90
  - Longitude: -180 to 180

### Tiles Not Loading

- Check internet connection
- Verify OSM tile server availability
- Check user agent string is set correctly
- Review browser console for CORS errors (web)

---

## Future Enhancements

### Potential Improvements

1. **Multiple Markers**: Show pickup and delivery locations
2. **Route Display**: Draw route between locations
3. **Custom Map Styles**: Support for different tile providers
4. **Offline Maps**: Cache tiles for offline viewing
5. **Geocoding**: Reverse geocode coordinates to address
6. **Distance Calculation**: Show distance from warehouse
7. **Real-time Tracking**: Update marker position in real-time

### Alternative Map Providers

- **Google Maps**: Requires API key, paid after free tier
- **Mapbox**: Custom styling, requires API key
- **MapTiler**: Commercial alternative with free tier

---

## Summary

The Order Details Map feature provides a visual representation of order delivery locations using OpenStreetMap. The implementation is:

- **Robust**: Handles missing/invalid coordinates gracefully
- **Responsive**: Adapts to desktop, tablet, and mobile screens
- **Performant**: Efficient tile loading and caching
- **Maintainable**: Clear separation of concerns
- **Free**: No API keys or paid services required

The system fetches address data from Supabase, validates coordinates, and renders an interactive map with a marker at the delivery location, providing administrators with a clear visual reference for order fulfillment.

---

**Document Version**: 1.0  
**Last Updated**: 2024  
**Author**: Ecommerce Dashboard Team
