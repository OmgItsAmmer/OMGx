# Collections Module - Quick Reference Card

## 📍 Navigation
**Sidebar** → INVENTORY → **Collections**

---

## 🎯 Quick Actions

### Create Collection
1. Click **"Add Collection"**
2. Enter name + display order
3. Upload image (optional)
4. Toggle status switches
5. Click **"Create Collection"**
6. Add items

### Edit Collection
1. Click on collection row
2. Make changes
3. Click **"Update Collection"**

### Delete Collection
1. Click **Delete icon** (🗑️)
2. Confirm

---

## 📋 Collection Fields

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| Name | ✅ Yes | Text | Collection name |
| Description | ❌ No | Text | Detailed description |
| Display Order | ✅ Yes | Number | Sort order (lower = first) |
| Active | ❌ No | Toggle | Visible to customers |
| Featured | ❌ No | Toggle | Show in hero section |
| Premium | ❌ No | Toggle | Main banner (only ONE) |
| Image | ❌ No | File | Collection image |

---

## 🎨 Status Types

| Status | Icon | Meaning |
|--------|------|---------|
| Active | ✅ Green | Visible to customers |
| Inactive | ❌ Red | Hidden from customers |
| Featured | ⭐ Yellow | In hero section |
| Premium | 👑 Purple | Main banner (only 1) |

---

## 📦 Managing Items

### Add Item
1. Open collection
2. Click **"Add Item"**
3. Select variant
4. Enter quantity
5. Click **"Add"**

### Update Quantity
- Click **+** to increase
- Click **-** to decrease

### Remove Item
- Click **🗑️** trash icon
- Confirm removal

---

## 🖼️ Image Guidelines

**Format**: JPG or PNG  
**Size**: 800x800px minimum  
**Aspect Ratio**:
- Premium: 16:9 (banner)
- Standard: 1:1 (cards)

---

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + Enter` | Save collection |
| `Escape` | Discard & close |

---

## ⚠️ Important Rules

1. **Premium Collections**: Only ONE allowed
2. **Product Selection**: Only existing, visible products
3. **Stock Check**: Items must have stock
4. **Save First**: Must save collection before adding items
5. **Image Storage**: Uploads to "collections" bucket

---

## 🔍 Search & Filter

**Search by**:
- Collection name
- Description

**Sort by**:
- Display order (click column header)

---

## 💡 Best Practices

### Display Order
Use increments of 10:
- 10, 20, 30, 40...
- Easy to reorder later

### Collection Size
- 3-10 items ideal
- Too many = overwhelming

### Premium Strategy
- Use most profitable collection
- Update regularly
- High-quality banner image

### Featured Collections
- Keep 6 active
- Rotate seasonally
- Use display order

---

## 🐛 Troubleshooting

### Collection not visible?
- Check **Active** status
- Check **Featured** status
- Verify items exist
- Check item stock

### Can't add items?
- Save collection first
- Check product visibility
- Verify stock availability

### Image not showing?
- Check upload success
- Verify bucket exists
- Test URL in browser
- System uses fallback

### Premium error?
- Only ONE allowed
- Unmark current premium
- Or system auto-handles

---

## 📊 Collection Pricing

**Auto-calculated**:
```
Total = Σ (variant_price × quantity)
```

Updates in real-time as you adjust quantities.

---

## 🔐 Permissions

- Requires admin authentication
- Same as other inventory features
- Protected routes

---

## 📱 Responsive

**Desktop**: Two-column layout  
**Tablet**: Same as desktop  
**Mobile**: Stacked layout

---

## 🎓 Common Workflows

### Launch New Collection
1. Create collection
2. Upload eye-catching image
3. Add 5-7 popular items
4. Set display order = 10
5. Mark as **Featured**
6. Activate

### Promote to Premium
1. Open collection
2. Toggle **Premium** ON
3. Update image (16:9)
4. Verify items
5. Save

### Seasonal Rotation
1. Deactivate old collections
2. Create new seasonal collection
3. Add relevant items
4. Feature prominently
5. Update premium if needed

---

## 📞 Quick Help

**User Guide**: `ADMIN_COLLECTIONS_GUIDE.md`  
**Setup Info**: `ADMIN_COLLECTIONS_SETUP.md`  
**Client Docs**: `COLLECTIONS_MODULE_DOCUMENTATION.md`

---

## ✅ Quick Checklist

Before publishing a collection:

- [ ] Name is clear and descriptive
- [ ] Display order is set
- [ ] Image uploaded (800x800px+)
- [ ] At least 3 items added
- [ ] All items have stock
- [ ] Status set correctly
- [ ] Tested on mobile
- [ ] Verified on website

---

**Version**: 1.0.0  
**Last Updated**: January 17, 2026  
**Print this for quick reference!** 📄
