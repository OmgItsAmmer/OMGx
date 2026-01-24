# Collections Premium Feature - Complete Guide

## 🎯 Overview

The Collections module now supports **Premium** and **Standard** collections:

- **ONE Premium Collection**: Displays in the main hero banner (left side)
- **SIX Standard Collections**: 2 in side banners (right side, desktop), 4 in bottom cards

This creates a more dynamic and organized hero section that highlights your most important collection.

---

## 🏗️ Architecture

### Database Schema Changes

#### New Column: `is_premium`
```sql
ALTER TABLE collections ADD COLUMN is_premium BOOLEAN DEFAULT false;
```

**Constraints:**
- Only ONE collection can have `is_premium = true` at a time
- Database index on `is_premium` for fast queries
- Premium collection must also have `is_active = true`

### Collection Types

| Type | Count | Location | Properties |
|------|-------|----------|------------|
| **Premium** | 1 | Main banner (left) | `is_premium = true`, `is_active = true` |
| **Standard** | 6 | Side banners (2) + Bottom cards (4) | `is_premium = false`, `is_featured = true`, `is_active = true` |

---

## 🔌 Backend Implementation

### New API Endpoints

#### 1. Get Premium Collection
```
GET /api/v1/collections/premium
```

**Response:**
```json
{
  "success": true,
  "data": {
    "collection_id": 1,
    "name": "PREMIUM COLLECTION",
    "description": "Exclusive premium products",
    "image_url": "https://...",
    "is_premium": true,
    "item_count": 5,
    "total_price": 99999
  }
}
```

#### 2. Get Standard Collections
```
GET /api/v1/collections/standard?limit=6
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "collection_id": 2,
      "name": "Essential Bundle",
      "is_premium": false,
      "item_count": 3,
      "total_price": 29999
    },
    // ... 5 more collections
  ]
}
```

### Repository Methods

**New methods in `CollectionRepository`:**
```typescript
findPremiumCollection(): Promise<any | null>
findStandardCollections(limit: number): Promise<any[]>
```

---

## 🎨 Frontend Implementation

### Hero Section Changes

**File:** `react-frontend/src/components/HeroSection.tsx`

#### Before
- Fetched 7 featured collections
- First 2 → side banners
- Next 4 → bottom cards

#### After
- Fetches 1 premium collection → main banner
- Fetches 6 standard collections → side banners (2) + bottom cards (4)
- Uses separate React Query hooks for better caching

### New React Hooks

**File:** `react-frontend/src/hooks/useCollections.ts`

```typescript
// Get premium collection
const { data: premiumCollection } = usePremiumCollection();

// Get standard collections
const { data: standardCollections } = useStandardCollections(6);
```

### Image Handling

Collections now use the same image handling logic as ProductCard:

1. **Supabase Storage**: Uses "collections" bucket
2. **Fallback**: Automatically falls back to logo on error
3. **Error Tracking**: Tracks failed images per collection
4. **Lazy Loading**: Images load lazily for better performance

```typescript
// Image URL handling
const getCollectionImage = (collectionId, imageUrl) => {
  if (imageErrors[collectionId]) return logo;
  if (!imageUrl || imageUrl === '/logo.png') return logo;
  if (imageUrl.startsWith('http')) return imageUrl;
  return logo;
};
```

---

## 📊 Database Queries

### Set a Collection as Premium

```sql
-- Step 1: Remove premium status from all
UPDATE collections SET is_premium = false;

-- Step 2: Set ONE collection as premium
UPDATE collections 
SET is_premium = true, is_active = true 
WHERE collection_id = 1;
```

### View Collections by Type

```sql
SELECT 
    collection_id,
    name,
    is_premium,
    is_featured,
    is_active,
    display_order,
    COUNT(ci.collection_item_id) as item_count
FROM collections c
LEFT JOIN collection_items ci ON c.collection_id = ci.collection_id
GROUP BY c.collection_id, c.name, c.is_premium, c.is_featured, c.is_active, c.display_order
ORDER BY is_premium DESC, display_order ASC;
```

### Enforce Only One Premium

```sql
-- Create a function to ensure only one premium
CREATE OR REPLACE FUNCTION ensure_single_premium()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_premium = true THEN
        UPDATE collections 
        SET is_premium = false 
        WHERE collection_id != NEW.collection_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER trigger_ensure_single_premium
    BEFORE INSERT OR UPDATE OF is_premium ON collections
    FOR EACH ROW
    WHEN (NEW.is_premium = true)
    EXECUTE FUNCTION ensure_single_premium();
```

---

## 🔄 Migration Guide

### For New Installations
Run in order:
1. `docs/collections_schema.sql` (includes `is_premium`)
2. `docs/collections_sample_data.sql` (creates 1 premium + 6 standard)

### For Existing Installations
Run:
```bash
psql -h localhost -U your_user -d your_db -f docs/collections_add_premium_migration.sql
```

This will:
- Add `is_premium` column
- Set first collection as premium
- Create necessary index

---

## 🎨 UI Behavior

### Desktop (≥1024px)
```
┌─────────────────────┬─────────┐
│                     │ Side 1  │
│   PREMIUM           │─────────│
│   COLLECTION        │ Side 2  │
│   (Main Banner)     │         │
└─────────────────────┴─────────┘
┌──────┬──────┬──────┬──────┐
│Card 1│Card 2│Card 3│Card 4│
└──────┴──────┴──────┴──────┘
```

### Mobile (<1024px)
```
┌─────────────────────┐
│   PREMIUM           │
│   COLLECTION        │
│   (Main Banner)     │
└─────────────────────┘
┌──────┬──────┐
│Card 1│Card 2│
└──────┴──────┘
┌──────┬──────┐
│Card 3│Card 4│
└──────┴──────┘
```

Side banners are hidden on mobile.

---

## 🖼️ Image Upload Guide

### Supabase Setup

1. **Create Bucket** (if not exists):
```javascript
// In Supabase dashboard: Storage → New Bucket
{
  name: 'collections',
  public: true
}
```

2. **Upload Images**:
   - Navigate to Storage → collections bucket
   - Upload images (recommended: 800x800px or larger)
   - Copy public URL

3. **Update Collection**:
```sql
UPDATE collections 
SET image_url = 'https://your-project.supabase.co/storage/v1/object/public/collections/premium.jpg'
WHERE collection_id = 1;
```

### Image Naming Convention (Recommended)
- `premium-collection.jpg` - For premium collection
- `essential-bundle.jpg` - For standard collections
- Use lowercase with hyphens
- Use meaningful names

---

## ✅ Testing Checklist

### Backend Testing
- [ ] GET `/api/v1/collections/premium` returns ONE collection
- [ ] GET `/api/v1/collections/standard` returns 6 collections
- [ ] Only one collection has `is_premium = true`
- [ ] Standard collections exclude premium
- [ ] Collections load with items and prices

### Frontend Testing
- [ ] Main banner shows premium collection
- [ ] Premium collection is clickable
- [ ] Side banners show 2 standard collections (desktop)
- [ ] Bottom cards show 4 standard collections
- [ ] Images load correctly from Supabase
- [ ] Fallback to logo when image fails
- [ ] Click any collection navigates to detail page
- [ ] Mobile view hides side banners

---

## 🐛 Troubleshooting

### Premium collection not showing
```sql
-- Check if premium collection exists
SELECT * FROM collections WHERE is_premium = true;

-- If none, set one:
UPDATE collections SET is_premium = true WHERE collection_id = 1;
```

### Multiple premium collections
```sql
-- Fix: Keep only first one as premium
UPDATE collections SET is_premium = false;
UPDATE collections SET is_premium = true WHERE collection_id = 1;
```

### Images not loading
1. Check image URL in database
2. Verify Supabase bucket is public
3. Test URL directly in browser
4. Check browser console for CORS errors
5. System will automatically fallback to logo

### Standard collections not showing
```sql
-- Check if collections are marked as featured
SELECT collection_id, name, is_featured, is_premium 
FROM collections 
WHERE is_active = true;

-- Mark collections as featured (but not premium)
UPDATE collections 
SET is_featured = true, is_premium = false 
WHERE collection_id IN (2, 3, 4, 5, 6, 7);
```

---

## 📝 Best Practices

1. **Premium Collection**:
   - Use your most important/profitable collection
   - Update regularly to keep hero section fresh
   - Use high-quality banner image

2. **Standard Collections**:
   - Rotate featured collections seasonally
   - Use `display_order` to control sequence
   - Keep 6 active for optimal UI

3. **Images**:
   - Upload to Supabase "collections" bucket
   - Use consistent aspect ratios
   - Optimize images for web (compress before upload)
   - Always test image URLs

4. **Performance**:
   - Premium and standard collections are cached separately
   - Cache duration: 5 minutes
   - Images are lazy-loaded

---

## 🚀 Future Enhancements

Potential improvements (not yet implemented):
- Admin UI to set premium collection
- Scheduled premium collection rotation
- A/B testing for premium collections
- Analytics on premium vs standard clicks
- Collection impression tracking

---

**Last Updated:** January 17, 2026  
**Version:** 2.0.0 (Premium Feature)
