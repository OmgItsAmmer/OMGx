# Collections Module Documentation

## 📦 Overview

The **Collections Module** is a new feature that allows the e-commerce platform to bundle multiple products together as "collections" or "product bundles". Customers can purchase these collections with customizable variant selections and quantities for each item in the collection.

## 🎯 Purpose

Collections enable:
- **Bundled Product Sales**: Sell multiple related products together as a package
- **Flexible Product Selection**: Customers can choose variants (e.g., size, color) for each item
- **Quantity Customization**: Customers can adjust quantities for individual items within a collection
- **Dynamic Pricing**: Total price is calculated based on selected variants and quantities
- **Marketing Opportunities**: Feature premium bundles, starter packs, gift sets, etc.

---

## 🗄️ Database Schema

### 1. `collections` Table
Stores the main collection information.

| Column | Type | Description |
|--------|------|-------------|
| `collection_id` | SERIAL | Primary key |
| `name` | TEXT | Collection name (e.g., "Premium Starter Pack") |
| `description` | TEXT | Detailed description (optional) |
| `image_url` | TEXT | Main collection image URL |
| `is_active` | BOOLEAN | Whether collection is visible to customers |
| `is_featured` | BOOLEAN | Whether to show in hero section |
| `display_order` | INTEGER | Sort order for displaying collections |
| `created_at` | TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |

**Indexes:**
- `idx_collections_active` on `is_active`
- `idx_collections_featured` on `is_featured`
- `idx_collections_display_order` on `display_order`

---

### 2. `collection_items` Table
Links products (variants) to collections with default quantities.

| Column | Type | Description |
|--------|------|-------------|
| `collection_item_id` | SERIAL | Primary key |
| `collection_id` | INTEGER | References `collections(collection_id)` |
| `variant_id` | INTEGER | References `product_variants(variant_id)` |
| `default_quantity` | INTEGER | Default quantity for this item |
| `sort_order` | INTEGER | Display order within collection |
| `created_at` | TIMESTAMP | Creation timestamp |

**Constraints:**
- Foreign key: `collection_id` → `collections(collection_id)` ON DELETE CASCADE
- Foreign key: `variant_id` → `product_variants(variant_id)` ON DELETE CASCADE
- Check constraint: `default_quantity > 0`
- Unique constraint: `(collection_id, variant_id)` - prevents duplicate items

**Indexes:**
- `idx_collection_items_collection_id` on `collection_id`
- `idx_collection_items_variant_id` on `variant_id`
- `idx_collection_items_unique` unique on `(collection_id, variant_id)`

---

### 3. `collection_cart` Table
Stores collections added to customer carts.

| Column | Type | Description |
|--------|------|-------------|
| `collection_cart_id` | SERIAL | Primary key |
| `customer_id` | INTEGER | References `customers(customer_id)` |
| `collection_id` | INTEGER | References `collections(collection_id)` |
| `created_at` | TIMESTAMP | When added to cart |
| `updated_at` | TIMESTAMP | Last update timestamp |

**Constraints:**
- Foreign key: `customer_id` → `customers(customer_id)` ON DELETE CASCADE
- Foreign key: `collection_id` → `collections(collection_id)` ON DELETE CASCADE

**Indexes:**
- `idx_collection_cart_customer` on `customer_id`
- `idx_collection_cart_collection` on `collection_id`

---

### 4. `collection_cart_items` Table
Stores customized items within a collection cart entry.

| Column | Type | Description |
|--------|------|-------------|
| `collection_cart_item_id` | SERIAL | Primary key |
| `collection_cart_id` | INTEGER | References `collection_cart(collection_cart_id)` |
| `variant_id` | INTEGER | References `product_variants(variant_id)` |
| `quantity` | INTEGER | Customer's selected quantity |
| `created_at` | TIMESTAMP | Creation timestamp |

**Constraints:**
- Foreign key: `collection_cart_id` → `collection_cart(collection_cart_id)` ON DELETE CASCADE
- Foreign key: `variant_id` → `product_variants(variant_id)` ON DELETE CASCADE
- Check constraint: `quantity > 0`
- Unique constraint: `(collection_cart_id, variant_id)` - prevents duplicate items

**Indexes:**
- `idx_collection_cart_items_cart_id` on `collection_cart_id`
- `idx_collection_cart_items_variant_id` on `variant_id`
- `idx_collection_cart_items_unique` unique on `(collection_cart_id, variant_id)`

---

### 5. Database Views

#### `collections_summary`
Provides a quick overview of collections with aggregated data.

```sql
SELECT 
    c.collection_id,
    c.name,
    c.description,
    c.image_url,
    c.is_active,
    c.is_featured,
    c.display_order,
    c.created_at,
    c.updated_at,
    COUNT(ci.collection_item_id) AS item_count,
    SUM(pv.sell_price * ci.default_quantity) AS total_price
FROM collections c
LEFT JOIN collection_items ci ON c.collection_id = ci.collection_id
LEFT JOIN product_variants pv ON ci.variant_id = pv.variant_id
WHERE c.is_active = true
GROUP BY c.collection_id;
```

#### `collection_items_detail`
Shows collection items with full product details and images.

```sql
SELECT 
    ci.collection_item_id,
    ci.collection_id,
    ci.variant_id,
    ci.default_quantity,
    ci.sort_order,
    p.product_id,
    p.name AS product_name,
    p.description AS product_description,
    pv.variant_name,
    pv.sell_price,
    pv.stock,
    pv.is_visible,
    pv.sku,
    (SELECT image_url FROM images i INNER JOIN image_entity ie ON i.image_id = ie.image_id
     WHERE ie.entity_id = p.product_id AND ie.entity_category = 'products' 
     AND ie.isFeatured = true LIMIT 1) AS image_url
FROM collection_items ci
INNER JOIN product_variants pv ON ci.variant_id = pv.variant_id
INNER JOIN products p ON pv.product_id = p.product_id
WHERE pv.is_visible = true AND p.isVisible = true;
```

---

## 🔧 Backend Implementation

### API Endpoints

#### 1. **GET /api/v1/collections**
Get all active collections with pagination.

**Query Parameters:**
- `page` (optional, default: 1)
- `pageSize` (optional, default: 10)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "collection_id": 1,
      "name": "Premium Starter Pack",
      "description": "Everything you need to get started",
      "image_url": "/collections/premium-starter.jpg",
      "is_featured": true,
      "display_order": 1,
      "item_count": 5,
      "total_price": 49999
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 10,
    "total": 4,
    "totalPages": 1
  }
}
```

---

#### 2. **GET /api/v1/collections/featured**
Get featured collections for hero section.

**Query Parameters:**
- `limit` (optional, default: 7)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "collection_id": 1,
      "name": "Premium Starter Pack",
      "item_count": 5,
      "total_price": 49999,
      "image_url": "/collections/premium.jpg"
    }
  ]
}
```

---

#### 3. **GET /api/v1/collections/:id**
Get collection details with all items and variants.

**Response:**
```json
{
  "success": true,
  "data": {
    "collection_id": 1,
    "name": "Premium Starter Pack",
    "description": "Everything you need...",
    "image_url": "/collections/premium.jpg",
    "is_active": true,
    "items": [
      {
        "collection_item_id": 1,
        "variant_id": 15,
        "default_quantity": 2,
        "product_id": 5,
        "product_name": "Premium Mattress",
        "variant_name": "Queen Size",
        "sell_price": 15000,
        "stock": 10,
        "image_url": "/products/mattress.jpg",
        "all_variants": [
          {
            "variant_id": 14,
            "variant_name": "Twin Size",
            "sell_price": 12000,
            "stock": 15
          },
          {
            "variant_id": 15,
            "variant_name": "Queen Size",
            "sell_price": 15000,
            "stock": 10
          }
        ]
      }
    ],
    "total_price": 45000
  }
}
```

---

#### 4. **POST /api/v1/collections/:id/cart**
Add collection to cart with customized variants and quantities.

**Request Body:**
```json
{
  "customer_id": 123,
  "items": [
    {
      "variant_id": 15,
      "quantity": 2
    },
    {
      "variant_id": 28,
      "quantity": 1
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "collection_cart_id": 45,
    "message": "Collection added to cart"
  }
}
```

**Validations:**
- Collection must exist and be active
- All variants must exist and be visible
- Sufficient stock must be available
- Quantity must be positive

---

#### 5. **GET /api/v1/collections/cart/:customerId**
Get customer's collection cart items.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "collection_cart_id": 45,
      "collection_id": 1,
      "collection_name": "Premium Starter Pack",
      "collection_image": "/collections/premium.jpg",
      "variant_id": 15,
      "quantity": 2,
      "product_name": "Premium Mattress",
      "variant_name": "Queen Size",
      "sell_price": 15000,
      "stock": 10
    }
  ]
}
```

---

#### 6. **DELETE /api/v1/collections/cart/:cartId**
Remove collection from cart.

**Request Body:**
```json
{
  "customer_id": 123
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": "Collection removed from cart"
  }
}
```

---

#### 7. **POST /api/v1/collections/calculate-price**
Calculate total price for custom collection items.

**Request Body:**
```json
{
  "items": [
    {
      "variant_id": 15,
      "quantity": 2
    },
    {
      "variant_id": 28,
      "quantity": 1
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total_price": 45000
  }
}
```

---

## 🎨 Frontend Implementation

### 1. Hero Section Update
**File:** `react-frontend/src/components/HeroSection.tsx`

- **Changed From:** Displaying popular products
- **Changed To:** Displaying featured collections
- **Features:**
  - Shows up to 7 featured collections
  - 2 collections in side banners (top right)
  - 4 collections in bottom cards
  - Displays item count and total price
  - Clicking navigates to collection detail page

---

### 2. Collection Detail Page
**File:** `react-frontend/src/pages/CollectionDetail.tsx`

**Features:**
- **Collection Header**: Shows collection name, description, image, item count, and total price
- **Item List**: Displays all products in the collection with:
  - Product image and name
  - Variant selector dropdown (if multiple variants exist)
  - Quantity controls (+ / -)
  - Stock availability indicator
  - Individual item price calculation
- **Price Breakdown**: Shows subtotal and total
- **Action Buttons**:
  - **Add to Cart**: Adds collection to cart
  - **Checkout Now**: Adds to cart and navigates to checkout

**Edge Cases Handled:**
- ✅ Out of stock variants (disabled in dropdown)
- ✅ Stock validation when changing quantity
- ✅ Authentication required for cart operations
- ✅ Loading states for all async operations
- ✅ Error handling with user-friendly messages
- ✅ Real-time price calculation
- ✅ Prevents adding more than available stock

---

### 3. Custom React Hooks
**File:** `react-frontend/src/hooks/useCollections.ts`

Available hooks:
- `useFeaturedCollections(limit)` - Fetch featured collections
- `useCollections(page, pageSize)` - Fetch all collections with pagination
- `useCollectionDetails(collectionId)` - Fetch single collection with full details
- `useCollectionCart(customerId)` - Fetch customer's collection cart
- `useAddCollectionToCart()` - Mutation hook to add collection to cart
- `useRemoveCollectionFromCart()` - Mutation hook to remove from cart
- `useCalculateCollectionPrice()` - Calculate collection price

**Caching Strategy:**
- Featured collections: 5 minutes stale time, 10 minutes cache time
- Collection details: 10 minutes stale time, 30 minutes cache time
- Cart data: 1 minute stale time, 5 minutes cache time

---

### 4. Service Layer
**File:** `react-frontend/src/services/collection.service.ts`

Provides type-safe API methods:
- `getCollections(page, pageSize)`
- `getFeaturedCollections(limit)`
- `getCollectionById(collectionId)`
- `addToCart(collectionId, customerId, items)`
- `getCustomerCollectionCart(customerId)`
- `removeFromCart(collectionCartId, customerId)`
- `calculatePrice(items)`

---

## 🔑 Admin Management Guide

### Creating a Collection

1. **Insert Collection Record:**
```sql
INSERT INTO collections (name, description, image_url, is_featured, is_active, display_order)
VALUES (
    'Premium Starter Pack',
    'Everything you need to get started with our premium products',
    '/collections/premium-starter.jpg',
    true,
    true,
    1
);
```

2. **Add Items to Collection:**
```sql
-- First, find variant IDs from product_variants table
SELECT pv.variant_id, p.name as product_name, pv.variant_name, pv.sell_price
FROM product_variants pv
JOIN products p ON p.product_id = pv.product_id
WHERE p.isVisible = true AND pv.is_visible = true;

-- Then add items to the collection
INSERT INTO collection_items (collection_id, variant_id, default_quantity, sort_order)
VALUES
    (1, 15, 2, 1),  -- 2x Premium Mattress (Queen Size)
    (1, 28, 1, 2),  -- 1x Pillow Set
    (1, 35, 4, 3);  -- 4x Bed Sheets
```

---

### Updating a Collection

**Change collection details:**
```sql
UPDATE collections
SET 
    name = 'Updated Collection Name',
    description = 'New description',
    image_url = '/new-image.jpg',
    is_featured = false,
    updated_at = NOW()
WHERE collection_id = 1;
```

**Add/remove items:**
```sql
-- Add item
INSERT INTO collection_items (collection_id, variant_id, default_quantity, sort_order)
VALUES (1, 42, 1, 4);

-- Remove item
DELETE FROM collection_items
WHERE collection_id = 1 AND variant_id = 28;

-- Update item quantity
UPDATE collection_items
SET default_quantity = 3
WHERE collection_id = 1 AND variant_id = 15;
```

---

### Activating/Deactivating Collections

```sql
-- Deactivate (hide from customers)
UPDATE collections SET is_active = false WHERE collection_id = 1;

-- Activate (show to customers)
UPDATE collections SET is_active = true WHERE collection_id = 1;
```

---

### Managing Featured Collections

```sql
-- Feature a collection (shows in hero section)
UPDATE collections SET is_featured = true WHERE collection_id = 1;

-- Unfeature a collection
UPDATE collections SET is_featured = false WHERE collection_id = 1;

-- Set display order (lower numbers appear first)
UPDATE collections SET display_order = 1 WHERE collection_id = 1;
```

---

### Viewing Collection Analytics

**Get popular collections:**
```sql
SELECT 
    c.collection_id,
    c.name,
    COUNT(DISTINCT cc.customer_id) as times_added_to_cart,
    COUNT(DISTINCT cc.collection_cart_id) as unique_cart_entries
FROM collections c
LEFT JOIN collection_cart cc ON c.collection_id = cc.collection_id
GROUP BY c.collection_id, c.name
ORDER BY times_added_to_cart DESC;
```

**Get collection revenue potential:**
```sql
SELECT 
    c.collection_id,
    c.name,
    SUM(pv.sell_price * ci.default_quantity) as total_value,
    COUNT(ci.collection_item_id) as item_count
FROM collections c
JOIN collection_items ci ON c.collection_id = ci.collection_id
JOIN product_variants pv ON ci.variant_id = pv.variant_id
WHERE c.is_active = true
GROUP BY c.collection_id, c.name
ORDER BY total_value DESC;
```

---

## ⚠️ Important Considerations

### Stock Management
- **Collections do NOT reserve stock** when created
- Stock is validated when customer adds to cart
- If a variant goes out of stock, it will be disabled in the collection detail page
- Consider setting up stock alerts for products in popular collections

### Pricing Strategy
- Collection prices are calculated dynamically based on selected variants
- Price changes in `product_variants` table automatically reflect in collections
- No discounts or special pricing for collections (implement separately if needed)

### Image Management
- Upload collection images to your image storage (Supabase Storage or Cloudinary)
- Use consistent aspect ratios for better UI appearance
- Recommended size: 800x800px or larger

### Performance Optimization
- Collections are cached on frontend (5-10 minutes)
- Database uses indexes for fast queries
- Consider adding pagination if you have 50+ collections

---

## 🧪 Testing Checklist

### Backend Testing
- [ ] Create collection via SQL
- [ ] Add items to collection
- [ ] Fetch featured collections via API
- [ ] Fetch collection details via API
- [ ] Add collection to cart via API
- [ ] Verify stock validation works
- [ ] Test with out-of-stock variants
- [ ] Test with invalid collection IDs

### Frontend Testing
- [ ] Hero section displays collections
- [ ] Clicking collection navigates to detail page
- [ ] Variant selector shows all available variants
- [ ] Quantity controls work correctly
- [ ] Stock limits are enforced
- [ ] Price updates dynamically
- [ ] Add to cart works
- [ ] Authentication check works
- [ ] Error messages display correctly
- [ ] Loading states show properly

---

## 📝 Sample Data for Testing

```sql
-- Sample Collection
INSERT INTO collections (name, description, image_url, is_featured, is_active, display_order)
VALUES 
    ('Premium Starter Pack', 'Everything you need to get started', '/logo.png', true, true, 1),
    ('Essential Bundle', 'Most popular products bundled together', '/logo.png', true, true, 2),
    ('Luxury Collection', 'Indulge yourself with luxury', '/logo.png', true, true, 3);

-- Note: Add collection_items manually based on your actual variant_ids
-- Example:
-- INSERT INTO collection_items (collection_id, variant_id, default_quantity, sort_order)
-- VALUES (1, [your_variant_id], 1, 1);
```

---

## 🚀 Future Enhancements (Not Implemented)

- Collection-specific discounts (e.g., 10% off when buying as bundle)
- Collection recommendations based on user behavior
- Admin dashboard UI for managing collections
- Collection wishlist feature
- Collection reviews and ratings
- Time-limited collections (seasonal bundles)
- Gift wrapping options for collections
- Collection comparison feature

---

## 🔗 Related Files

**Backend:**
- `kksonline-backend-express/src/repositories/collection.repository.ts`
- `kksonline-backend-express/src/routes/collection.routes.ts`
- `kksonline-backend-express/src/routes/index.ts`

**Frontend:**
- `react-frontend/src/hooks/useCollections.ts`
- `react-frontend/src/services/collection.service.ts`
- `react-frontend/src/components/HeroSection.tsx`
- `react-frontend/src/pages/CollectionDetail.tsx`
- `react-frontend/src/pages/CollectionDetail.module.css`
- `react-frontend/src/App.tsx`

**Database:**
- `docs/collections_schema.sql`

---

## 📞 Support

For questions or issues related to the Collections module, please contact the development team or refer to this documentation.

**Last Updated:** January 2026  
**Version:** 1.0.0
