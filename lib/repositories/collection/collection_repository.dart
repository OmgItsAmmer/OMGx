import 'package:ecommerce_dashboard/Models/collection/collection_model.dart';
import 'package:ecommerce_dashboard/Models/collection/collection_item_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class CollectionRepository extends GetxController {
  static CollectionRepository get instance => Get.find();

  /// Fetch all collections
  Future<List<CollectionModel>> fetchAllCollections() async {
    try {
      final data = await supabase.from('collections').select().order('display_order');

      final collectionList = data.map((item) {
        return CollectionModel.fromJson(item);
      }).toList();

      return collectionList;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching collections: $e');
      }
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.toString());
      return [];
    }
  }

  /// Fetch single collection by ID
  Future<CollectionModel?> fetchCollectionById(int collectionId) async {
    try {
      final data = await supabase
          .from('collections')
          .select()
          .eq('collection_id', collectionId)
          .single();

      return CollectionModel.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching collection: $e');
      }
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.toString());
      return null;
    }
  }

  /// Insert new collection
  Future<int> insertCollection(Map<String, dynamic> json) async {
    try {
      final response = await supabase
          .from('collections')
          .insert(json)
          .select('collection_id')
          .single();

      final collectionId = response['collection_id'] as int;
      return collectionId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.toString());
      rethrow;
    }
  }

  /// Update existing collection
  Future<void> updateCollection(Map<String, dynamic> json) async {
    try {
      int? collectionId = json['collection_id'];
      if (collectionId == null) {
        throw Exception('Collection ID is required for update.');
      }

      // Remove collection_id from the update payload
      final updateData = Map<String, dynamic>.from(json)..remove('collection_id');

      await supabase
          .from('collections')
          .update(updateData)
          .eq('collection_id', collectionId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.toString());
      rethrow;
    }
  }

  /// Delete collection
  Future<void> deleteCollection(int collectionId) async {
    try {
      await supabase.from('collections').delete().eq('collection_id', collectionId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.toString());
      rethrow;
    }
  }

  /// Fetch collection items with product details
  Future<List<CollectionItemModel>> fetchCollectionItems(int collectionId) async {
    try {
      // Using the collection_items_detail view from the documentation
      final data = await supabase
          .from('collection_items_detail')
          .select()
          .eq('collection_id', collectionId)
          .order('sort_order');

      final itemList = data.map((item) {
        return CollectionItemModel.fromJson(item);
      }).toList();

      return itemList;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching collection items: $e');
      }
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.toString());
      return [];
    }
  }

  /// Insert collection item
  Future<int> insertCollectionItem(Map<String, dynamic> json) async {
    try {
      final response = await supabase
          .from('collection_items')
          .insert(json)
          .select('collection_item_id')
          .single();

      final itemId = response['collection_item_id'] as int;
      return itemId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Item Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Item Repo', message: e.toString());
      rethrow;
    }
  }

  /// Update collection item
  Future<void> updateCollectionItem(Map<String, dynamic> json) async {
    try {
      int? itemId = json['collection_item_id'];
      if (itemId == null) {
        throw Exception('Collection Item ID is required for update.');
      }

      final updateData = Map<String, dynamic>.from(json)..remove('collection_item_id');

      await supabase
          .from('collection_items')
          .update(updateData)
          .eq('collection_item_id', itemId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Item Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Item Repo', message: e.toString());
      rethrow;
    }
  }

  /// Delete collection item
  Future<void> deleteCollectionItem(int itemId) async {
    try {
      await supabase.from('collection_items').delete().eq('collection_item_id', itemId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Item Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Item Repo', message: e.toString());
      rethrow;
    }
  }

  /// Delete all items for a collection
  Future<void> deleteAllCollectionItems(int collectionId) async {
    try {
      await supabase.from('collection_items').delete().eq('collection_id', collectionId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Item Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Collection Item Repo', message: e.toString());
      rethrow;
    }
  }

  /// Fetch all available product variants for selection
  Future<List<Map<String, dynamic>>> fetchAvailableVariants() async {
    try {
      final data = await supabase
          .from('product_variants')
          .select('''
            variant_id,
            variant_name,
            sell_price,
            stock,
            is_visible,
            products!inner(
              product_id,
              name,
              "isVisible"
            )
          ''')
          .eq('is_visible', true)
          .eq('products.isVisible', true);

      // Sort by product name in Dart since PostgREST doesn't support ordering by nested columns
      final List<Map<String, dynamic>> sortedData = List<Map<String, dynamic>>.from(data);
      sortedData.sort((a, b) {
        final aProduct = a['products'] as Map<String, dynamic>?;
        final bProduct = b['products'] as Map<String, dynamic>?;
        final aName = aProduct?['name'] as String? ?? '';
        final bName = bProduct?['name'] as String? ?? '';
        return aName.compareTo(bName);
      });

      return sortedData;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching variants: $e');
      }
      TLoaders.errorSnackBar(title: 'Collection Repo', message: e.toString());
      return [];
    }
  }
}

