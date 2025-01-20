import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AllProductDesktopScreen extends StatelessWidget {
  const AllProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 760,
      child: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace,),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Bread Crumbss

            //Table body



          ],
        ),),
      ),
    );
  }
}
