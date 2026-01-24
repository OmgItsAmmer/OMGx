# Admin Collections Management Guide

## 📦 Overview

This guide explains how to use the **Collections Management** feature in the admin dashboard. Collections allow you to bundle multiple products together and display them on the customer-facing website.

## 🎯 What are Collections?

Collections are curated groups of products that customers can browse and purchase. They appear in the hero section of your e-commerce website and can include:

- **Premium Collections**: ONE featured collection displayed prominently in the main banner
- **Standard Collections**: Multiple collections shown in side banners and cards
- **Collection Items**: Individual product variants with customizable quantities

---

## 🚀 Getting Started

### Accessing Collections

1. Log into the admin dashboard
2. Navigate to **Collections** from the sidebar menu (under INVENTORY section)
3. You'll see a list of all existing collections

---

## ✨ Features

### Collection Management

- ✅ **Create** new collections
- ✅ **Edit** existing collections
- ✅ **Delete** collections
- ✅ **Toggle** active/inactive status
- ✅ **Set** featured status
- ✅ **Mark** as premium (only one allowed)
- ✅ **Upload** collection images
- ✅ **Manage** items within collections
- ✅ **Adjust** item quantities
- ✅ **Reorder** collections with display order

---

## 📝 Creating a Collection

### Step 1: Navigate to Collections

Click on **"Add Collection"** button on the Collections page.

### Step 2: Fill Basic Information

**Required Fields:**
- **Collection Name**: A descriptive name (e.g., "Premium Starter Pack")
- **Display Order**: Number to control sort order (lower numbers appear first)

**Optional Fields:**
- **Description**: Detailed description of the collection
- **Active**: Toggle to make collection visible to customers
- **Featured**: Show in hero section
- **Premium**: Mark as premium collection (only ONE allowed)

### Step 3: Upload Image

1. Click **"Select Image"** button
2. Choose an image from your computer
3. Recommended: 800x800px or larger, JPG/PNG format
4. The image will be uploaded to Supabase storage in the "collections" bucket

### Step 4: Save Collection

Click **"Create Collection"** button. The collection will be saved and you can now add items to it.

### Step 5: Add Items to Collection

After creating the collection:

1. Click **"Add Item"** button in the Collection Items section
2. Select a product variant from the dropdown
3. Enter the default quantity
4. Click **"Add"**

You can add multiple items to a collection. Each item shows:
- Product name and variant
- Price per unit
- Available stock
- Quantity controls (+ / -)
- Remove button

---

## ✏️ Editing a Collection

### From Collections List

1. Click on any collection row to open it
2. Or click the **Edit** icon in the Actions column

### Making Changes

- Update any field (name, description, display order, etc.)
- Change the image by selecting a new one
- Toggle status switches (Active, Featured, Premium)
- Add/remove items
- Adjust item quantities using + / - buttons
- Click **"Update Collection"** to save changes

---

## 🗑️ Deleting a Collection

### From Collections List

1. Click the **Delete** icon in the Actions column
2. Confirm the deletion in the dialog
3. **Warning**: This will also remove all items in the collection

---

## 🎨 Managing Collection Images

### Image Requirements

- **Format**: JPG or PNG
- **Size**: 800x800px or larger recommended
- **Aspect Ratio**: 
  - 1:1 (square) for side cards
  - 16:9 for main banner (premium collection)

### Upload Process

1. Images are stored in Supabase Storage bucket "collections"
2. Public URLs are generated automatically
3. If upload fails, the system will continue without the image
4. You can replace images anytime by selecting a new one

### Fallback Behavior

- If no image is uploaded, the system uses a placeholder
- If image fails to load, it falls back to the app logo
- Same fallback logic as product images

---

## 🏷️ Collection Status Types

### Active Status
- **Active**: Collection is visible to customers
- **Inactive**: Collection is hidden from customers

### Featured Status
- **Featured**: Appears in the hero section
- **Not Featured**: Only appears in collection listings

### Premium Status
- **Premium**: Displayed in the main banner (only ONE allowed)
- **Standard**: Displayed in side banners and cards

**Important**: The database enforces that only ONE collection can be premium at a time. If you mark a new collection as premium, the previous one will be automatically unmarked.

---

## 📦 Managing Collection Items

### Adding Items

1. Open a collection for editing
2. Click **"Add Item"** button
3. Select from available product variants
4. Set default quantity
5. Click **"Add"**

**Requirements:**
- Collection must be saved first (can't add items to unsaved collections)
- Only existing, visible product variants can be selected
- Variants must have stock available

### Updating Quantities

- Use **+** button to increase quantity
- Use **-** button to decrease quantity (minimum 1)
- Changes are saved immediately

### Removing Items

1. Click the **trash icon** next to an item
2. Confirm removal
3. Item is removed from collection immediately

### Item Display

Each item shows:
- Product name
- Variant name (e.g., "Queen Size", "Blue", etc.)
- Price per unit
- Available stock
- Current quantity in collection

---

## 💰 Collection Pricing

### Automatic Calculation

The system automatically calculates the total collection price based on:
- Selected variants
- Their individual prices
- Quantities in the collection

**Formula**: `Total = Σ (variant_price × quantity)`

### Price Display

- Individual item prices shown for each product
- Total collection price displayed at the bottom
- Prices update in real-time as you adjust quantities

---

## 🔍 Searching and Filtering

### Search Collections

Use the search bar to find collections by:
- Collection name
- Description text

### Sorting

Click on the **Display Order** column header to sort collections by their display order.

### Refresh

Click the **refresh icon** to reload the collections list.

---

## 🎯 Best Practices

### Collection Strategy

1. **Premium Collection**:
   - Use your most important/profitable collection
   - Update regularly to keep hero section fresh
   - Use high-quality banner image (16:9 aspect ratio)

2. **Featured Collections**:
   - Rotate seasonally
   - Use display order to control sequence
   - Keep 6 active for optimal UI

3. **Collection Names**:
   - Use clear, descriptive names
   - Examples: "Premium Starter Pack", "Essential Bundle", "Luxury Collection"

4. **Images**:
   - Use consistent aspect ratios
   - Optimize images for web (compress before upload)
   - Test image URLs before updating

### Performance Tips

1. **Limit Collection Size**:
   - Keep collections focused (3-10 items ideal)
   - Too many items can overwhelm customers

2. **Stock Management**:
   - Regularly check stock levels for collection items
   - Deactivate collections with out-of-stock items
   - Update quantities based on available stock

3. **Display Order**:
   - Use increments of 10 (10, 20, 30...) for easy reordering
   - Lower numbers appear first
   - Leave gaps for future insertions

---

## 🔧 Technical Details

### Database Tables

- **collections**: Main collection information
- **collection_items**: Items within each collection
- **product_variants**: Product variants that can be added

### Image Storage

- **Bucket**: `collections` (Supabase Storage)
- **Public Access**: Yes
- **URL Format**: `https://[project].supabase.co/storage/v1/object/public/collections/[filename]`

### Constraints

- Only ONE premium collection allowed (database enforced)
- Collection items must reference existing, visible variants
- Quantities must be positive integers
- Display order must be a number

---

## ⚠️ Important Notes

### Stock Management

- **Collections do NOT reserve stock** when created
- Stock is validated when customers add to cart
- If a variant goes out of stock, it will be disabled on the customer site
- Consider setting up stock alerts for products in popular collections

### Pricing Strategy

- Collection prices are calculated dynamically
- Price changes in product variants automatically reflect in collections
- No discounts or special pricing for collections (implement separately if needed)

### Premium Collection

- Only ONE collection can be premium at a time
- Database constraint prevents multiple premium collections
- Setting a new collection as premium automatically removes premium status from others

---

## 🐛 Troubleshooting

### Collection Not Showing on Website

**Check:**
1. Is the collection **Active**?
2. Is it marked as **Featured** (for hero section)?
3. Does it have at least one item?
4. Are the items' product variants visible and in stock?

### Can't Add Items to Collection

**Possible Causes:**
1. Collection not saved yet (save first, then add items)
2. No visible product variants available
3. Selected variant out of stock

### Image Not Displaying

**Solutions:**
1. Check if image was uploaded successfully
2. Verify Supabase storage bucket "collections" exists and is public
3. Test the image URL directly in browser
4. Try uploading a different image
5. System will fallback to logo if image fails

### Multiple Premium Collections Error

**Solution:**
- This is expected behavior (only ONE premium allowed)
- Unmark the current premium collection first
- Or the system will automatically handle it when you save

### Can't Delete Collection

**Possible Causes:**
1. Database connection issue
2. Collection has active orders (check with backend team)

**Solution:**
- Try deactivating the collection instead of deleting
- Contact technical support if issue persists

---

## 📞 Support

For technical issues or questions:
1. Check this documentation first
2. Review the main Collections Module Documentation
3. Contact the development team

---

## 🔄 Updates and Maintenance

### Regular Tasks

**Weekly:**
- Review collection performance
- Update featured collections
- Check stock levels for collection items

**Monthly:**
- Rotate premium collection
- Archive old/seasonal collections
- Add new collections based on inventory

**Quarterly:**
- Review collection strategy
- Analyze customer preferences
- Update collection images

---

## 📊 Collection Analytics (Future Feature)

*Coming soon: Analytics dashboard showing:*
- Most viewed collections
- Conversion rates
- Revenue per collection
- Popular items within collections

---

## 🎓 Quick Reference

### Keyboard Shortcuts

- **Ctrl + Enter**: Save collection
- **Escape**: Discard changes and close

### Status Icons

- ✅ **Green Circle**: Active
- ❌ **Red Circle**: Inactive
- ⭐ **Yellow Star**: Featured
- 👑 **Purple Crown**: Premium

### Action Buttons

- 👁️ **View**: Open collection details
- ✏️ **Edit**: Edit collection
- 🗑️ **Delete**: Delete collection
- 🔄 **Refresh**: Reload collections list

---

**Last Updated**: January 17, 2026  
**Version**: 1.0.0  
**Admin Dashboard Version**: Compatible with all versions
