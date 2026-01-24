import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/views/collections/collection_detail/responsive_screens/collection_detail_desktop.dart';
import 'package:ecommerce_dashboard/views/collections/collection_detail/responsive_screens/collection_detail_mobile.dart';
import 'package:ecommerce_dashboard/views/collections/collection_detail/responsive_screens/collection_detail_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CollectionDetailScreen extends StatefulWidget {
  const CollectionDetailScreen({super.key});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  final FocusNode _screenFocusNode =
      FocusNode(debugLabel: 'CollectionDetailScreen');

  @override
  void initState() {
    super.initState();

    final controller = Get.find<CollectionController>();
    
    // Initialize new collection form only if no collection is selected
    // If collectionId is -1 and no arguments are passed, it's a new collection
    if (Get.arguments == null && controller.collectionId.value == -1) {
      controller.clearForm();
    }

    // Fetch available variants for selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshControllerData();
    });
  }

  @override
  void dispose() {
    _screenFocusNode.dispose();
    super.dispose();
  }

  // Refresh data in controllers
  void _refreshControllerData() {
    final controller = Get.find<CollectionController>();
    controller.fetchAvailableVariants();
    
    // If editing, fetch collection items
    if (controller.collectionId.value != -1) {
      controller.fetchCollectionItems(controller.collectionId.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _screenFocusNode,
      autofocus: true,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
              const SaveIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): const DiscardIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveIntent: CallbackAction<SaveIntent>(
              onInvoke: (_) => _handleSave(),
            ),
            DiscardIntent: CallbackAction<DiscardIntent>(
              onInvoke: (_) => _handleDiscard(),
            ),
          },
          child: const TSiteTemplate(
            useLayout: false,
            desktop: CollectionDetailDesktop(),
            tablet: CollectionDetailTablet(),
            mobile: CollectionDetailMobile(),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final collectionController = Get.find<CollectionController>();
    if (collectionController.isUpdating.value) return;

    try {
      collectionController.isUpdating.value = true;
      if (collectionController.collectionId.value == -1) {
        await collectionController.insertCollection();
      } else {
        await collectionController.updateCollection();
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      collectionController.isUpdating.value = false;
    }
  }

  void _handleDiscard() {
    final collectionController = Get.find<CollectionController>();
    if (collectionController.isUpdating.value) return;
    collectionController.clearForm();
    Navigator.of(context).pop();
  }
}

class SaveIntent extends Intent {
  const SaveIntent();
}

class DiscardIntent extends Intent {
  const DiscardIntent();
}
