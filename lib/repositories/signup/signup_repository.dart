import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../../../common/widgets/loaders/tloaders.dart';
import '../../../main.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class SignUpRepository extends GetxController {

  static SignUpRepository get instance => Get.find();




  Future<void> insertUserRecord(Map<String,dynamic> json) async {
    try {
      await supabase.from('users').insert(json);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


}