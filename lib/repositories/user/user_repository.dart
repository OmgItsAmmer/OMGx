
import 'package:admin_dashboard_v3/Models/user/user_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../utils/exceptions/platform_exceptions.dart';

class UserRespository extends GetxController {
  static UserRespository get instance => Get.find();

//   //Function to save user data to Firestore

//
//Function to fetch user details based on user ID.
  Future<List<UserModel>> fetchUserDetials(String? email) async {
    try {
      if (email == null) throw 'Email cannot be null';
      final data = await Supabase.instance.client
          .from('users')
          .select()
          .eq('email', email);
      final userList = data.map((item) {
        return UserModel.fromJson(item);
      }).toList();

      return userList;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateProfileData(Map<String, dynamic> json, int userId) async {
    try {
      await supabase.from('users').update(json).eq('user_id', userId);
      TLoaders.successSnackBar(
          title: 'Profile Updated',
          message: 'your profile is updated Successfully');
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

//Function to update user details in Firestore
// Future<void> updateUserDetails(UserModel updateUser) async {
//   try {
//    await _db.collection("Users").doc(updateUser.id).update(updateUser.UserModelToJson());
//
//   } on FirebaseException catch (e) {
//     throw TFirebaseException(e.code).message;
//   } on FormatException catch (_) {
//     throw const TFormatException();
//   } on PlatformException catch(e) {
//     throw TPlatformException(e.code).message;
//   } catch (e){
//     throw 'Something went wrong. Please try again';
//   }
// }

//Update any field in specific Users Collection
// Future<void> updateSingleField({required Map<String, dynamic> json}) async {
//   try {
//     // Retrieve the current authenticated user ID
//     final String? userId = AuthenticationRepository.instance.authUser?.uid;
//
//     // Check if user ID is null
//     if (userId == null) {
//       throw 'User not authenticated';
//     }
//
//     // Log to check when the update starts
//     print("Starting the update for user: $userId");
//
//     // Update the user document in Firestore
//     await _db.collection('Users').doc(userId).update(json);
//
//     // Log after update completion
//     print("Document successfully updated");
//
//   } on FirebaseException catch (e) {
//     print("FirebaseException: ${e.code} - ${e.message}");
//     throw TFirebaseException(e.code).message;
//   } on FormatException catch (e) {
//     print("FormatException: $e");
//     throw const TFormatException();
//   } on PlatformException catch (e) {
//     print("PlatformException: ${e.code} - ${e.message}");
//     throw TPlatformException(e.code).message;
//   } catch (e) {
//     print("Generic exception: $e");
//     throw 'Something went wrong. Please try again';
//   }
// }

//Function to remove user data from firestore
// Future<void> removeUserRecord(String userId) async {
//   try {
//     await _db.collection("Users").doc(userId).delete();
//
//   } on FirebaseException catch (e) {
//     throw TFirebaseException(e.code).message;
//   } on FormatException catch (_) {
//     throw const TFormatException();
//   } on PlatformException catch(e) {
//     throw TPlatformException(e.code).message;
//   } catch (e){
//     throw 'Something went wrong. Please try again';
//   }
// }
// Future<String> uploadImage(String path, XFile image) async
// {
//   try {
//     final ref = FirebaseStorage.instance.ref(path).child(image.name);
//     await ref.putFile(File(image.path));
//     final url = await ref.getDownloadURL();
//     return url;
//   } on FirebaseException catch (e) {
//     throw TFirebaseException(e.code).message;
//   } on FormatException catch (_) {
//     throw const TFormatException();
//   } on PlatformException catch (e) {
//     throw TPlatformException(e.code).message;
//   } catch (e) {
//     throw 'Something went wrong. Please try again';
//   }
// }
}
