import 'package:ecommerce_dashboard/Models/user/user_model.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/controllers/purchase_sales/purchase_sales_controller.dart';
import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
import 'package:ecommerce_dashboard/controllers/salesman/salesman_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../repositories/authentication/authicatioon_repository.dart';
import '../../repositories/user/user_repository.dart';
import '../../utils/constants/enums.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../views/login/login.dart';
import '../customer/customer_controller.dart';
import '../dashboard/dashboard_controoler.dart';
import '../media/media_controller.dart';
import '../product/product_controller.dart';
import '../shop/shop_controller.dart';
import '../vendor/vendor_controller.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final UserRespository userRespository = Get.put(UserRespository());
//  final StartUpController startUpController =  Get.put(StartUpController());
  // final SalesController salesController =  Get.put(SalesController());
  final MediaController mediaController = Get.put(MediaController());
  // final ProductImagesController productImagesController = Get.put(ProductImagesController());

  final profileLoading = false.obs;

  //Rx<UserModel> user = UserModel.empty().obs;
  final hidePassword = false.obs;
  final imageUploading = false.obs;

  RxList<UserModel> userData = <UserModel>[].obs;

  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();

  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  Rx<UserModel> currentUser = UserModel.empty()
      .obs; // to store the product Variation detail based on Size

  ///Profile Screen
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  RxBool isUpdating = false.obs;

  // final RxBool isLoading = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //  // fetchUserRecord();
  // }

  Future<bool> fetchUserRecord() async {
    try {
      profileLoading.value = true;

      final user = supabase.auth.currentUser;

      if (user == null) {
        // User is not logged in, navigate to login screen
        TLoaders.errorSnackBar(
            title: "Oh Snap!",
            message: "Session expired. Please log in again.");
        Get.offAll(() => const LoginScreen()); // Navigate and clear stack
        return false;
      }

      final userDetail = await userRespository.fetchUserDetials(user.email);
      userData.assignAll(userDetail);

      // For debugging
      UserModel matchedUser =
          userData.firstWhere((value) => value.email == user.email);
      currentUser.value = matchedUser;

      SalesController.instance.setupUserDetails();
      PurchaseSalesController.instance.setupUserDetails();

      // setupProfileDetails();

        //Setting UserDetails in App
        //   startUpController.setupUserDetails(currentUser.value);
        return true;
    } catch (e) {
      // TLoaders.errorSnackBar(
      //     title: "User Details Not Found!",
      //     message: "Restart the app to fetch user details");
      return false;
    } finally {
      profileLoading.value = false;
    }
  }

  void setupProfileDetails() {
    try {
      firstName.text = currentUser.value.firstName;
      lastName.text = currentUser.value.lastName;
      email.text = currentUser.value.email;
      phoneNumber.text = currentUser.value.phoneNumber;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
    }
  }

  Future<void> updateProfile() async {
    try {
      isUpdating.value = true;
      final userModel = UserModel(
          userId: currentUser.value.userId,
          firstName: firstName.text,
          lastName: lastName.text,
          phoneNumber: phoneNumber.text,
          email: email.text);
      mediaController.clearProfileImageCache();
      await mediaController.imageAssigner(userModel.userId,
          MediaCategory.users.toString().split('.').last, true);

      final json = userModel.toJson(isUpdate: true);
      await userRespository.updateProfileData(json, currentUser.value.userId);
      currentUser.value = userModel;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
    } finally {
      isUpdating.value = false;
    }
  }

  // Future<void> saveUserRecord(UserCredential? userCredentials) async {
  //
  //   try {
  //
  //
  //   } catch (e) {
  //     TLoader.warningSnackBar(
  //         title: "Data not Saved",
  //         message:
  //         "Something went wrong while saving your information. You can resave our data in yor profile");
  //   }
  // }

  void DeleteAccountWarning() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: 'Delete Account',
        middleText:
            'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
        confirm: ElevatedButton(
            onPressed: () async => deleteUserAccount(),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
              child: Text('Delete'),
            )),
        cancel: OutlinedButton(
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text('Cancel')));
  }

  void deleteUserAccount() async {
    try {
      ///First Re=authenticate user

      TFullScreenLoader.openLoadingDialog('Processing', TImages.docerAnimation);
      AuthenticationRepository.instance.deleteAccount();
      //Get.to(() => const ReAuthLoginForm());
      TFullScreenLoader.stopLoading();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Future<void> reAuthenticateEmailAndPassworduser() async {
  //   TFullScreenLoader.openLoadingDialog('Processing', TImages.docerAnimation);
  //   try {
  //     //Check Internet
  //     final isConnected = await NetworkManager.instance.isConnected();
  //     if (!isConnected) {
  //       TFullScreenLoader.stopLoading();
  //       return;
  //     }
  //     if (!reAuthFormKey.currentState!.validate()) {
  //       TFullScreenLoader.stopLoading();
  //       return;
  //     }
  //
  //     await AuthenticationRepository.instance.deleteAccount();
  //     TFullScreenLoader.stopLoading();
  //     Get.offAll(() => const LoginScreen());
  //   } catch (e) {
  //     TFullScreenLoader.stopLoading();
  //     TLoader.warningSnackBar(title: 'Oh Snap', message: e.toString());
  //   }
  // }

  // Future<void> logout() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser; // Get the current user
  //
  //     if (user != null) {
  //       // Check the user's provider data
  //       for (var profile in user.providerData) {
  //         // Handle Google sign-out
  //         if (profile.providerId == 'google.com') {
  //           await googleSignIn.signOut();
  //           print("Google user logged out.");
  //         }
  //
  //         // Handle Facebook sign-out
  //         if (profile.providerId == 'facebook.com') {
  //           //  await FacebookAuth.instance.logOut();
  //           print("Facebook user logged out.");
  //         }
  //       }
  //
  //       // Finally, sign out from Firebase
  //       await FirebaseAuth.instance.signOut();
  //       print("User logged out from Firebase.");
  //       Get.offAll(() => const LoginScreen());
  //     } else {
  //       print("No user is currently signed in.");
  //     }
  //   } catch (e) {
  //     TFullScreenLoader.stopLoading();
  //     TLoader.warningSnackBar(title: 'Oh Snap', message: e.toString());
  //   }
  // }

  //uploadUserProfilePicture() async {
  //   try {
  //
  //     final  image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70,maxHeight: 512,maxWidth: 512);
  //     if(image != null)
  //     {
  //       imageUploading.value = true;
  //       final imageUrl = await userRespository.uploadImage('Users/Images/Profile/', image);
  //       //Update user Image Record
  //       Map<String , dynamic> json = {'ProfilePicture' : imageUrl };
  //       // await userRespository.updateSingleField(json: json);
  //       user.value.profilePicture = imageUrl;
  //       user.refresh();
  //       TLoader.successSnackBar(title: 'Congratulations',message: 'Your Profile Image has been updated');
  //     }
  //   }
  //   catch(e)
  //   {
  //     TLoader.errorsnackBar(title: 'Oh Snap',message: 'Something went wrong : $e');
  //
  //   }
  //   finally
  //       {
  //         imageUploading.value = false;
  //       }
  //
  //
  // }
  Future<void> logOut() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Logging Out', TImages.docerAnimation);
      await supabase.auth.signOut();
      mediaController.clearProfileImageCache();
      TFullScreenLoader.stopLoading();
      Get.to(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();

      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  Future<void> setUpApp() async {
    try {
      final isUserFetched = await fetchUserRecord();
      if (isUserFetched) {
        setupProfileDetails();
        OrderController.instance.fetchOrders();
        SalesController.instance.setupUserDetails();
        PurchaseSalesController.instance.setupUserDetails();
     //   DashboardController.instance.fe();
        CustomerController.instance.fetchAllCustomers();
        ProductController.instance.fetchProducts();
        SalesmanController.instance.fetchAllSalesman();
        VendorController.instance.fetchAllVendors();
        ShopController.instance.fetchShop();
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
