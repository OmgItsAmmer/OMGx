# Flutter Admin Dashboard

A comprehensive admin dashboard for business management built with Flutter and Supabase.

![Admin Dashboard](/assets/logos/logo.png)

## Features

- **Authentication**: Secure login system using Supabase
- **Dashboard**: Analytics overview with visualizations using fl_chart
- **Order Management**: Track and manage customer orders
- **Product Management**: CRUD operations for products
- **Customer Management**: Track customer information and purchase history
- **Sales Tracking**: Monitor sales performance with analytics
- **Salesman Management**: Manage sales team and track performance
- **Brand & Category Management**: Organize products by brands and categories
- **Installment Tracking**: Manage installment-based sales
- **Installment Reports**: Generate upcoming and overdue installments reports for better payment tracking
- **Expense Management**: Track business expenses
- **Report Generation**: Generate PDF reports using the pdf package
- **Media Management**: Upload and manage product images
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Secure Key Storage**: Protection of sensitive API keys
- **Network Resilience**: Robust socket connection handling
- **Improved Autocomplete**: Enhanced autocomplete component with validation and better UX

## Security Measures & Network Handling

### Secure Key Storage

The application now uses secure storage for sensitive API keys:

- Added `flutter_secure_storage` for securely storing Supabase credentials
- Created `SecureKeys` class that manages all sensitive keys
- Implemented environment variable fallback support
- Service key is only available in debug mode

### Android Release Mode Configuration

- Added internet permissions in AndroidManifest.xml
- Implemented ProGuard rules for code obfuscation
- Added Play Core dependencies to handle Flutter deferred components
- Configured build settings to ensure proper socket connections
- Fixed issue with R8 optimization in release mode

### Network & Socket Connection Handling

- Created `SupabaseNetworkManager` to manage Supabase connections
- Implemented socket connection timeout handling
- Added automatic retry mechanism for failed network operations
- Added periodic connection checking
- Improved error messaging for network issues

### Security Best Practices

1. Service role key is never exposed in release builds
2. Admin operations that require service key will fail gracefully in release builds with appropriate messages
3. All sensitive operations use proper error handling
4. Network status is monitored and displayed to users when relevant

## Platform Compatibility

The application is designed to work on multiple platforms:

- Desktop (Windows, macOS, Linux)
- Web
- Mobile (Android, iOS)

### Platform-Specific Implementation Notes

- **Window Manager**: The `window_manager` package is only initialized on desktop platforms to avoid errors on mobile platforms.
- **Responsive UI**: Different layouts are provided for desktop, tablet, and mobile screens.

## Responsive Design Implementation

The application features a fully responsive design with specific layouts for desktop, tablet, and mobile screens.

### Responsive Screens 

The following screens have been implemented with responsive designs for all device sizes:
- Dashboard
- Salesman Management
- Customer Management 
- Product Management
- Sales
- Store Settings
- Profile
- Reports
- Expenses

Screens currently in progress for responsive implementation:
- Media
- Brand & Category

### Screen Structure

Each responsive screen follows this implementation pattern:
```dart
return TSiteTemplate(
  desktop: DesktopVersion(),
  tablet: TabletVersion(),
  mobile: MobileVersion(),
);
```

The `TSiteTemplate` component automatically detects the device screen size and displays the appropriate layout version.

## Tech Stack

- **Flutter**: UI framework (^3.5.0)
- **Supabase**: Backend as a Service for authentication and database
- **GetX**: State management, navigation, and dependency injection
- **fl_chart**: Data visualization
- **PDF**: Report generation
- **And more**: See pubspec.yaml for the complete list of dependencies

## Getting Started

### Prerequisites

- Flutter SDK (^3.5.0)
- Supabase account

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/flutter_supabase_adminPanel.git
   cd flutter_supabase_adminPanel
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up your Supabase credentials:
   - Create a `lib/supabase_strings.dart` file with your Supabase URL and anon key
   - Or update the existing credentials in this file

4. Run the application:
   ```bash
   flutter run -d chrome  # For web
   # Or
   flutter run            # For mobile/desktop
   ```

## Project Structure

- **lib/**
  - **bindings/**: GetX bindings for dependency injection
  - **common/**: Reusable widgets and UI components
  - **controllers/**: GetX controllers for state management
  - **Models/**: Data models
  - **repositories/**: Data access layer
  - **routes/**: App navigation
  - **services/**: Business logic and API services
  - **utils/**: Utility functions and helpers
  - **views/**: UI screens organized by feature

## Deployment

- For web deployment, build the project:
  ```bash
  flutter build web
  ```

- For desktop deployment:
  ```bash
  flutter build windows  # or flutter build macos, flutter build linux
  ```

### Secure Deployment for Android

When building for release on Android:

```bash
# Set environment variables to override hardcoded keys (recommended)
flutter build apk --release \
  --dart-define=SUPABASE_URL=your_supabase_url \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key

# OR build without environment variables (uses embedded keys)
flutter build apk --release
```

#### Troubleshooting Release Mode Issues

If you encounter socket connection issues with Supabase in release mode:

1. Ensure Android Manifest has proper internet permissions:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   ```

2. Check that Play Core dependencies are included in build.gradle:
   ```gradle
   dependencies {
       implementation 'com.google.android.play:core:1.10.3'
   }
   ```

3. If minification causes issues, you can disable it initially:
   ```gradle
   minifyEnabled false
   shrinkResources false
   ```

4. Use the SupabaseNetworkManager to handle retry logic for socket connection issues

### Security Notes

- The service key should NEVER be included in release builds
- Admin operations are disabled in production (use a secure backend service instead)
- All sensitive operations require appropriate authentication
- ProGuard obfuscation is enabled for Android release builds

## Recent Bug Fixes

### Sales Controller - Buying Price Calculation (Latest Fix)

**Issue Fixed**: The `buyingPriceTotal` calculation in the sales controller was incorrectly handling deletion of cart items and merging of products, especially for serialized products.

**Problems Resolved**:
1. **Cart Item Deletion**: When removing items from the cart, the `buyingPriceTotal` was not being updated, causing inflated buying price totals in the database
2. **Product Merging**: When merging identical products, inconsistent buying price calculations were used
3. **Order Item Total Buying Price**: The `totalBuyPrice` field in `OrderItemModel` was not correctly calculated for regular products (needed quantity multiplication)

**Fixes Implemented**:
- Updated `deleteItem()` method to properly subtract buying prices when removing items
- Fixed `_mergeWithExistingProduct()` to use consistent buying price from existing sale
- Corrected `OrderItemModel` creation to properly calculate `totalBuyPrice` for both serialized and regular products
- Added proper handling for both serialized products (quantity always 1) and regular products (quantity variable)

**Technical Details**:
```dart
// Before: buyingPriceTotal was not updated on item deletion
// After: Proper calculation based on product type
if (saleItem.variantId != null) {
  buyingPriceToSubtract = saleItem.buyPrice; // Serialized product
} else {
  buyingPriceToSubtract = saleItem.buyPrice * quantity; // Regular product
}
```

## Installment Reports

The application now includes comprehensive installment tracking with two specialized reports:

### 1. Upcoming Installments Report
- **Purpose**: Track installments due within a specified number of days (7, 15, 30, 60, or 90 days)
- **Features**: 
  - Customer contact information for follow-up
  - Salesman details for accountability
  - Days until due for prioritization
  - Total amount calculations
  - PDF export functionality

### 2. Overdue Installments Report
- **Purpose**: Monitor unpaid installments that have passed their due date
- **Features**:
  - Days overdue calculation for urgency assessment
  - Customer and salesman information
  - Status tracking
  - Total overdue amount calculations
  - PDF export functionality

### Database Schema

#### Installment Reports Functions

1. **get_upcoming_installments_report(days_ahead INTEGER)**
   - Returns installments due within the specified number of days
   - Includes customer, salesman, and installment details
   - Filters unpaid installments only

2. **get_overdue_installments_report()**
   - Returns all overdue unpaid installments
   - Calculates days overdue automatically
   - Ordered by due date and customer name

#### Related Tables
- `installment_payments`: Main installment payment records
- `installment_plans`: Installment plan details linked to orders
- `orders`: Order information linking customers and salesman
- `customers`: Customer contact and personal information
- `salesman`: Salesman details for follow-up accountability

### Report Components

Both reports feature:
- Professional PDF generation with company branding
- Comprehensive data tables with customer contact information
- Summary statistics (total amounts, averages)
- Responsive UI with preview functionality
- Downloadable PDF reports for offline use

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Acknowledgments

- Flutter Team for the amazing framework
- Supabase for the backend infrastructure
- All the package authors that made this project possible

## UI Components

### Improved Autocomplete Component

The dashboard features a custom-built improved autocomplete component that resolves several issues with the standard Flutter Autocomplete widget:

1. **Better UX**: Only displays the dropdown when users type something
2. **Proper Focus Handling**: Correctly hides the overlay when navigating away from screens
3. **Validation**: Shows proper validation errors when users type something not in the list
4. **Consistent Styling**: Maintains the dashboard's visual style

Implementation:
```dart
ImprovedAutocomplete<String>(
  titleText: 'Product Name',
  hintText: 'Select a product',
  options: productList,
  controller: productController,
  displayStringForOption: (String option) => option,
  onSelected: (value) {
    // Handle selection
  },
)
```

The component is used throughout the application for product selection, customer search, and other autocomplete needs.
#   f l u t t e r _ s u p a b a s e _ a d m i n P a n e l 
 
 