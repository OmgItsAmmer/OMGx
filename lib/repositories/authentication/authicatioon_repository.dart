import 'package:admin_dashboard_v3/views/Navigation/navigation_drawer.dart';
import 'package:admin_dashboard_v3/views/orders/orderScreen.dart';
import 'package:admin_dashboard_v3/views/variants/variation_form_screen.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../main.dart';

import '../../supabase_strings.dart';
import '../../utils/exceptions/TFormatException.dart';
import '../../views/data_table.dart';
import '../../views/login/login.dart';
import '../../views/orders/order_detail.dart';
import '../../views/products/add_product_form.dart';
import '../../views/products/products.dart';
import '../../views/profile/profile_detail.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();

  @override
  void onReady() {
    // Get.put(BrandController());
    // Get.put(ProductController());
    // Get.put(UserController());
    // Get.put(CheckoutController());
    FlutterNativeSplash.remove();
    screenRedirect();
  } //Called from main.dart on app launch

  screenRedirect() async {
    try {
      final Session? session = supabase.auth.currentSession;
      final User? user = supabase.auth.currentUser;

      if (user != null && session != null) {
        if (user.emailConfirmedAt != null) {
          // Navigate to NavigationMenu only after confirming email is verified
          await Get.offAll(() =>  TDataTable());
        } else {
          // Navigate to VerifyEmailScreen for unverified emails
          // await Get.offAll(() => VerifyEmailScreen(email: user.email));
        }
      } else {
        // Local Storage
        deviceStorage.writeIfNull('IsFirstTime', true);

        // Check if it's the first time launching the app
        bool isFirstTime = deviceStorage.read('IsFirstTime') ?? true;

        // Navigate to LoginScreen or OnBoardingScreen based on the first-time check
        if (isFirstTime) {
            await Get.offAll(() => const LoginScreen());
        } else {
          //await Get.offAll(() => const OnBoardingScreen());
        }
      }
    } catch (e) {
      print('Error during redirection: $e');
      // Optionally show an error snack bar or handle navigation errors
      TLoader.errorsnackBar(
          title: 'Error',
          message: 'An error occurred during screen redirection.');
    }
  }

  // Future<UserCredential> loginWithEmailAndpassword(
  //     String email, String password) async {
  //   try {
  //     return await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     throw TFirebaseAuthException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }
  /*-------- Email & PasSSWOrd Sign-in --------*/
  /// [EmailAuthentication] - Sign in
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;
    } on FormatException catch (_) {
      throw const TFormatException();
    }
  }

//
//   /// [EmailAuthentication] - REGISTER
//   // Future<UserCredential> registeredWithEmailAndPassword(
//   //     String email, String password) async {
//   //   try {
//   //     return await _auth.createUserWithEmailAndPassword(
//   //         email: email, password: password);
//   //   }  catch (e) {
//   //     //throw 'Something went wrong. Please try again';
//   //     print('Caught error: $e of type: ${e.runt  imeType}');
//   //     throw e;
//   //   }
//   // }
//
//
//
//   /// [ReAuthenticate] - ReAuthenticate User
//
//   // Future<void> reAuthenticateWithEmailAndPassword(String email , String password) async
//   // {
//   //   try
//   //       {
//   //         //Creade a Creduitional
//   //          AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
//   //          //ReAuthenticate
//   //         await _auth.currentUser!.reauthenticateWithCredential(credential);
//   //
//   //       }  on FirebaseAuthException catch (e) {
//   //     throw TFirebaseAuthException(e.code).message;
//   //   } on FirebaseException catch (e) {
//   //     throw TFirebaseException(e.code).message;
//   //   } on FormatException catch (_) {
//   //     throw const TFormatException();
//   //   } on PlatformException catch (e) {
//   //     throw TPlatformException(e.code).message;
//   //   } catch (e) {
//   //     throw 'Something went wrong. Please try again';
//   //   }
//   //
//   // }
//
//
//
//   /// [EmailVerification] - MAIL VERIFICATION
//   // Future<void> sendEmailVerification() async {
//   //   try {
//   //
//   //  // NO NEED SUPABASE DOES IT AUTOMATICALLY
//   //
//   //
//   //
//   //   }  on FormatException catch (_) {
//   //     throw const TFormatException();
//   //   } on PlatformException catch (e) {
//   //     throw TPlatformException(e.code).message;
//   //   } catch (e) {
//   //     throw 'Something went wrong. Please try again';
//   //   }
//   // }
//
//   /// [EmailAuthentication] - FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      supabase.auth.updateUser(UserAttributes(
        email: email,
        nonce: '123456',
      ));

      await supabase.auth.reauthenticate();
    } on FormatException catch (_) {
      throw const TFormatException();
    }
  }

//
// /*=------------- Federated identity & social sign-in ------------*/
//   /// [GoogleAuthentication] - GOOGLE
//   // Future<UserCredential> signInWithGoogle() async {
//   //   try {
//   //     final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
//   //
//   //     final GoogleSignInAuthentication? googleAuth =
//   //         await userAccount?.authentication;
//   //
//   //
//   //
//   //     //Create a new creditional
//   //     final credentials = GoogleAuthProvider.credential(
//   //         accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
//   //
//   //     //Once signed in,return the Usercedential
//   //     return await _auth.signInWithCredential(credentials);
//   //
//   //   } on FirebaseAuthException catch (e) {
//   //     throw TFirebaseAuthException(e.code).message;
//   //   } on FirebaseException catch (e) {
//   //     throw TFirebaseException(e.code).message;
//   //   } on FormatException catch (_) {
//   //     throw const TFormatException();
//   //   } on PlatformException catch (e) {
//   //     throw TPlatformException(e.code).message;
//   //   } catch (e) {
//   //     throw 'Something went wrong. Please try again';
//   //
//   //   }
//   // }
//
//   ///[FacebookAuthentication] - FACEBOOK |
// // /*------------------oo ./end Federated identity & social sign-in -----------------*/
// //   /// [Logoutuser] - Valid for any authentication.
// //   Future<void> logout() async {
// //     try {
// //       await FirebaseAuth.instance.signOut();
// //       Get.offAll(() => const LoginScreen());
// //     } on FirebaseAuthException catch (e) {
// //       throw TFirebaseAuthException(e.code).message;
// //     } on FirebaseException catch (e) {
// //       throw TFirebaseException(e.code).message;
// //     } on FormatException catch (_) {
// //       throw const TFormatException();
// //     } on PlatformException catch (e) {
// //       throw TPlatformException(e.code).message;
// //     } catch (e) {
// //       throw 'Something went wrong. Please try again';
// //     }
// //   }
//
  Future<void> deleteAccount() async {
    try {
      // Admin client with Service Role key (store securely, e.g., in an environment variable)
      final supabaseAdmin = SupabaseClient(
        SupabaseStrings.projectUrl,
        SupabaseStrings.service_role_key,
      );

      final User? currentUser = Supabase.instance.client.auth.currentUser;

      // Ensure the user is logged in before proceeding
      if (currentUser == null) {
        TLoader.errorsnackBar(title: "Error", message: "User is Null");
        return;
      }

      // Delete user with the admin client
      await supabaseAdmin.auth.admin.deleteUser(currentUser.id);
      TLoader.successSnackBar(title: "Account Deleted Succefully");
      Get.to(() => const LoginScreen());
    } on FormatException catch (_) {
      throw const TFormatException();
    }
  }
//
//   Future<void> logOut() async {
//
//     await supabase.auth.signOut();
//
//   }
}
