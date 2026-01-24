import 'package:ecommerce_dashboard/Models/collection/collection_model.dart';
import 'package:ecommerce_dashboard/Models/collection/collection_item_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/repositories/collection/collection_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../../utils/constants/enums.dart';
import '../media/media_controller.dart';

class CollectionController extends GetxController {
  static CollectionController get instance => Get.find();
  final collectionRepository = Get.put(CollectionRepository());
  final MediaController mediaController = Get.find<MediaController>();

  // Lists to store models
  RxList<CollectionModel> allCollections = <CollectionModel>[].obs;
  RxList<CollectionItemModel> collectionItems = <CollectionItemModel>[].obs;
  RxList<Map<String, dynamic>> availableVariants = <Map<String, dynamic>>[].obs;

  // Store selected Rows
  RxList<bool> selectedRows = <bool>[].obs;

  // Variables
  RxBool isUpdating = false.obs;
  RxBool isLoadingItems = false.obs;
  RxBool isLoadingVariants = false.obs;

  // Collection Detail Controllers
  RxInt collectionId = (-1).obs;
  final collectionName = TextEditingController();
  final collectionDescription = TextEditingController();
  final displayOrder = TextEditingController();
  RxBool isActive = true.obs;
  RxBool isFeatured = false.obs;
  RxBool isPremium = false.obs;

  // Collection image URL
  RxString imageUrl = ''.obs;

  GlobalKey<FormState> collectionForm = GlobalKey<FormState>();

  @override
  void onInit() {
    fetchCollections();
    super.onInit();
  }

  @override
  void onClose() {
    // Dispose all text controllers to prevent memory leaks
    collectionName.dispose();
    collectionDescription.dispose();
    displayOrder.dispose();
    super.onClose();
  }

  /// Fetch all collections
  Future<void> fetchCollections() async {
    try {
      isUpdating.value = true;
      final collections = await collectionRepository.fetchAllCollections();
      allCollections.assignAll(collections);
      selectedRows.value = List.generate(collections.length, (_) => false);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching collections: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch collections: $e',
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Fetch collection items for a specific collection
  Future<void> fetchCollectionItems(int id) async {
    try {
      isLoadingItems.value = true;
      final items = await collectionRepository.fetchCollectionItems(id);
      collectionItems.assignAll(items);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching collection items: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch collection items: $e',
      );
    } finally {
      isLoadingItems.value = false;
    }
  }

  /// Fetch available product variants for selection
  Future<void> fetchAvailableVariants() async {
    try {
      isLoadingVariants.value = true;
      final variants = await collectionRepository.fetchAvailableVariants();
      availableVariants.assignAll(variants);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching variants: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch variants: $e',
      );
    } finally {
      isLoadingVariants.value = false;
    }
  }

  /// Insert new collection
  Future<int> insertCollection() async {
    try {
      isUpdating.value = true;
      debugPrint('Starting collection insertion...');

      // Validate the form
      if (!collectionForm.currentState!.validate()) {
        debugPrint('Collection form validation failed');
        TLoaders.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the required fields before proceeding.',
        );
        return -1;
      }

      final collectionModel = CollectionModel(
        collectionId: -1,
        name: collectionName.text.trim(),
        description: collectionDescription.text.trim(),
        imageUrl: imageUrl.value.isEmpty ? null : imageUrl.value,
        isActive: isActive.value,
        isFeatured: isFeatured.value,
        isPremium: isPremium.value,
        displayOrder: int.tryParse(displayOrder.text) ?? 0,
      );

      debugPrint('Inserting collection: ${collectionModel.name}');
      final newCollectionId = await collectionRepository
          .insertCollection(collectionModel.toJson(isUpdate: true));
      debugPrint('Collection inserted with ID: $newCollectionId');

      collectionId.value = newCollectionId;

      // Save the image if one was selected
      try {
        await mediaController.imageAssigner(newCollectionId,
            MediaCategory.collections.toString().split('.').last, true);
        debugPrint('Collection image uploaded successfully');
      } catch (e) {
        debugPrint('Error uploading image: $e');
        // Continue with collection creation even if image upload fails
      }

      // Add to local list
      allCollections.add(collectionModel.copyWith(collectionId: newCollectionId));
      debugPrint('Collection added to local list');

      // Show success message
      TLoaders.successSnackBar(
        title: "Success",
        message: 'Collection added successfully!',
      );

      return newCollectionId;
    } catch (e) {
      debugPrint('Error inserting collection: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
      return -1;
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update existing collection
  Future<bool> updateCollection() async {
    try {
      isUpdating.value = true;
      debugPrint('Starting collection update for ID: ${collectionId.value}...');

      // Validate the form
      if (!collectionForm.currentState!.validate()) {
        debugPrint('Collection form validation failed');
        TLoaders.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the required fields before proceeding.',
        );
        return false;
      }

      final collectionModel = CollectionModel(
        collectionId: collectionId.value,
        name: collectionName.text.trim(),
        description: collectionDescription.text.trim(),
        imageUrl: imageUrl.value.isEmpty ? null : imageUrl.value,
        isActive: isActive.value,
        isFeatured: isFeatured.value,
        isPremium: isPremium.value,
        displayOrder: int.tryParse(displayOrder.text) ?? 0,
      );

      debugPrint('Updating collection: ${collectionModel.name}');
      await collectionRepository.updateCollection(collectionModel.toJson(isUpdate: true));
      debugPrint('Collection updated successfully');

      // Update the image
      try {
        await mediaController.imageAssigner(collectionId.value,
            MediaCategory.collections.toString().split('.').last, true);
        debugPrint('Collection image updated successfully');
      } catch (e) {
        debugPrint('Error updating collection image: $e');
        // Continue even if image update fails
      }

      // Update local list
      final index = allCollections
          .indexWhere((c) => c.collectionId == collectionId.value);
      if (index != -1) {
        allCollections[index] = collectionModel;
        debugPrint('Updated collection in local list at index: $index');
      } else {
        debugPrint('Collection not found in local list, adding it');
        allCollections.add(collectionModel);
      }

      // Show success message
      TLoaders.successSnackBar(
        title: "Success",
        message: 'Collection updated successfully!',
      );

      return true;
    } catch (e) {
      debugPrint('Error updating collection: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// Delete collection
  Future<void> deleteCollection(int id) async {
    try {
      isUpdating.value = true;
      debugPrint('Deleting collection with ID: $id');

      await collectionRepository.deleteCollection(id);

      // Remove from local list
      allCollections.removeWhere((c) => c.collectionId == id);

      TLoaders.successSnackBar(
        title: "Success",
        message: 'Collection deleted successfully!',
      );
    } catch (e) {
      debugPrint('Error deleting collection: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: 'Failed to delete collection: $e',
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Add item to collection
  Future<bool> addCollectionItem({
    required int variantId,
    required int defaultQuantity,
    int? sortOrder,
  }) async {
    try {
      debugPrint('Adding item to collection ${collectionId.value}');

      final itemJson = {
        'collection_id': collectionId.value,
        'variant_id': variantId,
        'default_quantity': defaultQuantity,
        'sort_order': sortOrder ?? collectionItems.length,
      };

      final itemId = await collectionRepository.insertCollectionItem(itemJson);
      debugPrint('Item added with ID: $itemId');

      // Refresh collection items
      await fetchCollectionItems(collectionId.value);

      TLoaders.successSnackBar(
        title: "Success",
        message: 'Item added to collection!',
      );

      return true;
    } catch (e) {
      debugPrint('Error adding collection item: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: 'Failed to add item: $e',
      );
      return false;
    }
  }

  /// Update collection item quantity
  Future<bool> updateCollectionItemQuantity(int itemId, int newQuantity) async {
    try {
      debugPrint('Updating item $itemId quantity to $newQuantity');

      await collectionRepository.updateCollectionItem({
        'collection_item_id': itemId,
        'default_quantity': newQuantity,
      });

      // Update local list
      final index = collectionItems.indexWhere((i) => i.collectionItemId == itemId);
      if (index != -1) {
        collectionItems[index] = collectionItems[index].copyWith(
          defaultQuantity: newQuantity,
        );
      }

      TLoaders.successSnackBar(
        title: "Success",
        message: 'Item quantity updated!',
      );

      return true;
    } catch (e) {
      debugPrint('Error updating item quantity: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: 'Failed to update quantity: $e',
      );
      return false;
    }
  }

  /// Remove item from collection
  Future<void> removeCollectionItem(int itemId) async {
    try {
      debugPrint('Removing item with ID: $itemId');

      await collectionRepository.deleteCollectionItem(itemId);

      // Remove from local list
      collectionItems.removeWhere((i) => i.collectionItemId == itemId);

      TLoaders.successSnackBar(
        title: "Success",
        message: 'Item removed from collection!',
      );
    } catch (e) {
      debugPrint('Error removing collection item: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: 'Failed to remove item: $e',
      );
    }
  }

  /// Set collection details for editing
  void setCollectionDetail(CollectionModel collection) {
    try {
      collectionId.value = collection.collectionId;
      collectionName.text = collection.name;
      collectionDescription.text = collection.description ?? '';
      displayOrder.text = collection.displayOrder.toString();
      isActive.value = collection.isActive;
      isFeatured.value = collection.isFeatured;
      isPremium.value = collection.isPremium;
      imageUrl.value = collection.imageUrl ?? '';

      debugPrint('Collection details set for ID: ${collection.collectionId}');
    } catch (e) {
      debugPrint('Error setting collection details: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: 'Failed to load collection details: $e',
      );
    }
  }

  /// Clear form for new collection
  void clearForm() {
    collectionId.value = -1;
    collectionName.clear();
    collectionDescription.clear();
    displayOrder.text = '0';
    isActive.value = true;
    isFeatured.value = false;
    isPremium.value = false;
    imageUrl.value = '';
    collectionItems.clear();
    debugPrint('Collection form cleared');
  }

  /// Calculate total price of collection
  int calculateTotalPrice() {
    int total = 0;
    for (var item in collectionItems) {
      if (item.sellPrice != null) {
        total += (item.sellPrice! * item.defaultQuantity);
      }
    }
    return total;
  }

  /// Toggle collection active status
  Future<void> toggleActiveStatus(int id) async {
    try {
      final collection = allCollections.firstWhere((c) => c.collectionId == id);
      final newStatus = !collection.isActive;

      await collectionRepository.updateCollection({
        'collection_id': id,
        'is_active': newStatus,
      });

      // Update local list
      final index = allCollections.indexWhere((c) => c.collectionId == id);
      if (index != -1) {
        allCollections[index] = collection.copyWith(isActive: newStatus);
      }

      TLoaders.successSnackBar(
        title: "Success",
        message: 'Collection ${newStatus ? "activated" : "deactivated"}!',
      );
    } catch (e) {
      debugPrint('Error toggling active status: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: 'Failed to update status: $e',
      );
    }
  }

  /// Toggle featured status
  Future<void> toggleFeaturedStatus(int id) async {
    try {
      final collection = allCollections.firstWhere((c) => c.collectionId == id);
      final newStatus = !collection.isFeatured;

      await collectionRepository.updateCollection({
        'collection_id': id,
        'is_featured': newStatus,
      });

      // Update local list
      final index = allCollections.indexWhere((c) => c.collectionId == id);
      if (index != -1) {
        allCollections[index] = collection.copyWith(isFeatured: newStatus);
      }

      TLoaders.successSnackBar(
        title: "Success",
        message: 'Collection ${newStatus ? "featured" : "unfeatured"}!',
      );
    } catch (e) {
      debugPrint('Error toggling featured status: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: 'Failed to update status: $e',
      );
    }
  }

  /// Toggle premium status
  Future<void> togglePremiumStatus(int id) async {
    try {
      final collection = allCollections.firstWhere((c) => c.collectionId == id);
      final newStatus = !collection.isPremium;

      await collectionRepository.updateCollection({
        'collection_id': id,
        'is_premium': newStatus,
      });

      // Update local list
      final index = allCollections.indexWhere((c) => c.collectionId == id);
      if (index != -1) {
        allCollections[index] = collection.copyWith(isPremium: newStatus);
      }

      TLoaders.successSnackBar(
        title: "Success",
        message: 'Collection ${newStatus ? "set as premium" : "removed from premium"}!',
      );
    } catch (e) {
      debugPrint('Error toggling premium status: $e');
      TLoaders.errorSnackBar(
        title: "Error",
        message: 'Failed to update status: $e',
      );
    }
  }
}
