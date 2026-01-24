# Quick Setup Guide - Collections Module

## ✅ Latest Updates
1. **PostgreSQL case-sensitivity**: Fixed `isVisible`, `isFeatured` column references
2. **Premium Collection Feature**: ONE premium collection for main banner, 6 standard for cards
3. **Image Handling**: Supabase "collections" bucket support with graceful fallback
4. **Automatic sample data**: Creates 1 premium + 6 standard collections

---

## 🚀 Quick Setup (3 Steps)

### Step 1: Run SQL Scripts
```bash
# Navigate to your project root
cd C:\Programming\Projects\01_ACTIVE\kks_web

# Connect to your database and run both scripts
# Replace with your actual database credentials

# Option A: Using psql command line
psql -h localhost -U your_username -d your_database -f docs/collections_schema.sql
psql -h localhost -U your_username -d your_database -f docs/collections_sample_data.sql

# Option B: Using pgAdmin or another GUI
# 1. Open docs/collections_schema.sql
# 2. Execute it
# 3. Open docs/collections_sample_data.sql
# 4. Execute it
```

### Step 2: Restart Backend
```bash
# Stop backend (Ctrl+C in terminal)
# Then restart:
cd kksonline-backend-express
npm run dev
```

### Step 3: Refresh Frontend
Just refresh your browser (F5) or restart frontend:
```bash
cd react-frontend
npm run dev
```

---

## ✨ What You Should See

1. **Home Page**: Hero section now shows collections instead of products
2. **Main Banner**: ONE premium collection ("PREMIUM COLLECTION") with dynamic content
3. **Side Banners** (desktop): 2 standard collections on the right side
4. **Bottom Cards**: 4 standard collections below
5. **Click any collection**: Opens detail page with all items
6. **Collection Detail**: 
   - View all items with images
   - Change variants from dropdowns
   - Adjust quantities
   - See real-time price updates
   - Add to cart

---

## 🧪 Quick Test

1. Go to homepage (`http://localhost:5173`)
2. Scroll to hero section
3. You should see collection cards
4. Click "Premium Starter Pack"
5. Try changing a variant
6. Try adjusting quantity
7. Click "Add to Cart"

---

## ❓ Troubleshooting

### No collections showing?
Check if sample data was created:
```sql
SELECT * FROM collections;
SELECT COUNT(*) FROM collection_items;
```

### Collections have 0 items?
Check if you have products:
```sql
SELECT COUNT(*) FROM products WHERE "isVisible" = true;
SELECT COUNT(*) FROM product_variants WHERE is_visible = true;
```

If you have products but collections are empty, the products may not have visible variants with stock. Add items manually:
```sql
-- Find a variant ID
SELECT pv.variant_id, p.name, pv.variant_name 
FROM product_variants pv 
JOIN products p ON p.product_id = pv.product_id 
WHERE pv.is_visible = true 
LIMIT 5;

-- Add to collection (replace 123 with actual variant_id)
INSERT INTO collection_items (collection_id, variant_id, default_quantity, sort_order)
VALUES (1, 123, 1, 1);
```

### Backend errors?
Check backend terminal for error messages. Most common:
- Database connection issues
- Missing tables (run schema.sql)
- Case-sensitivity errors (should be fixed now)

### Frontend errors?
Check browser console (F12). Most common:
- Backend not running
- API endpoint wrong
- CORS issues (should be configured)

---

## 🖼️ Image Setup (Optional but Recommended)

To use custom images for collections:

1. **Create Supabase Storage Bucket** (if not exists):
   - Bucket name: `collections`
   - Public bucket: Yes

2. **Upload Images**:
   - Upload collection images to the `collections` bucket
   - Get the public URL for each image

3. **Update Database**:
```sql
UPDATE collections 
SET image_url = 'https://your-supabase-url/storage/v1/object/public/collections/your-image.jpg'
WHERE collection_id = 1;
```

**Note**: If images fail to load or are not set, the system will automatically fall back to using the logo.

---

## 📝 Database Connection Info

Make sure your backend `.env` file has correct database credentials:
```env
DATABASE_URL="postgresql://username:password@localhost:5432/database_name"
```

---

## 🎉 Success Indicators

✅ Backend logs show: `Collections routes loaded`  
✅ Home page shows collection cards  
✅ Clicking collection opens detail page  
✅ Can change variants and quantities  
✅ Add to cart works  

---

## 📞 Need Help?

If you're still having issues:
1. Check backend terminal for errors
2. Check browser console (F12)
3. Verify database has collections and items
4. Make sure backend and frontend are both running

Refer to:
- **Full Documentation**: `docs/COLLECTIONS_MODULE_DOCUMENTATION.md`
- **Implementation Summary**: `COLLECTIONS_IMPLEMENTATION_SUMMARY.md`
