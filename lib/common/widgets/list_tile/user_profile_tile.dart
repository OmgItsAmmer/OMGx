import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/user/user_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../images/t_circular_image.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller   = Get.put( UserController());
    return  ListTile(
      leading: TCircularImage(image: TImages.user,width: 50,height: 50,padding: 0,),
      title: Text(controller.current_user?.value['first_name'] + " " + controller.current_user?.value['last_name'] ?? "no user found!",style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),),
      subtitle: Text(controller.current_user?.value['email'],style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),),
      trailing: IconButton(onPressed: onPressed, icon: Icon(Iconsax.edit,color: TColors.white,)),
    );
  }
}

