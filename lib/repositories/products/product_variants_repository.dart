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
  }) async {
    try {
      final query = supabase
          .from('product_variants')
          .select()
          .eq('product_id', productId);

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

  // Fetch available (unsold) variants for a specific product
  Future<List<ProductVariantModel>> fetchAvailableVariants(
      int productId) async {
    try {
      final data = await supabase
          .from('product_variants')
          .select()
          .eq('product_id', productId)
          .eq('is_sold', false);

      final variantList = data.map((item) {
        return ProductVariantModel.fromJson(item);
      }).toList();

      return variantList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return [];
    }
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
  Future<void> updateVariant(ProductVariantModel variant) async {
    try {
      int? variantId = variant.variantId;
      if (variantId == null) {
        throw Exception('Variant ID is required for update.');
      }

      await supabase
          .from('product_variants')
          .update(variant.toJson(isUpdate: true))
          .eq('variant_id', variantId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      rethrow;
    }
  }

  // Mark a variant as sold
  Future<void> markVariantAsSold(int variantId) async {
    try {
      await supabase
          .from('product_variants')
          .update({'is_sold': true}).eq('variant_id', variantId);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      rethrow;
    }
  }

  // Mark a variant as available (not sold)
  Future<void> markVariantAsAvailable(int variantId) async {
    try {
      await supabase
          .from('product_variants')
          .update({'is_sold': false}).eq('variant_id', variantId);
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

  // Get variant by serial number
  Future<ProductVariantModel?> getVariantBySerialNumber(
      String serialNumber) async {
    try {
      final response = await supabase
          .from('product_variants')
          .select()
          .eq('serial_number', serialNumber)
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

  // Count available variants for a product
  Future<int> countAvailableVariants(int productId) async {
    try {
      final data = await supabase
          .from('product_variants')
          .select()
          .eq('product_id', productId)
          .eq('is_sold', false);

      return data.length;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Repo', message: e.toString());
      return 0;
    }
  }
}
