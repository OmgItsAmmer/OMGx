import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/enums.dart';

class ProductBrandcCategory extends StatelessWidget {
   const ProductBrandcCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRoundedContainer(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Drop Down
              Expanded(
                flex:2,
                child: DropdownButton<StockLocation>(
                  value: StockLocation.Shop,
                  items: StockLocation.values.map((StockLocation location) {
                    return DropdownMenuItem<StockLocation>(
                      value: location,
                      child: Text(
                        location.name.capitalize.toString(),
                        style: const TextStyle(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // Add your onChanged logic here
                  },
                ),
              ),

              const Expanded(child: Icon(Iconsax.add))

              // Add Icon
            ],

          ),
        ),

        const SizedBox(height: TSizes.spaceBtwSections,),

        TRoundedContainer(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Drop Down
              Expanded(
                flex:2,
                child: DropdownButton<StockLocation>(
                  value: StockLocation.Shop,
                  items: StockLocation.values.map((StockLocation location) {
                    return DropdownMenuItem<StockLocation>(
                      value: location,
                      child: Text(
                        location.name.capitalize.toString(),
                        style: const TextStyle(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // Add your onChanged logic here
                  },
                ),
              ),

              const Expanded(child: Icon(Iconsax.add))

              // Add Icon
            ],

          ),
        ),

        const SizedBox(height: TSizes.spaceBtwSections,),
        TRoundedContainer(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Drop Down
              Expanded(
                flex:2,
                child: DropdownButton<StockLocation>(
                  value: StockLocation.Shop,
                  items: StockLocation.values.map((StockLocation location) {
                    return DropdownMenuItem<StockLocation>(
                      value: location,
                      child: Text(
                        location.name.capitalize.toString(),
                        style: const TextStyle(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // Add your onChanged logic here
                  },
                ),
              ),

              const Expanded(child: Icon(Iconsax.add))

              // Add Icon
            ],

          ),
        ),


      ],
    );
  }
}
