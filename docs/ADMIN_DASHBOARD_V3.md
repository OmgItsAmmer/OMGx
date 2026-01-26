# Flutter Admin Dashboard

A comprehensive admin dashboard for business management built with Flutter and Supabase.

![Admin Dashboard](/assets/logos/logo.png)

## Features

- **Authentication**: Secure login system using Supabase
- **Dashboard**: Analytics overview with visualizations using fl_chart
- **Order Management**: Track and manage customer orders
- **Product Management**: CRUD operations for products with comprehensive variant system
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

#### Serialized Product Workflow:
1. **Product Selection**: When a serialized product is selected from the product search bar
2. **Popup Display**: An animated popup appears showing all available serial numbers
3. **Variant Selection**: User selects a specific serial number with purchase and selling prices displayed
4. **Price Population**: Unit price and total price are automatically populated from the selected variant
5. **Quantity Locked**: Quantity is automatically set to 1 for serialized products
6. **Visual Indicator**: A visual indicator shows the selected serialized product with variant details
7. **Stock Integration**: Selected variants are properly tracked and removed from available inventory

#### Purchase Components:
- **PurchaseSalesController**: Main controller handling purchase logic and serialized product popup
- **PurchaseProductSearchBar**: Enhanced product search with serialized product detection
- **Serialized Product Popup**: Animated dialog for variant selection with visual feedback
- **Purchase Table**: Displays purchase items with support for both regular and serialized products
- **Visual Indicators**: Clear indicators when serialized products are selected
- **Stock Management**: Automatic inventory updates for serialized products

#### Backend Integration:
- **Variant Repository**: Handles marking variants as available/sold
- **Purchase Repository**: Manages purchase creation and stock updates
- **Product Controller**: Integrates with variant management for stock tracking
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

### Enhanced Variant Purchase System

The application now includes a comprehensive variant purchase system that allows users to purchase specific quantities of individual product variants. This system provides a more granular approach to inventory management and purchasing.

#### Key Features:
- **Product Variant Selection**: When a product is selected, all available variants are automatically loaded and displayed
- **Individual Variant Purchase**: Users can select specific variants and specify quantities for each
- **Pricing Flexibility**: Each variant can have different purchase prices set during the transaction
- **Batch Purchase**: Multiple variants can be selected and added to cart simultaneously
- **Real-time Calculations**: Total quantities and amounts are calculated in real-time
- **Smart Validation**: Prevents duplicate selections and validates quantities

#### Workflow:
1. **Product Selection**: User selects a product from the search dropdown
2. **Variant Loading**: System automatically loads all available variants for the selected product
3. **Variant Display**: Variants are shown in an expandable, interactive interface
4. **Variant Selection**: User can select variants using checkboxes and expand for details
5. **Quantity & Price Input**: For each selected variant, user can specify quantity and purchase price
6. **Total Calculation**: System calculates total items and amount in real-time
7. **Cart Addition**: Selected variants are added to cart as individual line items
8. **Purchase Completion**: Standard purchase flow continues with vendor and payment details

#### Components:
- **PurchaseProductSearchBar**: Enhanced to handle variant loading on product selection
- **VariantSelectionWidget**: New comprehensive widget for variant selection and management
- **Enhanced Controllers**: Updated PurchaseSalesController with variant-specific methods
- **Responsive Design**: Variant selection works across desktop, tablet, and mobile devices

#### Controller Methods:
- `loadAvailableVariants()`: Loads all variants for a selected product
- `selectVariantForPurchase()`: Adds a variant to the selection with quantity and price
- `removeVariantFromPurchase()`: Removes a variant from selection
- `addSelectedVariantsToCart()`: Adds all selected variants to the purchase cart
- `getTotalSelectedVariantQuantity()`: Calculates total quantity of selected variants
- `getTotalSelectedVariantAmount()`: Calculates total amount of selected variants
- `clearVariantSelection()`: Clears all variant selections

#### User Interface Features:
- **Checkbox Selection**: Easy selection/deselection of variants
- **Expandable Details**: Click to expand and see quantity/price inputs
- **Visual Indicators**: Clear indication of selected variants with counts and totals
- **Validation Feedback**: Real-time validation with error messages
- **Summary Display**: Shows total selected items and amount
- **Action Buttons**: Clear selection and add to cart functionality
- **Responsive Layout**: Optimized for all device sizes

#### Backend Integration:
- **Stock Management**: Automatic stock updates when variants are purchased
- **Variant Creation**: Support for creating new variants during purchase process
- **Database Consistency**: Ensures variant IDs are properly tracked in purchase items
- **Repository Methods**: Leverages existing variant repository for stock operations

#### Benefits:
1. **Granular Control**: Purchase specific quantities of individual variants
2. **Pricing Flexibility**: Set different purchase prices per variant per transaction
3. **Improved Workflow**: Streamlined process for variant-based purchasing
4. **Better Inventory**: More accurate inventory tracking per variant
5. **User Experience**: Intuitive interface with clear visual feedback
6. **Scalability**: Supports products with unlimited variants

### Product Variant Management System

The application has been completely transformed from a serial-number based product system to a comprehensive variant management system. This change affects all aspects of product management and provides much more flexibility.

#### System Overview:
- **Universal Variants**: Every product now requires at least one variant
- **No Serial Numbers**: Replaced serial number system with flexible variant names
- **Multiple Variants**: Products can have unlimited variants with different properties
- **Stock Tracking**: Individual stock tracking per variant
- **Pricing Flexibility**: Each variant has its own buy and sell prices
- **Visibility Control**: Variants can be hidden/shown from customer-facing interfaces

#### Variant Properties:
Each product variant includes:
- **Variant Name**: Descriptive name (e.g., "Red Large", "Blue Medium", "Standard")
- **SKU**: Unique Stock Keeping Unit identifier (auto-generated if not provided)
- **Buy Price**: Purchase/cost price for the variant
- **Sell Price**: Selling price for customers
- **Stock**: Current inventory quantity (read-only for new variants)
- **Visibility**: Boolean flag to show/hide from customer interfaces

#### Variant Management Features:
- **Add/Edit/Delete**: Full CRUD operations for product variants
- **Auto-SKU Generation**: Automatic SKU creation using product name and variant name
- **Validation**: Comprehensive validation including duplicate SKU checking
- **Stock Summary**: Real-time calculation of total product stock from all variants
- **Visual Interface**: Clean table-based interface with action buttons
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

#### Implementation Changes:

**Models Updated**:
- `ProductVariantModel`: Completely redesigned with new fields
- `ProductModel`: Removed `hasSerialNumbers` field (now implicit)

**Controller Changes**:
- Removed all serial-specific logic from `ProductController`
- Added variant-specific methods: `addVariantToUnsaved()`, `saveUnsavedVariants()`
- Implemented stock calculation from variant totals
- Added validation for minimum one variant requirement

**Repository Enhancements**:
- `ProductVariantsRepository`: New methods for variant management
- `fetchVisibleVariants()`: Get customer-facing variants only
- `updateVariantStock()`: Individual variant stock updates
- `isSkuExists()`: SKU uniqueness validation
- `calculateProductStock()`: Sum total stock from all variants

**UI Components**:
- `ProductVariantsWidget`: Comprehensive variant management interface
- `ExtraImages`: Multi-image management with featured image support
- Updated all responsive screens (desktop, tablet, mobile)

#### Database Schema:
```sql
CREATE TABLE product_variants (
  variant_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_name VARCHAR(255) NOT NULL,
  buy_price DECIMAL(10, 2) NOT NULL,
  sell_price DECIMAL(10, 2) NOT NULL,
  is_visible BOOLEAN DEFAULT TRUE,
  sku VARCHAR(255) UNIQUE NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE
);
```

#### Multi-Image Support:
- **Featured Images**: One main image per product using `isFeatured` flag
- **Additional Images**: Unlimited extra images for products
- **Image Management**: Add, remove, and set featured images through intuitive interface
- **Grid Display**: Visual grid showing all product images with management actions

#### Benefits of New System:
1. **Flexibility**: Support for any product configuration (size, color, material, etc.)
2. **Scalability**: No longer limited by serial number constraints
3. **User-Friendly**: Clear variant names instead of cryptic serial numbers
4. **Inventory Control**: Precise stock tracking per variant
5. **Business Logic**: Better pricing strategies with variant-specific prices
6. **Customer Experience**: Hide/show variants based on availability or marketing needs

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

### Product Images Table

```sql
CREATE TABLE product_images (
  image_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_id INTEGER,
  image_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product_images_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
  CONSTRAINT fk_product_images_variant
    FOREIGN KEY(variant_id)
      REFERENCES product_variants(variant_id)
      ON DELETE CASCADE
);
```

### Address Table

```sql
CREATE TABLE public.addresses (
  address_id integer generated by default as identity not null,
  shipping_address text null default ''::text,
  phone_number text null default ''::text,
  postal_code text null default ''::text,
  city text null default ''::text,
  country text null default ''::text,
  full_name text not null,
  customer_id integer null,
  vendor_id integer null,
  salesman_id integer null,
  user_id integer null,
  constraint addresses_pkey primary key (address_id),
  constraint addresses_customer_id_fkey foreign KEY (customer_id) references customers (customer_id) on update CASCADE on delete CASCADE,
  constraint addresses_salesman_id_fkey foreign KEY (salesman_id) references salesman (salesman_id) on update CASCADE on delete CASCADE,
  constraint addresses_user_id_fkey foreign KEY (user_id) references users (user_id) on update CASCADE on delete CASCADE,
  constraint addresses_vendor_id_fkey foreign KEY (vendor_id) references vendors (vendor_id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
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

#### Serialized Product Workflow:
1. **Product Selection**: When a serialized product is selected from the product search bar
2. **Popup Display**: An animated popup appears showing all available serial numbers
3. **Variant Selection**: User selects a specific serial number with purchase and selling prices displayed
4. **Price Population**: Unit price and total price are automatically populated from the selected variant
5. **Quantity Locked**: Quantity is automatically set to 1 for serialized products
6. **Visual Indicator**: A visual indicator shows the selected serialized product with variant details
7. **Stock Integration**: Selected variants are properly tracked and removed from available inventory

#### Purchase Components:
- **PurchaseSalesController**: Main controller handling purchase logic and serialized product popup
- **PurchaseProductSearchBar**: Enhanced product search with serialized product detection
- **Serialized Product Popup**: Animated dialog for variant selection with visual feedback
- **Purchase Table**: Displays purchase items with support for both regular and serialized products
- **Visual Indicators**: Clear indicators when serialized products are selected
- **Stock Management**: Automatic inventory updates for serialized products

#### Backend Integration:
- **Variant Repository**: Handles marking variants as available/sold
- **Purchase Repository**: Manages purchase creation and stock updates
- **Product Controller**: Integrates with variant management for stock tracking
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

### Enhanced Variant Purchase System

The application now includes a comprehensive variant purchase system that allows users to purchase specific quantities of individual product variants. This system provides a more granular approach to inventory management and purchasing.

#### Key Features:
- **Product Variant Selection**: When a product is selected, all available variants are automatically loaded and displayed
- **Individual Variant Purchase**: Users can select specific variants and specify quantities for each
- **Pricing Flexibility**: Each variant can have different purchase prices set during the transaction
- **Batch Purchase**: Multiple variants can be selected and added to cart simultaneously
- **Real-time Calculations**: Total quantities and amounts are calculated in real-time
- **Smart Validation**: Prevents duplicate selections and validates quantities

#### Workflow:
1. **Product Selection**: User selects a product from the search dropdown
2. **Variant Loading**: System automatically loads all available variants for the selected product
3. **Variant Display**: Variants are shown in an expandable, interactive interface
4. **Variant Selection**: User can select variants using checkboxes and expand for details
5. **Quantity & Price Input**: For each selected variant, user can specify quantity and purchase price
6. **Total Calculation**: System calculates total items and amount in real-time
7. **Cart Addition**: Selected variants are added to cart as individual line items
8. **Purchase Completion**: Standard purchase flow continues with vendor and payment details

#### Components:
- **PurchaseProductSearchBar**: Enhanced to handle variant loading on product selection
- **VariantSelectionWidget**: New comprehensive widget for variant selection and management
- **Enhanced Controllers**: Updated PurchaseSalesController with variant-specific methods
- **Responsive Design**: Variant selection works across desktop, tablet, and mobile devices

#### Controller Methods:
- `loadAvailableVariants()`: Loads all variants for a selected product
- `selectVariantForPurchase()`: Adds a variant to the selection with quantity and price
- `removeVariantFromPurchase()`: Removes a variant from selection
- `addSelectedVariantsToCart()`: Adds all selected variants to the purchase cart
- `getTotalSelectedVariantQuantity()`: Calculates total quantity of selected variants
- `getTotalSelectedVariantAmount()`: Calculates total amount of selected variants
- `clearVariantSelection()`: Clears all variant selections

#### User Interface Features:
- **Checkbox Selection**: Easy selection/deselection of variants
- **Expandable Details**: Click to expand and see quantity/price inputs
- **Visual Indicators**: Clear indication of selected variants with counts and totals
- **Validation Feedback**: Real-time validation with error messages
- **Summary Display**: Shows total selected items and amount
- **Action Buttons**: Clear selection and add to cart functionality
- **Responsive Layout**: Optimized for all device sizes

#### Backend Integration:
- **Stock Management**: Automatic stock updates when variants are purchased
- **Variant Creation**: Support for creating new variants during purchase process
- **Database Consistency**: Ensures variant IDs are properly tracked in purchase items
- **Repository Methods**: Leverages existing variant repository for stock operations

#### Benefits:
1. **Granular Control**: Purchase specific quantities of individual variants
2. **Pricing Flexibility**: Set different purchase prices per variant per transaction
3. **Improved Workflow**: Streamlined process for variant-based purchasing
4. **Better Inventory**: More accurate inventory tracking per variant
5. **User Experience**: Intuitive interface with clear visual feedback
6. **Scalability**: Supports products with unlimited variants

### Product Variant Management System

The application has been completely transformed from a serial-number based product system to a comprehensive variant management system. This change affects all aspects of product management and provides much more flexibility.

#### System Overview:
- **Universal Variants**: Every product now requires at least one variant
- **No Serial Numbers**: Replaced serial number system with flexible variant names
- **Multiple Variants**: Products can have unlimited variants with different properties
- **Stock Tracking**: Individual stock tracking per variant
- **Pricing Flexibility**: Each variant has its own buy and sell prices
- **Visibility Control**: Variants can be hidden/shown from customer-facing interfaces

#### Variant Properties:
Each product variant includes:
- **Variant Name**: Descriptive name (e.g., "Red Large", "Blue Medium", "Standard")
- **SKU**: Unique Stock Keeping Unit identifier (auto-generated if not provided)
- **Buy Price**: Purchase/cost price for the variant
- **Sell Price**: Selling price for customers
- **Stock**: Current inventory quantity (read-only for new variants)
- **Visibility**: Boolean flag to show/hide from customer interfaces

#### Variant Management Features:
- **Add/Edit/Delete**: Full CRUD operations for product variants
- **Auto-SKU Generation**: Automatic SKU creation using product name and variant name
- **Validation**: Comprehensive validation including duplicate SKU checking
- **Stock Summary**: Real-time calculation of total product stock from all variants
- **Visual Interface**: Clean table-based interface with action buttons
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

#### Implementation Changes:

**Models Updated**:
- `ProductVariantModel`: Completely redesigned with new fields
- `ProductModel`: Removed `hasSerialNumbers` field (now implicit)

**Controller Changes**:
- Removed all serial-specific logic from `ProductController`
- Added variant-specific methods: `addVariantToUnsaved()`, `saveUnsavedVariants()`
- Implemented stock calculation from variant totals
- Added validation for minimum one variant requirement

**Repository Enhancements**:
- `ProductVariantsRepository`: New methods for variant management
- `fetchVisibleVariants()`: Get customer-facing variants only
- `updateVariantStock()`: Individual variant stock updates
- `isSkuExists()`: SKU uniqueness validation
- `calculateProductStock()`: Sum total stock from all variants

**UI Components**:
- `ProductVariantsWidget`: Comprehensive variant management interface
- `ExtraImages`: Multi-image management with featured image support
- Updated all responsive screens (desktop, tablet, mobile)

#### Database Schema:
```sql
CREATE TABLE product_variants (
  variant_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_name VARCHAR(255) NOT NULL,
  buy_price DECIMAL(10, 2) NOT NULL,
  sell_price DECIMAL(10, 2) NOT NULL,
  is_visible BOOLEAN DEFAULT TRUE,
  sku VARCHAR(255) UNIQUE NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE
);
```

#### Multi-Image Support:
- **Featured Images**: One main image per product using `isFeatured` flag
- **Additional Images**: Unlimited extra images for products
- **Image Management**: Add, remove, and set featured images through intuitive interface
- **Grid Display**: Visual grid showing all product images with management actions

#### Benefits of New System:
1. **Flexibility**: Support for any product configuration (size, color, material, etc.)
2. **Scalability**: No longer limited by serial number constraints
3. **User-Friendly**: Clear variant names instead of cryptic serial numbers
4. **Inventory Control**: Precise stock tracking per variant
5. **Business Logic**: Better pricing strategies with variant-specific prices
6. **Customer Experience**: Hide/show variants based on availability or marketing needs

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

### Product Images Table

```sql
CREATE TABLE product_images (
  image_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_id INTEGER,
  image_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product_images_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
  CONSTRAINT fk_product_images_variant
    FOREIGN KEY(variant_id)
      REFERENCES product_variants(variant_id)
      ON DELETE CASCADE
);
```

### Address Table

```sql
CREATE TABLE public.addresses (
  address_id integer generated by default as identity not null,
  shipping_address text null default ''::text,
  phone_number text null default ''::text,
  postal_code text null default ''::text,
  city text null default ''::text,
  country text null default ''::text,
  full_name text not null,
  customer_id integer null,
  vendor_id integer null,
  salesman_id integer null,
  user_id integer null,
  constraint addresses_pkey primary key (address_id),
  constraint addresses_customer_id_fkey foreign KEY (customer_id) references customers (customer_id) on update CASCADE on delete CASCADE,
  constraint addresses_salesman_id_fkey foreign KEY (salesman_id) references salesman (salesman_id) on update CASCADE on delete CASCADE,
  constraint addresses_user_id_fkey foreign KEY (user_id) references users (user_id) on update CASCADE on delete CASCADE,
  constraint addresses_vendor_id_fkey foreign KEY (vendor_id) references vendors (vendor_id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
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

#### Serialized Product Workflow:
1. **Product Selection**: When a serialized product is selected from the product search bar
2. **Popup Display**: An animated popup appears showing all available serial numbers
3. **Variant Selection**: User selects a specific serial number with purchase and selling prices displayed
4. **Price Population**: Unit price and total price are automatically populated from the selected variant
5. **Quantity Locked**: Quantity is automatically set to 1 for serialized products
6. **Visual Indicator**: A visual indicator shows the selected serialized product with variant details
7. **Stock Integration**: Selected variants are properly tracked and removed from available inventory

#### Purchase Components:
- **PurchaseSalesController**: Main controller handling purchase logic and serialized product popup
- **PurchaseProductSearchBar**: Enhanced product search with serialized product detection
- **Serialized Product Popup**: Animated dialog for variant selection with visual feedback
- **Purchase Table**: Displays purchase items with support for both regular and serialized products
- **Visual Indicators**: Clear indicators when serialized products are selected
- **Stock Management**: Automatic inventory updates for serialized products

#### Backend Integration:
- **Variant Repository**: Handles marking variants as available/sold
- **Purchase Repository**: Manages purchase creation and stock updates
- **Product Controller**: Integrates with variant management for stock tracking
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

### Enhanced Variant Purchase System

The application now includes a comprehensive variant purchase system that allows users to purchase specific quantities of individual product variants. This system provides a more granular approach to inventory management and purchasing.

#### Key Features:
- **Product Variant Selection**: When a product is selected, all available variants are automatically loaded and displayed
- **Individual Variant Purchase**: Users can select specific variants and specify quantities for each
- **Pricing Flexibility**: Each variant can have different purchase prices set during the transaction
- **Batch Purchase**: Multiple variants can be selected and added to cart simultaneously
- **Real-time Calculations**: Total quantities and amounts are calculated in real-time
- **Smart Validation**: Prevents duplicate selections and validates quantities

#### Workflow:
1. **Product Selection**: User selects a product from the search dropdown
2. **Variant Loading**: System automatically loads all available variants for the selected product
3. **Variant Display**: Variants are shown in an expandable, interactive interface
4. **Variant Selection**: User can select variants using checkboxes and expand for details
5. **Quantity & Price Input**: For each selected variant, user can specify quantity and purchase price
6. **Total Calculation**: System calculates total items and amount in real-time
7. **Cart Addition**: Selected variants are added to cart as individual line items
8. **Purchase Completion**: Standard purchase flow continues with vendor and payment details

#### Components:
- **PurchaseProductSearchBar**: Enhanced to handle variant loading on product selection
- **VariantSelectionWidget**: New comprehensive widget for variant selection and management
- **Enhanced Controllers**: Updated PurchaseSalesController with variant-specific methods
- **Responsive Design**: Variant selection works across desktop, tablet, and mobile devices

#### Controller Methods:
- `loadAvailableVariants()`: Loads all variants for a selected product
- `selectVariantForPurchase()`: Adds a variant to the selection with quantity and price
- `removeVariantFromPurchase()`: Removes a variant from selection
- `addSelectedVariantsToCart()`: Adds all selected variants to the purchase cart
- `getTotalSelectedVariantQuantity()`: Calculates total quantity of selected variants
- `getTotalSelectedVariantAmount()`: Calculates total amount of selected variants
- `clearVariantSelection()`: Clears all variant selections

#### User Interface Features:
- **Checkbox Selection**: Easy selection/deselection of variants
- **Expandable Details**: Click to expand and see quantity/price inputs
- **Visual Indicators**: Clear indication of selected variants with counts and totals
- **Validation Feedback**: Real-time validation with error messages
- **Summary Display**: Shows total selected items and amount
- **Action Buttons**: Clear selection and add to cart functionality
- **Responsive Layout**: Optimized for all device sizes

#### Backend Integration:
- **Stock Management**: Automatic stock updates when variants are purchased
- **Variant Creation**: Support for creating new variants during purchase process
- **Database Consistency**: Ensures variant IDs are properly tracked in purchase items
- **Repository Methods**: Leverages existing variant repository for stock operations

#### Benefits:
1. **Granular Control**: Purchase specific quantities of individual variants
2. **Pricing Flexibility**: Set different purchase prices per variant per transaction
3. **Improved Workflow**: Streamlined process for variant-based purchasing
4. **Better Inventory**: More accurate inventory tracking per variant
5. **User Experience**: Intuitive interface with clear visual feedback
6. **Scalability**: Supports products with unlimited variants

### Product Variant Management System

The application has been completely transformed from a serial-number based product system to a comprehensive variant management system. This change affects all aspects of product management and provides much more flexibility.

#### System Overview:
- **Universal Variants**: Every product now requires at least one variant
- **No Serial Numbers**: Replaced serial number system with flexible variant names
- **Multiple Variants**: Products can have unlimited variants with different properties
- **Stock Tracking**: Individual stock tracking per variant
- **Pricing Flexibility**: Each variant has its own buy and sell prices
- **Visibility Control**: Variants can be hidden/shown from customer-facing interfaces

#### Variant Properties:
Each product variant includes:
- **Variant Name**: Descriptive name (e.g., "Red Large", "Blue Medium", "Standard")
- **SKU**: Unique Stock Keeping Unit identifier (auto-generated if not provided)
- **Buy Price**: Purchase/cost price for the variant
- **Sell Price**: Selling price for customers
- **Stock**: Current inventory quantity (read-only for new variants)
- **Visibility**: Boolean flag to show/hide from customer interfaces

#### Variant Management Features:
- **Add/Edit/Delete**: Full CRUD operations for product variants
- **Auto-SKU Generation**: Automatic SKU creation using product name and variant name
- **Validation**: Comprehensive validation including duplicate SKU checking
- **Stock Summary**: Real-time calculation of total product stock from all variants
- **Visual Interface**: Clean table-based interface with action buttons
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

#### Implementation Changes:

**Models Updated**:
- `ProductVariantModel`: Completely redesigned with new fields
- `ProductModel`: Removed `hasSerialNumbers` field (now implicit)

**Controller Changes**:
- Removed all serial-specific logic from `ProductController`
- Added variant-specific methods: `addVariantToUnsaved()`, `saveUnsavedVariants()`
- Implemented stock calculation from variant totals
- Added validation for minimum one variant requirement

**Repository Enhancements**:
- `ProductVariantsRepository`: New methods for variant management
- `fetchVisibleVariants()`: Get customer-facing variants only
- `updateVariantStock()`: Individual variant stock updates
- `isSkuExists()`: SKU uniqueness validation
- `calculateProductStock()`: Sum total stock from all variants

**UI Components**:
- `ProductVariantsWidget`: Comprehensive variant management interface
- `ExtraImages`: Multi-image management with featured image support
- Updated all responsive screens (desktop, tablet, mobile)

#### Database Schema:
```sql
CREATE TABLE product_variants (
  variant_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_name VARCHAR(255) NOT NULL,
  buy_price DECIMAL(10, 2) NOT NULL,
  sell_price DECIMAL(10, 2) NOT NULL,
  is_visible BOOLEAN DEFAULT TRUE,
  sku VARCHAR(255) UNIQUE NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE
);
```

#### Multi-Image Support:
- **Featured Images**: One main image per product using `isFeatured` flag
- **Additional Images**: Unlimited extra images for products
- **Image Management**: Add, remove, and set featured images through intuitive interface
- **Grid Display**: Visual grid showing all product images with management actions

#### Benefits of New System:
1. **Flexibility**: Support for any product configuration (size, color, material, etc.)
2. **Scalability**: No longer limited by serial number constraints
3. **User-Friendly**: Clear variant names instead of cryptic serial numbers
4. **Inventory Control**: Precise stock tracking per variant
5. **Business Logic**: Better pricing strategies with variant-specific prices
6. **Customer Experience**: Hide/show variants based on availability or marketing needs

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

### Product Images Table

```sql
CREATE TABLE product_images (
  image_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_id INTEGER,
  image_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product_images_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
  CONSTRAINT fk_product_images_variant
    FOREIGN KEY(variant_id)
      REFERENCES product_variants(variant_id)
      ON DELETE CASCADE
);
```

### Address Table

```sql
CREATE TABLE public.addresses (
  address_id integer generated by default as identity not null,
  shipping_address text null default ''::text,
  phone_number text null default ''::text,
  postal_code text null default ''::text,
  city text null default ''::text,
  country text null default ''::text,
  full_name text not null,
  customer_id integer null,
  vendor_id integer null,
  salesman_id integer null,
  user_id integer null,
  constraint addresses_pkey primary key (address_id),
  constraint addresses_customer_id_fkey foreign KEY (customer_id) references customers (customer_id) on update CASCADE on delete CASCADE,
  constraint addresses_salesman_id_fkey foreign KEY (salesman_id) references salesman (salesman_id) on update CASCADE on delete CASCADE,
  constraint addresses_user_id_fkey foreign KEY (user_id) references users (user_id) on update CASCADE on delete CASCADE,
  constraint addresses_vendor_id_fkey foreign KEY (vendor_id) references vendors (vendor_id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
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

#### Serialized Product Workflow:
1. **Product Selection**: When a serialized product is selected from the product search bar
2. **Popup Display**: An animated popup appears showing all available serial numbers
3. **Variant Selection**: User selects a specific serial number with purchase and selling prices displayed
4. **Price Population**: Unit price and total price are automatically populated from the selected variant
5. **Quantity Locked**: Quantity is automatically set to 1 for serialized products
6. **Visual Indicator**: A visual indicator shows the selected serialized product with variant details
7. **Stock Integration**: Selected variants are properly tracked and removed from available inventory

#### Purchase Components:
- **PurchaseSalesController**: Main controller handling purchase logic and serialized product popup
- **PurchaseProductSearchBar**: Enhanced product search with serialized product detection
- **Serialized Product Popup**: Animated dialog for variant selection with visual feedback
- **Purchase Table**: Displays purchase items with support for both regular and serialized products
- **Visual Indicators**: Clear indicators when serialized products are selected
- **Stock Management**: Automatic inventory updates for serialized products

#### Backend Integration:
- **Variant Repository**: Handles marking variants as available/sold
- **Purchase Repository**: Manages purchase creation and stock updates
- **Product Controller**: Integrates with variant management for stock tracking
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

### Enhanced Variant Purchase System

The application now includes a comprehensive variant purchase system that allows users to purchase specific quantities of individual product variants. This system provides a more granular approach to inventory management and purchasing.

#### Key Features:
- **Product Variant Selection**: When a product is selected, all available variants are automatically loaded and displayed
- **Individual Variant Purchase**: Users can select specific variants and specify quantities for each
- **Pricing Flexibility**: Each variant can have different purchase prices set during the transaction
- **Batch Purchase**: Multiple variants can be selected and added to cart simultaneously
- **Real-time Calculations**: Total quantities and amounts are calculated in real-time
- **Smart Validation**: Prevents duplicate selections and validates quantities

#### Workflow:
1. **Product Selection**: User selects a product from the search dropdown
2. **Variant Loading**: System automatically loads all available variants for the selected product
3. **Variant Display**: Variants are shown in an expandable, interactive interface
4. **Variant Selection**: User can select variants using checkboxes and expand for details
5. **Quantity & Price Input**: For each selected variant, user can specify quantity and purchase price
6. **Total Calculation**: System calculates total items and amount in real-time
7. **Cart Addition**: Selected variants are added to cart as individual line items
8. **Purchase Completion**: Standard purchase flow continues with vendor and payment details

#### Components:
- **PurchaseProductSearchBar**: Enhanced to handle variant loading on product selection
- **VariantSelectionWidget**: New comprehensive widget for variant selection and management
- **Enhanced Controllers**: Updated PurchaseSalesController with variant-specific methods
- **Responsive Design**: Variant selection works across desktop, tablet, and mobile devices

#### Controller Methods:
- `loadAvailableVariants()`: Loads all variants for a selected product
- `selectVariantForPurchase()`: Adds a variant to the selection with quantity and price
- `removeVariantFromPurchase()`: Removes a variant from selection
- `addSelectedVariantsToCart()`: Adds all selected variants to the purchase cart
- `getTotalSelectedVariantQuantity()`: Calculates total quantity of selected variants
- `getTotalSelectedVariantAmount()`: Calculates total amount of selected variants
- `clearVariantSelection()`: Clears all variant selections

#### User Interface Features:
- **Checkbox Selection**: Easy selection/deselection of variants
- **Expandable Details**: Click to expand and see quantity/price inputs
- **Visual Indicators**: Clear indication of selected variants with counts and totals
- **Validation Feedback**: Real-time validation with error messages
- **Summary Display**: Shows total selected items and amount
- **Action Buttons**: Clear selection and add to cart functionality
- **Responsive Layout**: Optimized for all device sizes

#### Backend Integration:
- **Stock Management**: Automatic stock updates when variants are purchased
- **Variant Creation**: Support for creating new variants during purchase process
- **Database Consistency**: Ensures variant IDs are properly tracked in purchase items
- **Repository Methods**: Leverages existing variant repository for stock operations

#### Benefits:
1. **Granular Control**: Purchase specific quantities of individual variants
2. **Pricing Flexibility**: Set different purchase prices per variant per transaction
3. **Improved Workflow**: Streamlined process for variant-based purchasing
4. **Better Inventory**: More accurate inventory tracking per variant
5. **User Experience**: Intuitive interface with clear visual feedback
6. **Scalability**: Supports products with unlimited variants

### Product Variant Management System

The application has been completely transformed from a serial-number based product system to a comprehensive variant management system. This change affects all aspects of product management and provides much more flexibility.

#### System Overview:
- **Universal Variants**: Every product now requires at least one variant
- **No Serial Numbers**: Replaced serial number system with flexible variant names
- **Multiple Variants**: Products can have unlimited variants with different properties
- **Stock Tracking**: Individual stock tracking per variant
- **Pricing Flexibility**: Each variant has its own buy and sell prices
- **Visibility Control**: Variants can be hidden/shown from customer-facing interfaces

#### Variant Properties:
Each product variant includes:
- **Variant Name**: Descriptive name (e.g., "Red Large", "Blue Medium", "Standard")
- **SKU**: Unique Stock Keeping Unit identifier (auto-generated if not provided)
- **Buy Price**: Purchase/cost price for the variant
- **Sell Price**: Selling price for customers
- **Stock**: Current inventory quantity (read-only for new variants)
- **Visibility**: Boolean flag to show/hide from customer interfaces

#### Variant Management Features:
- **Add/Edit/Delete**: Full CRUD operations for product variants
- **Auto-SKU Generation**: Automatic SKU creation using product name and variant name
- **Validation**: Comprehensive validation including duplicate SKU checking
- **Stock Summary**: Real-time calculation of total product stock from all variants
- **Visual Interface**: Clean table-based interface with action buttons
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

#### Implementation Changes:

**Models Updated**:
- `ProductVariantModel`: Completely redesigned with new fields
- `ProductModel`: Removed `hasSerialNumbers` field (now implicit)

**Controller Changes**:
- Removed all serial-specific logic from `ProductController`
- Added variant-specific methods: `addVariantToUnsaved()`, `saveUnsavedVariants()`
- Implemented stock calculation from variant totals
- Added validation for minimum one variant requirement

**Repository Enhancements**:
- `ProductVariantsRepository`: New methods for variant management
- `fetchVisibleVariants()`: Get customer-facing variants only
- `updateVariantStock()`: Individual variant stock updates
- `isSkuExists()`: SKU uniqueness validation
- `calculateProductStock()`: Sum total stock from all variants

**UI Components**:
- `ProductVariantsWidget`: Comprehensive variant management interface
- `ExtraImages`: Multi-image management with featured image support
- Updated all responsive screens (desktop, tablet, mobile)

#### Database Schema:
```sql
CREATE TABLE product_variants (
  variant_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_name VARCHAR(255) NOT NULL,
  buy_price DECIMAL(10, 2) NOT NULL,
  sell_price DECIMAL(10, 2) NOT NULL,
  is_visible BOOLEAN DEFAULT TRUE,
  sku VARCHAR(255) UNIQUE NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE
);
```

#### Multi-Image Support:
- **Featured Images**: One main image per product using `isFeatured` flag
- **Additional Images**: Unlimited extra images for products
- **Image Management**: Add, remove, and set featured images through intuitive interface
- **Grid Display**: Visual grid showing all product images with management actions

#### Benefits of New System:
1. **Flexibility**: Support for any product configuration (size, color, material, etc.)
2. **Scalability**: No longer limited by serial number constraints
3. **User-Friendly**: Clear variant names instead of cryptic serial numbers
4. **Inventory Control**: Precise stock tracking per variant
5. **Business Logic**: Better pricing strategies with variant-specific prices
6. **Customer Experience**: Hide/show variants based on availability or marketing needs

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

### Product Images Table

```sql
CREATE TABLE product_images (
  image_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_id INTEGER,
  image_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product_images_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
  CONSTRAINT fk_product_images_variant
    FOREIGN KEY(variant_id)
      REFERENCES product_variants(variant_id)
      ON DELETE CASCADE
);
```

### Address Table

```sql
CREATE TABLE public.addresses (
  address_id integer generated by default as identity not null,
  shipping_address text null default ''::text,
  phone_number text null default ''::text,
  postal_code text null default ''::text,
  city text null default ''::text,
  country text null default ''::text,
  full_name text not null,
  customer_id integer null,
  vendor_id integer null,
  salesman_id integer null,
  user_id integer null,
  constraint addresses_pkey primary key (address_id),
  constraint addresses_customer_id_fkey foreign KEY (customer_id) references customers (customer_id) on update CASCADE on delete CASCADE,
  constraint addresses_salesman_id_fkey foreign KEY (salesman_id) references salesman (salesman_id) on update CASCADE on delete CASCADE,
  constraint addresses_user_id_fkey foreign KEY (user_id) references users (user_id) on update CASCADE on delete CASCADE,
  constraint addresses_vendor_id_fkey foreign KEY (vendor_id) references vendors (vendor_id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
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

#### Serialized Product Workflow:
1. **Product Selection**: When a serialized product is selected from the product search bar
2. **Popup Display**: An animated popup appears showing all available serial numbers
3. **Variant Selection**: User selects a specific serial number with purchase and selling prices displayed
4. **Price Population**: Unit price and total price are automatically populated from the selected variant
5. **Quantity Locked**: Quantity is automatically set to 1 for serialized products
6. **Visual Indicator**: A visual indicator shows the selected serialized product with variant details
7. **Stock Integration**: Selected variants are properly tracked and removed from available inventory

#### Purchase Components:
- **PurchaseSalesController**: Main controller handling purchase logic and serialized product popup
- **PurchaseProductSearchBar**: Enhanced product search with serialized product detection
- **Serialized Product Popup**: Animated dialog for variant selection with visual feedback
- **Purchase Table**: Displays purchase items with support for both regular and serialized products
- **Visual Indicators**: Clear indicators when serialized products are selected
- **Stock Management**: Automatic inventory updates for serialized products

#### Backend Integration:
- **Variant Repository**: Handles marking variants as available/sold
- **Purchase Repository**: Manages purchase creation and stock updates
- **Product Controller**: Integrates with variant management for stock tracking
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

### Enhanced Variant Purchase System

The application now includes a comprehensive variant purchase system that allows users to purchase specific quantities of individual product variants. This system provides a more granular approach to inventory management and purchasing.

#### Key Features:
- **Product Variant Selection**: When a product is selected, all available variants are automatically loaded and displayed
- **Individual Variant Purchase**: Users can select specific variants and specify quantities for each
- **Pricing Flexibility**: Each variant can have different purchase prices set during the transaction
- **Batch Purchase**: Multiple variants can be selected and added to cart simultaneously
- **Real-time Calculations**: Total quantities and amounts are calculated in real-time
- **Smart Validation**: Prevents duplicate selections and validates quantities

#### Workflow:
1. **Product Selection**: User selects a product from the search dropdown
2. **Variant Loading**: System automatically loads all available variants for the selected product
3. **Variant Display**: Variants are shown in an expandable, interactive interface
4. **Variant Selection**: User can select variants using checkboxes and expand for details
5. **Quantity & Price Input**: For each selected variant, user can specify quantity and purchase price
6. **Total Calculation**: System calculates total items and amount in real-time
7. **Cart Addition**: Selected variants are added to cart as individual line items
8. **Purchase Completion**: Standard purchase flow continues with vendor and payment details

#### Components:
- **PurchaseProductSearchBar**: Enhanced to handle variant loading on product selection
- **VariantSelectionWidget**: New comprehensive widget for variant selection and management
- **Enhanced Controllers**: Updated PurchaseSalesController with variant-specific methods
- **Responsive Design**: Variant selection works across desktop, tablet, and mobile devices

#### Controller Methods:
- `loadAvailableVariants()`: Loads all variants for a selected product
- `selectVariantForPurchase()`: Adds a variant to the selection with quantity and price
- `removeVariantFromPurchase()`: Removes a variant from selection
- `addSelectedVariantsToCart()`: Adds all selected variants to the purchase cart
- `getTotalSelectedVariantQuantity()`: Calculates total quantity of selected variants
- `getTotalSelectedVariantAmount()`: Calculates total amount of selected variants
- `clearVariantSelection()`: Clears all variant selections

#### User Interface Features:
- **Checkbox Selection**: Easy selection/deselection of variants
- **Expandable Details**: Click to expand and see quantity/price inputs
- **Visual Indicators**: Clear indication of selected variants with counts and totals
- **Validation Feedback**: Real-time validation with error messages
- **Summary Display**: Shows total selected items and amount
- **Action Buttons**: Clear selection and add to cart functionality
- **Responsive Layout**: Optimized for all device sizes

#### Backend Integration:
- **Stock Management**: Automatic stock updates when variants are purchased
- **Variant Creation**: Support for creating new variants during purchase process
- **Database Consistency**: Ensures variant IDs are properly tracked in purchase items
- **Repository Methods**: Leverages existing variant repository for stock operations

#### Benefits:
1. **Granular Control**: Purchase specific quantities of individual variants
2. **Pricing Flexibility**: Set different purchase prices per variant per transaction
3. **Improved Workflow**: Streamlined process for variant-based purchasing
4. **Better Inventory**: More accurate inventory tracking per variant
5. **User Experience**: Intuitive interface with clear visual feedback
6. **Scalability**: Supports products with unlimited variants

### Product Variant Management System

The application has been completely transformed from a serial-number based product system to a comprehensive variant management system. This change affects all aspects of product management and provides much more flexibility.

#### System Overview:
- **Universal Variants**: Every product now requires at least one variant
- **No Serial Numbers**: Replaced serial number system with flexible variant names
- **Multiple Variants**: Products can have unlimited variants with different properties
- **Stock Tracking**: Individual stock tracking per variant
- **Pricing Flexibility**: Each variant has its own buy and sell prices
- **Visibility Control**: Variants can be hidden/shown from customer-facing interfaces

#### Variant Properties:
Each product variant includes:
- **Variant Name**: Descriptive name (e.g., "Red Large", "Blue Medium", "Standard")
- **SKU**: Unique Stock Keeping Unit identifier (auto-generated if not provided)
- **Buy Price**: Purchase/cost price for the variant
- **Sell Price**: Selling price for customers
- **Stock**: Current inventory quantity (read-only for new variants)
- **Visibility**: Boolean flag to show/hide from customer interfaces

#### Variant Management Features:
- **Add/Edit/Delete**: Full CRUD operations for product variants
- **Auto-SKU Generation**: Automatic SKU creation using product name and variant name
- **Validation**: Comprehensive validation including duplicate SKU checking
- **Stock Summary**: Real-time calculation of total product stock from all variants
- **Visual Interface**: Clean table-based interface with action buttons
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

#### Implementation Changes:

**Models Updated**:
- `ProductVariantModel`: Completely redesigned with new fields
- `ProductModel`: Removed `hasSerialNumbers` field (now implicit)

**Controller Changes**:
- Removed all serial-specific logic from `ProductController`
- Added variant-specific methods: `addVariantToUnsaved()`, `saveUnsavedVariants()`
- Implemented stock calculation from variant totals
- Added validation for minimum one variant requirement

**Repository Enhancements**:
- `ProductVariantsRepository`: New methods for variant management
- `fetchVisibleVariants()`: Get customer-facing variants only
- `updateVariantStock()`: Individual variant stock updates
- `isSkuExists()`: SKU uniqueness validation
- `calculateProductStock()`: Sum total stock from all variants

**UI Components**:
- `ProductVariantsWidget`: Comprehensive variant management interface
- `ExtraImages`: Multi-image management with featured image support
- Updated all responsive screens (desktop, tablet, mobile)

#### Database Schema:
```sql
CREATE TABLE product_variants (
  variant_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_name VARCHAR(255) NOT NULL,
  buy_price DECIMAL(10, 2) NOT NULL,
  sell_price DECIMAL(10, 2) NOT NULL,
  is_visible BOOLEAN DEFAULT TRUE,
  sku VARCHAR(255) UNIQUE NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE
);
```

#### Multi-Image Support:
- **Featured Images**: One main image per product using `isFeatured` flag
- **Additional Images**: Unlimited extra images for products
- **Image Management**: Add, remove, and set featured images through intuitive interface
- **Grid Display**: Visual grid showing all product images with management actions

#### Benefits of New System:
1. **Flexibility**: Support for any product configuration (size, color, material, etc.)
2. **Scalability**: No longer limited by serial number constraints
3. **User-Friendly**: Clear variant names instead of cryptic serial numbers
4. **Inventory Control**: Precise stock tracking per variant
5. **Business Logic**: Better pricing strategies with variant-specific prices
6. **Customer Experience**: Hide/show variants based on availability or marketing needs

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

### Product Images Table

```sql
CREATE TABLE product_images (
  image_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_id INTEGER,
  image_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product_images_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
  CONSTRAINT fk_product_images_variant
    FOREIGN KEY(variant_id)
      REFERENCES product_variants(variant_id)
      ON DELETE CASCADE
);
```

### Address Table

```sql
CREATE TABLE public.addresses (
  address_id integer generated by default as identity not null,
  shipping_address text null default ''::text,
  phone_number text null default ''::text,
  postal_code text null default ''::text,
  city text null default ''::text,
  country text null default ''::text,
  full_name text not null,
  customer_id integer null,
  vendor_id integer null,
  salesman_id integer null,
  user_id integer null,
  constraint addresses_pkey primary key (address_id),
  constraint addresses_customer_id_fkey foreign KEY (customer_id) references customers (customer_id) on update CASCADE on delete CASCADE,
  constraint addresses_salesman_id_fkey foreign KEY (salesman_id) references salesman (salesman_id) on update CASCADE on delete CASCADE,
  constraint addresses_user_id_fkey foreign KEY (user_id) references users (user_id) on update CASCADE on delete CASCADE,
  constraint addresses_vendor_id_fkey foreign KEY (vendor_id) references vendors (vendor_id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
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

#### Serialized Product Workflow:
1. **Product Selection**: When a serialized product is selected from the product search bar
2. **Popup Display**: An animated popup appears showing all available serial numbers
3. **Variant Selection**: User selects a specific serial number with purchase and selling prices displayed
4. **Price Population**: Unit price and total price are automatically populated from the selected variant
5. **Quantity Locked**: Quantity is automatically set to 1 for serialized products
6. **Visual Indicator**: A visual indicator shows the selected serialized product with variant details
7. **Stock Integration**: Selected variants are properly tracked and removed from available inventory

#### Purchase Components:
- **PurchaseSalesController**: Main controller handling purchase logic and serialized product popup
- **PurchaseProductSearchBar**: Enhanced product search with serialized product detection
- **Serialized Product Popup**: Animated dialog for variant selection with visual feedback
- **Purchase Table**: Displays purchase items with support for both regular and serialized products
- **Visual Indicators**: Clear indicators when serialized products are selected
- **Stock Management**: Automatic inventory updates for serialized products

#### Backend Integration:
- **Variant Repository**: Handles marking variants as available/sold
- **Purchase Repository**: Manages purchase creation and stock updates
- **Product Controller**: Integrates with variant management for stock tracking
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

### Enhanced Variant Purchase System

The application now includes a comprehensive variant purchase system that allows users to purchase specific quantities of individual product variants. This system provides a more granular approach to inventory management and purchasing.

#### Key Features:
- **Product Variant Selection**: When a product is selected, all available variants are automatically loaded and displayed
- **Individual Variant Purchase**: Users can select specific variants and specify quantities for each
- **Pricing Flexibility**: Each variant can have different purchase prices set during the transaction
- **Batch Purchase**: Multiple variants can be selected and added to cart simultaneously
- **Real-time Calculations**: Total quantities and amounts are calculated in real-time
- **Smart Validation**: Prevents duplicate selections and validates quantities

#### Workflow:
1. **Product Selection**: User selects a product from the search dropdown
2. **Variant Loading**: System automatically loads all available variants for the selected product
3. **Variant Display**: Variants are shown in an expandable, interactive interface
4. **Variant Selection**: User can select variants using checkboxes and expand for details
5. **Quantity & Price Input**: For each selected variant, user can specify quantity and purchase price
6. **Total Calculation**: System calculates total items and amount in real-time
7. **Cart Addition**: Selected variants are added to cart as individual line items
8. **Purchase Completion**: Standard purchase flow continues with vendor and payment details

#### Components:
- **PurchaseProductSearchBar**: Enhanced to handle variant loading on product selection
- **VariantSelectionWidget**: New comprehensive widget for variant selection and management
- **Enhanced Controllers**: Updated PurchaseSalesController with variant-specific methods
- **Responsive Design**: Variant selection works across desktop, tablet, and mobile devices

#### Controller Methods:
- `loadAvailableVariants()`: Loads all variants for a selected product
- `selectVariantForPurchase()`: Adds a variant to the selection with quantity and price
- `removeVariantFromPurchase()`: Removes a variant from selection
- `addSelectedVariantsToCart()`: Adds all selected variants to the purchase cart
- `getTotalSelectedVariantQuantity()`: Calculates total quantity of selected variants
- `getTotalSelectedVariantAmount()`: Calculates total amount of selected variants
- `clearVariantSelection()`: Clears all variant selections

#### User Interface Features:
- **Checkbox Selection**: Easy selection/deselection of variants
- **Expandable Details**: Click to expand and see quantity/price inputs
- **Visual Indicators**: Clear indication of selected variants with counts and totals
- **Validation Feedback**: Real-time validation with error messages
- **Summary Display**: Shows total selected items and amount
- **Action Buttons**: Clear selection and add to cart functionality
- **Responsive Layout**: Optimized for all device sizes

#### Backend Integration:
- **Stock Management**: Automatic stock updates when variants are purchased
- **Variant Creation**: Support for creating new variants during purchase process
- **Database Consistency**: Ensures variant IDs are properly tracked in purchase items
- **Repository Methods**: Leverages existing variant repository for stock operations

#### Benefits:
1. **Granular Control**: Purchase specific quantities of individual variants
2. **Pricing Flexibility**: Set different purchase prices per variant per transaction
3. **Improved Workflow**: Streamlined process for variant-based purchasing
4. **Better Inventory**: More accurate inventory tracking per variant
5. **User Experience**: Intuitive interface with clear visual feedback
6. **Scalability**: Supports products with unlimited variants

### Product Variant Management System

The application has been completely transformed from a serial-number based product system to a comprehensive variant management system. This change affects all aspects of product management and provides much more flexibility.

#### System Overview:
- **Universal Variants**: Every product now requires at least one variant
- **No Serial Numbers**: Replaced serial number system with flexible variant names
- **Multiple Variants**: Products can have unlimited variants with different properties
- **Stock Tracking**: Individual stock tracking per variant
- **Pricing Flexibility**: Each variant has its own buy and sell prices
- **Visibility Control**: Variants can be hidden/shown from customer-facing interfaces

#### Variant Properties:
Each product variant includes:
- **Variant Name**: Descriptive name (e.g., "Red Large", "Blue Medium", "Standard")
- **SKU**: Unique Stock Keeping Unit identifier (auto-generated if not provided)
- **Buy Price**: Purchase/cost price for the variant
- **Sell Price**: Selling price for customers
- **Stock**: Current inventory quantity (read-only for new variants)
- **Visibility**: Boolean flag to show/hide from customer interfaces

#### Variant Management Features:
- **Add/Edit/Delete**: Full CRUD operations for product variants
- **Auto-SKU Generation**: Automatic SKU creation using product name and variant name
- **Validation**: Comprehensive validation including duplicate SKU checking
- **Stock Summary**: Real-time calculation of total product stock from all variants
- **Visual Interface**: Clean table-based interface with action buttons
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

#### Implementation Changes:

**Models Updated**:
- `ProductVariantModel`: Completely redesigned with new fields
- `ProductModel`: Removed `hasSerialNumbers` field (now implicit)

**Controller Changes**:
- Removed all serial-specific logic from `ProductController`
- Added variant-specific methods: `addVariantToUnsaved()`, `saveUnsavedVariants()`
- Implemented stock calculation from variant totals
- Added validation for minimum one variant requirement

**Repository Enhancements**:
- `ProductVariantsRepository`: New methods for variant management
- `fetchVisibleVariants()`: Get customer-facing variants only
- `updateVariantStock()`: Individual variant stock updates
- `isSkuExists()`: SKU uniqueness validation
- `calculateProductStock()`: Sum total stock from all variants

**UI Components**:
- `ProductVariantsWidget`: Comprehensive variant management interface
- `ExtraImages`: Multi-image management with featured image support
- Updated all responsive screens (desktop, tablet, mobile)

#### Database Schema:
```sql
CREATE TABLE product_variants (
  variant_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_name VARCHAR(255) NOT NULL,
  buy_price DECIMAL(10, 2) NOT NULL,
  sell_price DECIMAL(10, 2) NOT NULL,
  is_visible BOOLEAN DEFAULT TRUE,
  sku VARCHAR(255) UNIQUE NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE
);
```

#### Multi-Image Support:
- **Featured Images**: One main image per product using `isFeatured` flag
- **Additional Images**: Unlimited extra images for products
- **Image Management**: Add, remove, and set featured images through intuitive interface
- **Grid Display**: Visual grid showing all product images with management actions

#### Benefits of New System:
1. **Flexibility**: Support for any product configuration (size, color, material, etc.)
2. **Scalability**: No longer limited by serial number constraints
3. **User-Friendly**: Clear variant names instead of cryptic serial numbers
4. **Inventory Control**: Precise stock tracking per variant
5. **Business Logic**: Better pricing strategies with variant-specific prices
6. **Customer Experience**: Hide/show variants based on availability or marketing needs

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

### Product Images Table

```sql
CREATE TABLE product_images (
  image_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_id INTEGER,
  image_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product_images_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
  CONSTRAINT fk_product_images_variant
    FOREIGN KEY(variant_id)
      REFERENCES product_variants(variant_id)
      ON DELETE CASCADE
);
```

### Address Table

```sql
CREATE TABLE public.addresses (
  address_id integer generated by default as identity not null,
  shipping_address text null default ''::text,
  phone_number text null default ''::text,
  postal_code text null default ''::text,
  city text null default ''::text,
  country text null default ''::text,
  full_name text not null,
  customer_id integer null,
  vendor_id integer null,
  salesman_id integer null,
  user_id integer null,
  constraint addresses_pkey primary key (address_id),
  constraint addresses_customer_id_fkey foreign KEY (customer_id) references customers (customer_id) on update CASCADE on delete CASCADE,
  constraint addresses_salesman_id_fkey foreign KEY (salesman_id) references salesman (salesman_id) on update CASCADE on delete CASCADE,
  constraint addresses_user_id_fkey foreign KEY (user_id) references users (user_id) on update CASCADE on delete CASCADE,
  constraint addresses_vendor_id_fkey foreign KEY (vendor_id) references vendors (vendor_id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
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

#### Serialized Product Workflow:
1. **Product Selection**: When a serialized product is selected from the product search bar
2. **Popup Display**: An animated popup appears showing all available serial numbers
3. **Variant Selection**: User selects a specific serial number with purchase and selling prices displayed
4. **Price Population**: Unit price and total price are automatically populated from the selected variant
5. **Quantity Locked**: Quantity is automatically set to 1 for serialized products
6. **Visual Indicator**: A visual indicator shows the selected serialized product with variant details
7. **Stock Integration**: Selected variants are properly tracked and removed from available inventory

#### Purchase Components:
- **PurchaseSalesController**: Main controller handling purchase logic and serialized product popup
- **PurchaseProductSearchBar**: Enhanced product search with serialized product detection
- **Serialized Product Popup**: Animated dialog for variant selection with visual feedback
- **Purchase Table**: Displays purchase items with support for both regular and serialized products
- **Visual Indicators**: Clear indicators when serialized products are selected
- **Stock Management**: Automatic inventory updates for serialized products

#### Backend Integration:
- **Variant Repository**: Handles marking variants as available/sold
- **Purchase Repository**: Manages purchase creation and stock updates
- **Product Controller**: Integrates with variant management for stock tracking
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

### Enhanced Variant Purchase System

The application now includes a comprehensive variant purchase system that allows users to purchase specific quantities of individual product variants. This system provides a more granular approach to inventory management and purchasing.

#### Key Features:
- **Product Variant Selection**: When a product is selected, all available variants are automatically loaded and displayed
- **Individual Variant Purchase**: Users can select specific variants and specify quantities for each
- **Pricing Flexibility**: Each variant can have different purchase prices set during the transaction
- **Batch Purchase**: Multiple variants can be selected and added to cart simultaneously
- **Real-time Calculations**: Total quantities and amounts are calculated in real-time
- **Smart Validation**: Prevents duplicate selections and validates quantities

#### Workflow:
1. **Product Selection**: User selects a product from the search dropdown
2. **Variant Loading**: System automatically loads all available variants for the selected product
3. **Variant Display**: Variants are shown in an expandable, interactive interface
4. **Variant Selection**: User can select variants using checkboxes and expand for details
5. **Quantity & Price Input**: For each selected variant, user can specify quantity and purchase price
6. **Total Calculation**: System calculates total items and amount in real-time
7. **Cart Addition**: Selected variants are added to cart as individual line items
8. **Purchase Completion**: Standard purchase flow continues with vendor and payment details

#### Components:
- **PurchaseProductSearchBar**: Enhanced to handle variant loading on product selection
- **VariantSelectionWidget**: New comprehensive widget for variant selection and management
- **Enhanced Controllers**: Updated PurchaseSalesController with variant-specific methods
- **Responsive Design**: Variant selection works across desktop, tablet, and mobile devices

#### Controller Methods:
- `loadAvailableVariants()`: Loads all variants for a selected product
- `selectVariantForPurchase()`: Adds a variant to the selection with quantity and price
- `removeVariantFromPurchase()`: Removes a variant from selection
- `addSelectedVariantsToCart()`: Adds all selected variants to the purchase cart
- `getTotalSelectedVariantQuantity()`: Calculates total quantity of selected variants
- `getTotalSelectedVariantAmount()`: Calculates total amount of selected variants
- `clearVariantSelection()`: Clears all variant selections

#### User Interface Features:
- **Checkbox Selection**: Easy selection/deselection of variants
- **Expandable Details**: Click to expand and see quantity/price inputs
- **Visual Indicators**: Clear indication of selected variants with counts and totals
- **Validation Feedback**: Real-time validation with error messages
- **Summary Display**: Shows total selected items and amount
- **Action Buttons**: Clear selection and add to cart functionality
- **Responsive Layout**: Optimized for all device sizes

#### Backend Integration:
- **Stock Management**: Automatic stock updates when variants are purchased
- **Variant Creation**: Support for creating new variants during purchase process
- **Database Consistency**: Ensures variant IDs are properly tracked in purchase items
- **Repository Methods**: Leverages existing variant repository for stock operations

#### Benefits:
1. **Granular Control**: Purchase specific quantities of individual variants
2. **Pricing Flexibility**: Set different purchase prices per variant per transaction
3. **Improved Workflow**: Streamlined process for variant-based purchasing
4. **Better Inventory**: More accurate inventory tracking per variant
5. **User Experience**: Intuitive interface with clear visual feedback
6. **Scalability**: Supports products with unlimited variants

### Product Variant Management System

The application has been completely transformed from a serial-number based product system to a comprehensive variant management system. This change affects all aspects of product management and provides much more flexibility.

#### System Overview:
- **Universal Variants**: Every product now requires at least one variant
- **No Serial Numbers**: Replaced serial number system with flexible variant names
- **Multiple Variants**: Products can have unlimited variants with different properties
- **Stock Tracking**: Individual stock tracking per variant
- **Pricing Flexibility**: Each variant has its own buy and sell prices
- **Visibility Control**: Variants can be hidden/shown from customer-facing interfaces

#### Variant Properties:
Each product variant includes:
- **Variant Name**: Descriptive name (e.g., "Red Large", "Blue Medium", "Standard")
- **SKU**: Unique Stock Keeping Unit identifier (auto-generated if not provided)
- **Buy Price**: Purchase/cost price for the variant
- **Sell Price**: Selling price for customers
- **Stock**: Current inventory quantity (read-only for new variants)
- **Visibility**: Boolean flag to show/hide from customer interfaces

#### Variant Management Features:
- **Add/Edit/Delete**: Full CRUD operations for product variants
- **Auto-SKU Generation**: Automatic SKU creation using product name and variant name
- **Validation**: Comprehensive validation including duplicate SKU checking
- **Stock Summary**: Real-time calculation of total product stock from all variants
- **Visual Interface**: Clean table-based interface with action buttons
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

#### Implementation Changes:

**Models Updated**:
- `ProductVariantModel`: Completely redesigned with new fields
- `ProductModel`: Removed `hasSerialNumbers` field (now implicit)

**Controller Changes**:
- Removed all serial-specific logic from `ProductController`
- Added variant-specific methods: `addVariantToUnsaved()`, `saveUnsavedVariants()`
- Implemented stock calculation from variant totals
- Added validation for minimum one variant requirement

**Repository Enhancements**:
- `ProductVariantsRepository`: New methods for variant management
- `fetchVisibleVariants()`: Get customer-facing variants only
- `updateVariantStock()`: Individual variant stock updates
- `isSkuExists()`: SKU uniqueness validation
- `calculateProductStock()`: Sum total stock from all variants

**UI Components**:
- `ProductVariantsWidget`: Comprehensive variant management interface
- `ExtraImages`: Multi-image management with featured image support
- Updated all responsive screens (desktop, tablet, mobile)

#### Database Schema:
```sql
CREATE TABLE product_variants (
  variant_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_name VARCHAR(255) NOT NULL,
  buy_price DECIMAL(10, 2) NOT NULL,
  sell_price DECIMAL(10, 2) NOT NULL,
  is_visible BOOLEAN DEFAULT TRUE,
  sku VARCHAR(255) UNIQUE NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE
);
```

#### Multi-Image Support:
- **Featured Images**: One main image per product using `isFeatured` flag
- **Additional Images**: Unlimited extra images for products
- **Image Management**: Add, remove, and set featured images through intuitive interface
- **Grid Display**: Visual grid showing all product images with management actions

#### Benefits of New System:
1. **Flexibility**: Support for any product configuration (size, color, material, etc.)
2. **Scalability**: No longer limited by serial number constraints
3. **User-Friendly**: Clear variant names instead of cryptic serial numbers
4. **Inventory Control**: Precise stock tracking per variant
5. **Business Logic**: Better pricing strategies with variant-specific prices
6. **Customer Experience**: Hide/show variants based on availability or marketing needs

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
  first_name text not null default ''::text,
  last_name text null default ''::text,
  phone_number text null default ''::text,
  email text not null default ''::text,
  dob timestamp with time zone null,
  created_at timestamp with time zone null default (now() AT TIME ZONE 'utc'::text),
  gender public.gender null,
  user_id integer generated by default as identity not null,
  auth_uid uuid null,
  constraint users_pkey primary key (user_id),
  constraint users_auth_uid_key unique (auth_uid),
  constraint users_email_key unique (email)
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

### Product Images Table

```sql
CREATE TABLE product_images (
  image_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_id INTEGER,
  image_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product_images_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
  CONSTRAINT fk_product_images_variant
    FOREIGN KEY(variant_id)
      REFERENCES product_variants(variant_id)
      ON DELETE CASCADE
);
```

### Address Table

```sql
CREATE TABLE public.addresses (
  address_id integer generated by default as identity not null,
  shipping_address text null default ''::text,
  phone_number text null default ''::text,
  postal_code text null default ''::text,
  city text null default ''::text,
  country text null default ''::text,
  full_name text not null,
  customer_id integer null,
  vendor_id integer null,
  salesman_id integer null,
  user_id integer null,
  constraint addresses_pkey primary key (address_id),
  constraint addresses_customer_id_fkey foreign KEY (customer_id) references customers (customer_id) on update CASCADE on delete CASCADE,
  constraint addresses_salesman_id_fkey foreign KEY (salesman_id) references salesman (salesman_id) on update CASCADE on delete CASCADE,
  constraint addresses_user_id_fkey foreign KEY (user_id) references users (user_id) on update CASCADE on delete CASCADE,
  constraint addresses_vendor_id_fkey foreign KEY (vendor_id) references vendors (vendor_id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
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

#### Serialized Product Workflow:
1. **Product Selection**: When a serialized product is selected from the product search bar
2. **Popup Display**: An animated popup appears showing all available serial numbers
3. **Variant Selection**: User selects a specific serial number with purchase and selling prices displayed
4. **Price Population**: Unit price and total price are automatically populated from the selected variant
5. **Quantity Locked**: Quantity is automatically set to 1 for serialized products
6. **Visual Indicator**: A visual indicator shows the selected serialized product with variant details
7. **Stock Integration**: Selected variants are properly tracked and removed from available inventory

#### Purchase Components:
- **PurchaseSalesController**: Main controller handling purchase logic and serialized product popup
- **PurchaseProductSearchBar**: Enhanced product search with serialized product detection
- **Serialized Product Popup**: Animated dialog for variant selection with visual feedback
- **Purchase Table**: Displays purchase items with support for both regular and serialized products
- **Visual Indicators**: Clear indicators when serialized products are selected
- **Stock Management**: Automatic inventory updates for serialized products

#### Backend Integration:
- **Variant Repository**: Handles marking variants as available/sold
- **Purchase Repository**: Manages purchase creation and stock updates
- **Product Controller**: Integrates with variant management for stock tracking
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

### Enhanced Variant Purchase System

The application now includes a comprehensive variant purchase system that allows users to purchase specific quantities of individual product variants. This system provides a more granular approach to inventory management and purchasing.

#### Key Features:
- **Product Variant Selection**: When a product is selected, all available variants are automatically loaded and displayed
- **Individual Variant Purchase**: Users can select specific variants and specify quantities for each
- **Pricing Flexibility**: Each variant can have different purchase prices set during the transaction
- **Batch Purchase**: Multiple variants can be selected and added to cart simultaneously
- **Real-time Calculations**: Total quantities and amounts are calculated in real-time
- **Smart Validation**: Prevents duplicate selections and validates quantities

#### Workflow:
1. **Product Selection**: User selects a product from the search dropdown
2. **Variant Loading**: System automatically loads all available variants for the selected product
3. **Variant Display**: Variants are shown in an expandable, interactive interface
4. **Variant Selection**: User can select variants using checkboxes and expand for details
5. **Quantity & Price Input**: For each selected variant, user can specify quantity and purchase price
6. **Total Calculation**: System calculates total items and amount in real-time
7. **Cart Addition**: Selected variants are added to cart as individual line items
8. **Purchase Completion**: Standard purchase flow continues with vendor and payment details

#### Components:
- **PurchaseProductSearchBar**: Enhanced to handle variant loading on product selection
- **VariantSelectionWidget**: New comprehensive widget for variant selection and management
- **Enhanced Controllers**: Updated PurchaseSalesController with variant-specific methods
- **Responsive Design**: Variant selection works across desktop, tablet, and mobile devices

#### Controller Methods:
- `loadAvailableVariants()`: Loads all variants for a selected product
- `selectVariantForPurchase()`: Adds a variant to the selection with quantity and price
- `removeVariantFromPurchase()`: Removes a variant from selection
- `addSelectedVariantsToCart()`: Adds all selected variants to the purchase cart
- `getTotalSelectedVariantQuantity()`: Calculates total quantity of selected variants
- `getTotalSelectedVariantAmount()`: Calculates total amount of selected variants
- `clearVariantSelection()`: Clears all variant selections

#### User Interface Features:
- **Checkbox Selection**: Easy selection/deselection of variants
- **Expandable Details**: Click to expand and see quantity/price inputs
- **Visual Indicators**: Clear indication of selected variants with counts and totals
- **Validation Feedback**: Real-time validation with error messages
- **Summary Display**: Shows total selected items and amount
- **Action Buttons**: Clear selection and add to cart functionality
- **Responsive Layout**: Optimized for all device sizes

#### Backend Integration:
- **Stock Management**: Automatic stock updates when variants are purchased
- **Variant Creation**: Support for creating new variants during purchase process
- **Database Consistency**: Ensures variant IDs are properly tracked in purchase items
- **Repository Methods**: Leverages existing variant repository for stock operations

#### Benefits:
1. **Granular Control**: Purchase specific quantities of individual variants
2. **Pricing Flexibility**: Set different purchase prices per variant per transaction
3. **Improved Workflow**: Streamlined process for variant-based purchasing
4. **Better Inventory**: More accurate inventory tracking per variant
5. **User Experience**: Intuitive interface with clear visual feedback
6. **Scalability**: Supports products with unlimited variants

### Product Variant Management System

The application has been completely transformed from a serial-number based product system to a comprehensive variant management system. This change affects all aspects of product management and provides much more flexibility.

#### System Overview:
- **Universal Variants**: Every product now requires at least one variant
- **No Serial Numbers**: Replaced serial number system with flexible variant names
- **Multiple Variants**: Products can have unlimited variants with different properties
- **Stock Tracking**: Individual stock tracking per variant
- **Pricing Flexibility**: Each variant has its own buy and sell prices
- **Visibility Control**: Variants can be hidden/shown from customer-facing interfaces

#### Variant Properties:
Each product variant includes:
- **Variant Name**: Descriptive name (e.g., "Red Large", "Blue Medium", "Standard")
- **SKU**: Unique Stock Keeping Unit identifier (auto-generated if not provided)
- **Buy Price**: Purchase/cost price for the variant
- **Sell Price**: Selling price for customers
- **Stock**: Current inventory quantity (read-only for new variants)
- **Visibility**: Boolean flag to show/hide from customer interfaces

#### Variant Management Features:
- **Add/Edit/Delete**: Full CRUD operations for product variants
- **Auto-SKU Generation**: Automatic SKU creation using product name and variant name
- **Validation**: Comprehensive validation including duplicate SKU checking
- **Stock Summary**: Real-time calculation of total product stock from all variants
- **Visual Interface**: Clean table-based interface with action buttons
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices

#### Implementation Changes:

**Models Updated**:
- `ProductVariantModel`: Completely redesigned with new fields
- `ProductModel`: Removed `hasSerialNumbers` field (now implicit)

**Controller Changes**:
- Removed all serial-specific logic from `ProductController`
- Added variant-specific methods: `addVariantToUnsaved()`, `saveUnsavedVariants()`
- Implemented stock calculation from variant totals
- Added validation for minimum one variant requirement

**Repository Enhancements**:
- `ProductVariantsRepository`: New methods for variant management
- `fetchVisibleVariants()`: Get customer-facing variants only
- `updateVariantStock()`: Individual variant stock updates
- `isSkuExists()`: SKU uniqueness validation
- `calculateProductStock()`: Sum total stock from all variants

**UI Components**:
- `ProductVariantsWidget`: Comprehensive variant management interface
- `ExtraImages`: Multi-image management with featured image support
- Updated all responsive screens (desktop, tablet, mobile)

#### Database Schema:
```sql
CREATE TABLE product_variants (
  variant_id BIGSERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  variant_name VARCHAR(255) NOT NULL,
  buy_price DECIMAL(10, 2) NOT NULL,
  sell_price DECIMAL(10, 2) NOT NULL,
  is_visible BOOLEAN DEFAULT TRUE,
  sku VARCHAR(255) UNIQUE NULL,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_product
    FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE
);
```

#### Multi-Image Support:
- **Featured Images**: One main image per product using `isFeatured` flag
- **Additional Images**: Unlimited extra images for products
- **Image Management**: Add, remove, and set featured images through intuitive interface
- **Grid Display**: Visual grid showing all product images with management actions

#### Benefits of New System:
1. **Flexibility**: Support for any product configuration (size, color, material, etc.)
2. **Scalability**: No longer limited by serial number constraints
3. **User-Friendly**: Clear variant names instead of cryptic serial numbers
4. **Inventory Control**: Precise stock tracking per variant
5. **Business Logic**: Better pricing strategies with variant-specific prices
6. **Customer Experience**: Hide/show variants based on availability or marketing needs

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