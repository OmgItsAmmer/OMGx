import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class ProductVariantsRepository {
  // Fetch all variants for a specific product
  Future<List<ProductVariantModel>> fetchProductVariants(
    int productId, {
    int limit = 0, // Default 0 means no limit
    bool visibleOnly = false, // Option to fetch only visible variants
  }) async {
    try {
      var query = supabase
          .from('product_variants')
          .select()
          .eq('product_id', productId);

      // Filter by visibility if requested
      if (visibleOnly) {
        query = query.eq('is_visible', true);
      }

      // Apply limit if specified
      final data = limit > 0 ? await query.limit(limit) : await query;

      final variantList = data.map((item) {
        return ProductVariantModel.fromJson(item);
      }).toList();

      return variantList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return [];
    }
  }

  // Fetch visible variants for a specific product
  Future<List<ProductVariantModel>> fetchVisibleVariants(int productId) async {
    return fetchProductVariants(productId, visibleOnly: true);
  }

  // Insert a new variant
  Future<int> insertVariant(ProductVariantModel variant) async {
    try {
      final response = await supabase
          .from('product_variants')
          .insert(variant.toJson())
          .select('variant_id')
          .single();

      final variantId = response['variant_id'] as int;
      return variantId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      rethrow;
    }
  }

  // Update an existing variant
  Future<bool> updateVariant(ProductVariantModel variant) async {
    try {
      int? variantId = variant.variantId;
      if (variantId == null) {
        throw Exception('Variant ID is required for update.');
      }

      final response = await supabase
          .from('product_variants')
          .update(variant.toJson(isUpdate: true))
          .eq('variant_id', variantId)
          .select();

      return response.isNotEmpty;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.message);
      return false;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return false;
    }
  }

  // Update variant stock
  Future<void> updateVariantStock(int variantId, int newStock) async {
    try {
      await supabase
          .from('product_variants')
          .update({'stock': newStock}).eq('variant_id', variantId);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      rethrow;
    }
  }

  // Toggle variant visibility
  Future<void> toggleVariantVisibility(int variantId, bool isVisible) async {
    try {
      await supabase
          .from('product_variants')
          .update({'is_visible': isVisible}).eq('variant_id', variantId);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      rethrow;
    }
  }

  // Delete a variant
  Future<void> deleteVariant(int variantId) async {
    try {
      await supabase
          .from('product_variants')
          .delete()
          .eq('variant_id', variantId);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      rethrow;
    }
  }

  // Import multiple variants at once (for bulk upload)
  Future<void> bulkImportVariants(List<ProductVariantModel> variants) async {
    try {
      if (variants.isEmpty) return;

      final List<Map<String, dynamic>> variantsData =
          variants.map((v) => v.toJson()).toList();

      await supabase.from('product_variants').insert(variantsData);

      TLoaders.successSnackBar(
        title: 'Success',
        message: '${variants.length} variants added successfully',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error in bulk import: $e');
      }
      TLoaders.errorSnackBar(title: 'Bulk Import Error', message: e.toString());
      rethrow;
    }
  }

  // Get variant by SKU
  Future<ProductVariantModel?> getVariantBySku(String sku) async {
    try {
      final response = await supabase
          .from('product_variants')
          .select()
          .eq('sku', sku)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return ProductVariantModel.fromJson(response);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return null;
    }
  }

  // Check if SKU exists for a product (excluding specific variant ID for updates)
  Future<bool> isSkuExists(String sku, int productId,
      {int? excludeVariantId}) async {
    try {
      var query = supabase
          .from('product_variants')
          .select('variant_id')
          .eq('sku', sku)
          .eq('product_id', productId);

      if (excludeVariantId != null) {
        query = query.neq('variant_id', excludeVariantId);
      }

      final response = await query.maybeSingle();
      return response != null;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return false;
    }
  }

  // Count total variants for a product
  Future<int> countProductVariants(int productId) async {
    try {
      final data = await supabase
          .from('product_variants')
          .select()
          .eq('product_id', productId);

      return data.length;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return 0;
    }
  }

  // Calculate total stock for a product (sum of all variant stocks)
  Future<int> calculateProductStock(int productId) async {
    try {
      final variants = await fetchProductVariants(productId);
      return variants.fold<int>(0, (sum, variant) => sum + variant.stock);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return 0;
    }
  }

  // Get variants with low stock
  Future<List<ProductVariantModel>> getLowStockVariants(
      int productId, int threshold) async {
    try {
      final data = await supabase
          .from('product_variants')
          .select()
          .eq('product_id', productId)
          .lte('stock', threshold);

      final variantList = data.map((item) {
        return ProductVariantModel.fromJson(item);
      }).toList();

      return variantList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return [];
    }
  }

  // Get variants that are below their alert stock level
  Future<List<ProductVariantModel>> getVariantsBelowAlertStock(
      int productId) async {
    try {
      // First get all variants for the product
      final data = await supabase
          .from('product_variants')
          .select()
          .eq('product_id', productId);

      // Filter variants where stock is less than or equal to alert_stock
      final variantList = data.map((item) {
        return ProductVariantModel.fromJson(item);
      }).toList();

      // Filter in Dart code since Supabase doesn't support column-to-column comparison in filter
      final lowStockVariants = variantList
          .where((variant) =>
              variant.stock <= variant.alertStock && variant.alertStock > 0)
          .toList();

      return lowStockVariants;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return [];
    }
  }

  // Update variant alert stock
  Future<void> updateVariantAlertStock(int variantId, int alertStock) async {
    try {
      await supabase
          .from('product_variants')
          .update({'alert_stock': alertStock}).eq('variant_id', variantId);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      rethrow;
    }
  }
}
