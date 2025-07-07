# Flutter Admin Dashboard

A comprehensive admin dashboard for business management built with Flutter and Supabase.

![Admin Dashboard](/assets/logos/logo.png)

## Features

- **Authentication**: Secure login system using Supabase
- **Dashboard**: Analytics overview with visualizations using fl_chart
- **Order Management**: Track and manage customer orders
- **Product Management**: CRUD operations for products
- **Customer Management**: Track customer information and purchase history
- **Vendor Management**: Comprehensive vendor management with CRUD operations, address tracking, and order history
- **Account Book Management**: Complete financial tracking system for incoming and outgoing payments with vendor, customer, and salesman integration
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
- **Database Switching Support**: Automatic detection and handling of database credential changes
- **Centralized Configuration**: All credentials sourced from `SupabaseStrings` class for consistency
- **Automatic Cleanup**: Old stored credentials are cleared when switching databases

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

### Database Configuration

The application supports easy database switching through centralized configuration:

#### Configuration Files:
- `lib/supabase_strings.dart`: Contains all Supabase database credentials
- `lib/utils/security/secure_keys.dart`: Manages secure storage and retrieval of credentials

#### Switching Databases:
1. Update credentials in `supabase_strings.dart`
2. Restart the application
3. The system automatically detects changes and clears old stored credentials
4. New credentials are securely stored and used for all database operations

#### Features:
- **Automatic Detection**: System detects when database URL changes
- **Secure Storage**: Credentials are encrypted and stored securely on device
- **Environment Support**: Supports environment variables for different deployment environments
- **Debug Logging**: Comprehensive logging in debug mode for troubleshooting
- **Connection Testing**: Built-in methods to verify database connectivity

## Database Schema

### Product Variant System Tables

#### Product Variants Table
```sql
CREATE TABLE product_variants (
    variant_id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(product_id),
    variant_name VARCHAR(255) NOT NULL,
    sku VARCHAR(100),
    is_visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

#### Variant Batches Table
```sql
CREATE TABLE variant_batches (
    id BIGSERIAL PRIMARY KEY,
    variant_id BIGINT NOT NULL REFERENCES product_variants(variant_id),
    batch_id VARCHAR(255) NOT NULL UNIQUE,
    quantity INTEGER NOT NULL,
    available_quantity INTEGER NOT NULL,
    buy_price DECIMAL(15, 2) NOT NULL,
    sell_price DECIMAL(15, 2) NOT NULL,
    vendor VARCHAR(255),
    purchase_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

#### Updated Products Table
The products table maintains overall stock quantities calculated from variant batches:
```sql
-- Products table now has stock_quantity auto-calculated from variant_batches
-- has_serial_numbers field is deprecated (kept for compatibility)
```

### Key Features:
- **Batch Tracking**: Each purchase creates new batches with specific buy/sell prices
- **FIFO/LIFO Support**: Configurable inventory management strategies
- **Vendor Tracking**: Each batch tracks the supplier information
- **Price History**: Historical buy/sell prices maintained per batch
- **Automatic Stock Updates**: Product stock quantities calculated from available batches

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

### Account Book Feature

The application includes a comprehensive account book system for tracking financial transactions:

#### Features:
- **Payment Tracking**: Record incoming and outgoing payments for customers, vendors, and salesmen
- **Transaction Types**: Support for buy (incoming) and sell (outgoing) transaction types
- **Entity Integration**: Direct integration with customer, vendor, and salesman entities using dropdown selection
- **Smart Entity Selection**: Dropdown-based entity selection that populates registered members based on selected entity type
- **Data Validation**: Ensures only existing members are used in account book entries
- **Date-based Filtering**: Filter transactions by date ranges
- **Search Functionality**: Search transactions by entity name, description, or reference
- **Financial Summary**: Real-time calculation of total incoming, outgoing, and net balance
- **Responsive Design**: Optimized layouts for desktop, tablet, and mobile devices

#### Entity Selection Workflow:
1. User selects entity type (Customer, Vendor, or Salesman)
2. System automatically fetches and displays registered members for that entity type
3. User selects specific member from dropdown showing name and phone number
4. Form auto-populates entity ID and name fields
5. User completes transaction details and submits

#### Database Schema:
```sql
CREATE TABLE account_book (
    account_book_id BIGSERIAL PRIMARY KEY,
    entity_type VARCHAR(20) CHECK (entity_type IN ('customer', 'vendor', 'salesman')),
    entity_id BIGINT NOT NULL,
    entity_name VARCHAR(255) NOT NULL,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('buy', 'sell')),
    amount DECIMAL(15, 2) NOT NULL,
    description TEXT NOT NULL,
    reference VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

#### Components:
- **AccountBookController**: Manages all business logic and state including entity selection
- **AccountBookRepository**: Handles database operations and entity fetching for dropdowns
- **AccountBookModel**: Data model with proper validation
- **Responsive Screens**: Desktop, tablet, and mobile optimized layouts
- **Summary Cards**: Financial overview widgets
- **Data Table**: Sortable and filterable transaction table
- **Mobile Cards**: Touch-friendly mobile interface
- **Entity Selection Dialog**: Improved dialog with smart dropdown selection

#### Repository Methods:
- `fetchCustomersForSelection()`: Retrieves customer list for dropdown
- `fetchVendorsForSelection()`: Retrieves vendor list for dropdown  
- `fetchSalesmenForSelection()`: Retrieves salesman list for dropdown
- All methods return formatted data with ID, name, and phone number

### Purchase Management System

The application includes a comprehensive purchase management system that handles both regular and serialized products:

#### Purchase Features:
- **Product Selection**: Interactive product search with autocomplete functionality
- **Serialized Product Support**: Special handling for products with serial numbers
- **Variant Selection Popup**: Animated popup dialog for selecting specific serial numbers
- **Stock Management**: Automatic stock updates when purchases are received or cancelled
- **Vendor Integration**: Full vendor management with address and contact details
- **Unit Price & Quantity Management**: Flexible pricing and quantity handling
- **Merge Functionality**: Option to merge identical products in the same purchase
- **Payment Tracking**: Partial payment support with remaining balance calculation
- **Status Management**: Purchase status tracking (pending, received, cancelled)

#### Product Variant System:
The application now uses a comprehensive variant system instead of serial numbers:

1. **Product Variants**: Products can have multiple variants (e.g., Pepsi 1L, 1.5L, 2.25L)
2. **Variant Batches**: Each variant can have multiple batches with different purchase/selling prices
3. **Stock Management**: Stock is managed through variant batches created during purchases
4. **Batch Tracking**: Each batch tracks buy price, sell price, vendor, purchase date, and available quantity

#### Variant Management Workflow:
1. **Create Product**: Standard product creation with basic information
2. **Add Variants**: Add different variants (sizes, colors, configurations) to the product
3. **Purchase Integration**: When purchases are received, variant batches are automatically created
4. **Stock Tracking**: Available quantities are tracked per batch with FIFO/LIFO options
5. **Sales Integration**: Sales reduce available quantities from specific batches
6. **Inventory Reports**: Real-time inventory tracking across all variants and batches

#### Purchase Integration:
- **Automatic Batch Creation**: When purchases are marked as "received", variant batches are created
- **Price Tracking**: Each batch maintains separate buy and sell prices
- **Vendor Information**: Batches track which vendor supplied the stock
- **Quantity Management**: Available quantities are updated based on sales
- **Stock Synchronization**: Product stock quantities are automatically calculated from variant batches

#### Components:
- **ProductController**: Enhanced with variant and batch management
- **VariantBatchesRepository**: New repository for managing variant batches
- **ProductVariantsWidget**: UI for managing product variants
- **Purchase Integration**: Automatic variant batch creation during purchase processing
- **Stock Management**: Real-time stock updates based on variant batch availability
- **Animation Support**: Smooth animations for popup dialogs and state transitions

#### Database Schema Updates:
- Purchase items table includes `variant_id` field for serialized products
- Variant status tracking for available/sold states
- Automatic stock quantity updates based on available variants

#### Key Features:
- **Real-time Validation**: Prevents adding sold or invalid variants
- **Error Handling**: Comprehensive error messages for invalid selections
- **Focus Management**: Proper tab order and focus handling for improved UX
- **Responsive Design**: Popup adapts to different screen sizes
- **State Management**: Reactive state updates using GetX observables
- **Separated Concerns**: Product detail screen shows read-only variants, purchase screen handles variant creation
- **Bulk Import**: CSV support for importing multiple variants at once
- **Database Integration**: Automatic saving of variants to database on purchase completion

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

### Order Status Change Validation with Stock Availability Check (Latest Fix)

**Issue Fixed**: A critical bug where changing order status from "cancelled" to active status (pending/completed) would subtract stock without checking availability first.

**Problem**: 
1. Order with "completed" status gets changed to "cancelled" → stock is restored
2. Restocked products get sold to new customers → stock decreases 
3. Original order status changed from "cancelled" to "pending/completed" → system tries to subtract stock again without checking availability
4. This could result in negative stock quantities or attempting to mark already-sold serial products as sold

**Solution Implemented**:
- Added `checkStockAvailability()` method in `OrderRepository` that validates stock before status changes
- For regular products: Checks if current stock >= required quantity
- For serialized products: Checks if specific variants are available (not already sold)
- Added stock validation in `OrderController.updateStatus()` before allowing status change from cancelled to active
- If stock check fails, shows error message and prevents status change

**Technical Details**:
```dart
// New validation in OrderController.updateStatus()
if (originalStatus == 'cancelled' && status != 'cancelled') {
  bool hasStock = await orderRepository.checkStockAvailability(orderItems);
  if (!hasStock) {
    // Show error and prevent status change
    return originalStatus;
  }
  // Only proceed if stock is available
  await addBackQuantity(orderItems);
}
```

**Files Modified**:
- `lib/repositories/order/order_repository.dart`: Added `checkStockAvailability()` method
- `lib/controllers/orders/orders_controller.dart`: Added stock validation in `updateStatus()` method

### Dashboard Pending Amount Calculation for Installment Orders (Latest Fix)

**Issue Fixed**: The dashboard's order status count calculation was incorrectly calculating pending amounts for installment orders by not including margin, document charges, and other charges.

**Problem**: The `calculateOrderStatusCounts` method in `DashboardController` was only considering:
- Order subtotal
- Tax
- Shipping fee
- Salesman commission

**Missing Components for Installment Orders**:
- Margin amount (calculated as percentage of financed amount)
- Document charges
- Other charges

**Solution Implemented**:
- Added `_calculateOrderTotalAmount()` helper method that properly calculates total amount for both regular and installment orders
- For installment orders, the method fetches the installment plan and includes all relevant charges
- Updated `calculateOrderStatusCounts()` to use the corrected total amount calculation
- Ensures pending amounts accurately reflect what customers actually owe

**Technical Details**:
```dart
// New helper method calculates proper total including installment charges
Future<double> _calculateOrderTotalAmount(OrderModel order) async {
  // For installment orders, fetch plan and add:
  // - Document charges
  // - Other charges  
  // - Margin amount (percentage of financed amount after down payment)
  // Returns accurate total amount owed
}
```

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

## Report Management System

The application now includes comprehensive reporting capabilities with multiple specialized reports:

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

### 3. Account Book Report by Entity
- **Purpose**: Generate detailed account book reports for specific entities (customers, vendors, salesmen) within a date range
- **Features**:
  - **Entity Selection**: Smart dropdown selection that auto-populates based on selected entity type
  - **Date Range Filter**: Flexible date range selection using Syncfusion date picker
  - **Transaction Summary**: Visual summary cards showing total incoming, outgoing, and net balance
  - **Detailed Transaction List**: Complete transaction history with dates, types, amounts, references, and descriptions
  - **Running Balance**: Shows cumulative balance for each transaction
  - **Professional PDF Export**: Generates comprehensive PDF reports with company branding
  - **Responsive Design**: Optimized for desktop, tablet, and mobile viewing

#### Account Book Report Features:
- **Interactive Dialog**: User-friendly dialog for selecting entity type, specific entity, and date range
- **Real-time Validation**: Ensures only valid entities and date ranges are selected
- **Visual Indicators**: Clear icons and color coding for incoming (green) and outgoing (red) transactions
- **Multi-page PDF Support**: Automatically handles large datasets with proper pagination
- **Empty State Handling**: Graceful handling when no transactions are found for the selected criteria
- **Entity Integration**: Direct integration with existing customer, vendor, and salesman data

#### Technical Implementation:
```dart
// Report Controller Method
await reportController.showAccountBookReportByEntity(
  selectedEntity,
  entityType,
  startDate,
  endDate,
);

// Repository Method for Data Fetching
Future<List<AccountBookModel>> fetchAccountBookByEntity({
  required int entityId,
  required String entityType,
  required DateTime startDate,
  required DateTime endDate,
})
```

#### Report Components:
- **AccountBookReportDialog**: Entity and date selection interface
- **AccountBookReportPage**: Report display and PDF generation
- **ReportsRepository**: Backend data fetching with proper filtering
- **ReportController**: Business logic and navigation management

## Installment Payment Flow

The application implements a comprehensive installment payment system that automatically tracks and updates order payment status:

### When Creating an Installment-Based Order:
1. **Advance Payment Recording**: When an installment plan is saved, the advance payment (down payment) is automatically recorded in the order's `paid_amount` field
2. **Plan Creation**: The installment plan and payment schedule are created and linked to the order
3. **Initial Status**: The order maintains a running total of all payments received

### When Processing Installment Payments:
1. **Payment Processing**: When an installment payment is made through the installment table interface
2. **Order Update**: The payment amount is automatically added to the order's `paid_amount` field in the database
3. **Status Tracking**: The system maintains accurate payment tracking across both installment records and order records
4. **Completion Handling**: When all installments are paid, the order status is automatically updated to "completed"

### Technical Implementation:
- **Controller Integration**: The `InstallmentController` now integrates with `OrderController` to update order payments
- **Database Consistency**: Payment amounts are recorded in both the installment_payments table and the orders table
- **Real-time Updates**: The UI reflects payment updates immediately across all relevant screens
- **Automatic Calculations**: Running totals and remaining balances are calculated automatically

### Database Schema

#### User Management
The application uses a custom `public.users` table for user management:

```sql
CREATE TABLE public.users (
  phone_number text null default ''::text,
  pfp text null,
  user_id integer generated by default as identity not null,
  first_name text not null default ''::text,
  last_name text null default ''::text,
  email text not null default ''::text,
  constraint users_pkey primary key (user_id)
);
```

**Foreign Key References**: 
- `orders.user_id` → `public.users(user_id)`
- `purchases.user_id` → `public.users(user_id)`

#### Purchase Management
The system includes complete purchase management from vendors:

```sql
-- Purchases table
CREATE TABLE purchases (
    purchase_id BIGSERIAL PRIMARY KEY,
    purchase_date DATE NOT NULL DEFAULT CURRENT_DATE,
    sub_total DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    address_id BIGINT REFERENCES addresses(address_id),
    user_id INTEGER REFERENCES public.users(user_id),
    paid_amount DECIMAL(15, 2) DEFAULT 0.00,
    vendor_id BIGINT REFERENCES vendors(vendor_id),
    discount DECIMAL(15, 2) DEFAULT 0.00,
    tax DECIMAL(15, 2) DEFAULT 0.00,
    shipping_fee DECIMAL(15, 2) DEFAULT 0.00
);

-- Purchase items table
CREATE TABLE purchase_items (
    purchase_item_id BIGSERIAL PRIMARY KEY,
    purchase_id BIGINT NOT NULL REFERENCES purchases(purchase_id),
    product_id BIGINT NOT NULL REFERENCES products(product_id),
    variant_id BIGINT REFERENCES product_variants(variant_id),
    price DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit VARCHAR(50)
);
```

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