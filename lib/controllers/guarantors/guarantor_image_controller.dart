import 'package:get/get.dart';
import '../../Models/image/image_model.dart';
import '../../utils/constants/enums.dart';
import '../media/media_controller.dart';

class GuarantorImageController extends GetxController {
  static GuarantorImageController get instance => Get.find();
  final MediaController mediaController = Get.find<MediaController>();


  
  final Rx<ImageModel?> guarantor1Image = Rx<ImageModel?>(null);

  // Image variables for each guarantor
  final Rx<ImageModel?> guarantor2Image = Rx<ImageModel?>(null);

  // Set image for specific guarantor
  void setGuarantorImage(int guarantorIndex, ImageModel? image) {
    if (image == null) return;
    
    // Only update if the image is meant for guarantors
    if (image.folderType != MediaCategory.guarantors.toString().split('.').last) return;
    
    if (guarantorIndex == 1) {
      guarantor1Image.value = image;
    } else if (guarantorIndex == 2) {
      guarantor2Image.value = image;
    }
  }

  // Get image for specific guarantor
  ImageModel? getGuarantorImage(int guarantorIndex) {
    return guarantorIndex == 1 ? guarantor1Image.value : guarantor2Image.value;
  }

  // Clear images
  void clearImages() {
    guarantor1Image.value = null;
    guarantor2Image.value = null;
  }
}
