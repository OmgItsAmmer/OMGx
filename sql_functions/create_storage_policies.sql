-- Storage policies for authenticated users to upload files to buckets
-- This fixes the "new row violates row-level security policy" error when uploading images
--
-- IMPORTANT: Even though buckets may be PUBLIC, RLS policies are still required for
-- INSERT (upload), UPDATE, and DELETE operations. Public buckets only bypass RLS for SELECT (read).
--
-- To apply this migration, you must run it in the Supabase Dashboard SQL Editor
-- (Storage policies require owner permissions that migrations don't have)

-- Enable RLS on storage.objects (should already be enabled, but ensuring it)
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- DROP ALL EXISTING POLICIES (to allow re-running this migration)
-- ============================================================================

-- Generic policies
DROP POLICY IF EXISTS "Authenticated users can upload files" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read files" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update files" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete files" ON storage.objects;

-- Brands bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to brands" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from brands" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update brands" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from brands" ON storage.objects;

-- Categories bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to categories" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from categories" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update categories" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from categories" ON storage.objects;

-- Collections bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to collections" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from collections" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update collections" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from collections" ON storage.objects;

-- Customers bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to customers" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from customers" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update customers" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from customers" ON storage.objects;

-- Guarantors bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to guarantors" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from guarantors" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update guarantors" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from guarantors" ON storage.objects;

-- Products bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to products" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from products" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update products" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from products" ON storage.objects;

-- Salesman bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to salesman" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from salesman" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update salesman" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from salesman" ON storage.objects;

-- Shop bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to shop" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from shop" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update shop" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from shop" ON storage.objects;

-- Users bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to users" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from users" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update users" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from users" ON storage.objects;

-- Vendors bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload to vendors" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can read from vendors" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update vendors" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete from vendors" ON storage.objects;

-- ============================================================================
-- CREATE POLICIES FOR EACH BUCKET AND CRUD OPERATION
-- ============================================================================

-- ============================================================================
-- BRANDS BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to brands"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'brands');

CREATE POLICY "Authenticated users can read from brands"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'brands');

CREATE POLICY "Authenticated users can update brands"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'brands')
WITH CHECK (bucket_id = 'brands');

CREATE POLICY "Authenticated users can delete from brands"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'brands');

-- ============================================================================
-- CATEGORIES BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to categories"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'categories');

CREATE POLICY "Authenticated users can read from categories"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'categories');

CREATE POLICY "Authenticated users can update categories"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'categories')
WITH CHECK (bucket_id = 'categories');

CREATE POLICY "Authenticated users can delete from categories"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'categories');

-- ============================================================================
-- COLLECTIONS BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to collections"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'collections');

CREATE POLICY "Authenticated users can read from collections"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'collections');

CREATE POLICY "Authenticated users can update collections"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'collections')
WITH CHECK (bucket_id = 'collections');

CREATE POLICY "Authenticated users can delete from collections"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'collections');

-- ============================================================================
-- CUSTOMERS BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to customers"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'customers');

CREATE POLICY "Authenticated users can read from customers"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'customers');

CREATE POLICY "Authenticated users can update customers"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'customers')
WITH CHECK (bucket_id = 'customers');

CREATE POLICY "Authenticated users can delete from customers"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'customers');

-- ============================================================================
-- GUARANTORS BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to guarantors"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'guarantors');

CREATE POLICY "Authenticated users can read from guarantors"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'guarantors');

CREATE POLICY "Authenticated users can update guarantors"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'guarantors')
WITH CHECK (bucket_id = 'guarantors');

CREATE POLICY "Authenticated users can delete from guarantors"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'guarantors');

-- ============================================================================
-- PRODUCTS BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to products"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'products');

CREATE POLICY "Authenticated users can read from products"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'products');

CREATE POLICY "Authenticated users can update products"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'products')
WITH CHECK (bucket_id = 'products');

CREATE POLICY "Authenticated users can delete from products"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'products');

-- ============================================================================
-- SALESMAN BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to salesman"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'salesman');

CREATE POLICY "Authenticated users can read from salesman"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'salesman');

CREATE POLICY "Authenticated users can update salesman"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'salesman')
WITH CHECK (bucket_id = 'salesman');

CREATE POLICY "Authenticated users can delete from salesman"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'salesman');

-- ============================================================================
-- SHOP BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to shop"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'shop');

CREATE POLICY "Authenticated users can read from shop"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'shop');

CREATE POLICY "Authenticated users can update shop"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'shop')
WITH CHECK (bucket_id = 'shop');

CREATE POLICY "Authenticated users can delete from shop"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'shop');

-- ============================================================================
-- USERS BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to users"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'users');

CREATE POLICY "Authenticated users can read from users"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'users');

CREATE POLICY "Authenticated users can update users"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'users')
WITH CHECK (bucket_id = 'users');

CREATE POLICY "Authenticated users can delete from users"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'users');

-- ============================================================================
-- VENDORS BUCKET POLICIES
-- ============================================================================
CREATE POLICY "Authenticated users can upload to vendors"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'vendors');

CREATE POLICY "Authenticated users can read from vendors"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'vendors');

CREATE POLICY "Authenticated users can update vendors"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'vendors')
WITH CHECK (bucket_id = 'vendors');

CREATE POLICY "Authenticated users can delete from vendors"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'vendors');
