import 'package:ecommerce_dashboard/Models/products/varaint_batches_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class VariantBatchesRepository {
  // Fetch all batches for a specific variant
  Future<List<VariantBatchesModel>> fetchVariantBatches(
    int variantId, {
    bool availableOnly = false,
  }) async {
    try {
      var query =
          supabase.from('variant_batches').select().eq('variant_id', variantId);

      if (availableOnly) {
        query = query.gt('available_quantity', 0);
      }

      final data = await query;

      final batchList = data.map((item) {
        return VariantBatchesModel.fromJson(item);
      }).toList();

      return batchList;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      return [];
    }
  }

  // Fetch available batches for a specific product (across all variants)
  Future<List<VariantBatchesModel>> fetchProductVariantBatches(
    int productId, {
    bool availableOnly = false,
  }) async {
    try {
      var query = supabase
          .from('variant_batches')
          .select('*, product_variants!inner(product_id)')
          .eq('product_variants.product_id', productId);

      if (availableOnly) {
        query = query.gt('available_quantity', 0);
      }

      final data = await query;

      final batchList = data.map((item) {
        return VariantBatchesModel.fromJson(item);
      }).toList();

      return batchList;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      return [];
    }
  }

  // Insert a new variant batch (usually called during purchases)
  Future<int> insertVariantBatch(VariantBatchesModel batch) async {
    try {
      final response = await supabase
          .from('variant_batches')
          .insert(batch.toJson())
          .select('id')
          .single();

      final batchId = response['id'] as int;
      return batchId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Variant Batches Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      rethrow;
    }
  }

  // Update available quantity (when selling items)
  Future<void> updateAvailableQuantity(
      int batchId, int newAvailableQuantity) async {
    try {
      await supabase.from('variant_batches').update(
          {'available_quantity': newAvailableQuantity}).eq('id', batchId);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      rethrow;
    }
  }

  // Reduce available quantity by the sold amount
  Future<void> reduceAvailableQuantity(int batchId, int soldQuantity) async {
    try {
      // First get current available quantity
      final response = await supabase
          .from('variant_batches')
          .select('available_quantity')
          .eq('id', batchId)
          .single();

      final currentQuantity = response['available_quantity'] as int;
      final newQuantity = currentQuantity - soldQuantity;

      if (newQuantity < 0) {
        throw Exception('Insufficient quantity available in batch');
      }

      await updateAvailableQuantity(batchId, newQuantity);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      rethrow;
    }
  }

  // Get total available quantity for a variant across all batches
  Future<int> getTotalAvailableQuantity(int variantId) async {
    try {
      final data = await supabase
          .from('variant_batches')
          .select('available_quantity')
          .eq('variant_id', variantId);

      int total = 0;
      for (var item in data) {
        total += item['available_quantity'] as int;
      }

      return total;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      return 0;
    }
  }

  // Get total available quantity for a product across all variants and batches
  Future<int> getTotalProductAvailableQuantity(int productId) async {
    try {
      final data = await supabase
          .from('variant_batches')
          .select('available_quantity, product_variants!inner(product_id)')
          .eq('product_variants.product_id', productId);

      int total = 0;
      for (var item in data) {
        total += item['available_quantity'] as int;
      }

      return total;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      return 0;
    }
  }

  // Delete a batch (usually when cancelling purchases)
  Future<void> deleteVariantBatch(int batchId) async {
    try {
      await supabase.from('variant_batches').delete().eq('id', batchId);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      rethrow;
    }
  }

  // Get batch by batch ID (serial number)
  Future<VariantBatchesModel?> getBatchByBatchId(String batchId) async {
    try {
      final response = await supabase
          .from('variant_batches')
          .select()
          .eq('batch_id', batchId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return VariantBatchesModel.fromJson(response);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Variant Batches Repo', message: e.toString());
      return null;
    }
  }

  // Bulk insert variant batches (for purchase operations)
  Future<void> bulkInsertVariantBatches(
      List<VariantBatchesModel> batches) async {
    try {
      if (batches.isEmpty) return;

      final List<Map<String, dynamic>> batchesData =
          batches.map((b) => b.toJson()).toList();

      await supabase.from('variant_batches').insert(batchesData);

      TLoaders.successSnackBar(
        title: 'Success',
        message: '${batches.length} batches added successfully',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error in bulk insert variant batches: $e');
      }
      TLoaders.errorSnackBar(title: 'Bulk Insert Error', message: e.toString());
      rethrow;
    }
  }

  // Update product stock quantities based on variant batches
  Future<void> updateProductStockFromBatches(int productId) async {
    try {
      final totalQuantity = await getTotalProductAvailableQuantity(productId);

      // Update the product's stock quantity in the products table
      await supabase.from('products').update(
          {'stock_quantity': totalQuantity}).eq('product_id', productId);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Stock Update Error', message: e.toString());
      rethrow;
    }
  }
}
