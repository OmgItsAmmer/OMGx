import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../table/product_table.dart';

class AllProductDesktopScreen extends StatelessWidget {
  const AllProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 900,
      child: SingleChildScrollView(
        child: TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text('Products',style: Theme.of(context).textTheme.headlineMedium ,),
            //Bread Crumbss
          
            //Table body
            const ProductTable()
          
          
          ],
                  ),
        ),
      ),
    );
  }
}
