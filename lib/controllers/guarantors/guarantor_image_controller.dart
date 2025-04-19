import 'package:get/get.dart';
import '../../Models/image/image_model.dart';
import '../../utils/constants/enums.dart';
import '../media/media_controller.dart';

class GuarantorImageController extends GetxController {
  static GuarantorImageController get instance => Get.find();
  final MediaController mediaController = Get.find<MediaController>();

  // Guarantor 1 Image
  RxInt guarantor1Id = 1.obs;
  Rx<ImageModel?> guarantor1Image = Rx<ImageModel?>(null);

  // Guarantor 2 Image
  RxInt guarantor2Id = 2.obs;
  Rx<ImageModel?> guarantor2Image = Rx<ImageModel?>(null);

  // The guarantor entity type for all guarantors
  final String entityType = MediaCategory.guarantors.toString().split('.').last;

  @override
  void onInit() {
    super.onInit();
    fetchGuarantorImages();
  }

  // Method to fetch guarantor images on initial load
  Future<void> fetchGuarantorImages() async {
    await mediaController.fetchImageForOwner(guarantor1Id.value, entityType);
    await mediaController.fetchImageForOwner(guarantor2Id.value, entityType);

    // Get images from the controller's cache if available
    updateGuarantorImagesFromCache();
  }

  // Get images from the MediaController's cache
  void updateGuarantorImagesFromCache() {
    guarantor1Image.value =
        mediaController.getImageForOwner(guarantor1Id.value, entityType);
    guarantor2Image.value =
        mediaController.getImageForOwner(guarantor2Id.value, entityType);
  }

  // Select image for guarantor 1
  Future<void> selectGuarantor1Image() async {
    await mediaController.selectImagesForOwner(
      ownerId: guarantor1Id.value,
      ownerType: entityType,
      allowSelection: true,
      multipleSelection: false,
    );
    updateGuarantorImagesFromCache();
  }

  // Select image for guarantor 2
  Future<void> selectGuarantor2Image() async {
    await mediaController.selectImagesForOwner(
      ownerId: guarantor2Id.value,
      ownerType: entityType,
      allowSelection: true,
      multipleSelection: false,
    );
    updateGuarantorImagesFromCache();
  }

  // Update guarantor IDs with real database IDs after they're created
  void updateGuarantorIds(List<int> guarantorIds) {
    if (guarantorIds.length >= 2) {
      // Update the ID values
      guarantor1Id.value = guarantorIds[0];
      guarantor2Id.value = guarantorIds[1];

      // Update the multipleDisplayImages in MediaController with new IDs
      mediaController.updateOwnerIds(1, guarantor1Id.value, entityType);
      mediaController.updateOwnerIds(2, guarantor2Id.value, entityType);
    }
  }

  // Save guarantor images to database
  Future<void> saveGuarantorImages(List<int> guarantorIds) async {
    // Update the IDs first
    updateGuarantorIds(guarantorIds);

    List<MediaOwnerImage> ownersWithImages = [];

    // Add guarantor 1 image if available
    if (guarantor1Image.value != null) {
      ownersWithImages.add(MediaOwnerImage(
        ownerId: guarantor1Id.value,
        ownerType: entityType,
        image: guarantor1Image.value!,
      ));
    }

    // Add guarantor 2 image if available
    if (guarantor2Image.value != null) {
      ownersWithImages.add(MediaOwnerImage(
        ownerId: guarantor2Id.value,
        ownerType: entityType,
        image: guarantor2Image.value!,
      ));
    }

    // Save images if any are available
    if (ownersWithImages.isNotEmpty) {
      await mediaController.assignImagesForMultipleOwners(ownersWithImages);
    }
  }

  // Clear all guarantor images
  void clearGuarantorImages() {
    mediaController
        .clearOwnerImages([guarantor1Id.value, guarantor2Id.value], entityType);
    guarantor1Image.value = null;
    guarantor2Image.value = null;
  }
}
