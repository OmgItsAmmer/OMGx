import 'package:admin_dashboard_v3/Models/orders/order_model.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/utils/helpers/pricing_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/orders/order_item_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/sizes.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});
  final OrderModel order;
  @override
  Widget build(BuildContext context) {
    final subTotal = order.orderItems?.fold(
      0.0,
          (previousValue, element) =>
      previousValue + (element.price * element.quantity), // Multiply price by quantity
    ).obs;
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          //Items
          Obx(
            (){


              return ListView.separated(
                shrinkWrap: true,

                separatorBuilder: (_, __) => const SizedBox(
                  height: TSizes.spaceBtwItems,

                ),
                itemCount: order.orderItems?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final item = order.orderItems?[index];
                  return  Row(
                    children: [
                      Expanded(
                          child: Row(
                            children: [
                              //TODO add image using variant model
                              const TRoundedImage(
                                height: 60,
                                width: 60,
                                imageurl: TImages.productImage1,
                                backgroundColor: TColors.primaryBackground,
                                isNetworkImage: false,
                              ),
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item!.variantName ?? '',style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                      //TODO Variantion Description
                                    ],
                                  ))
                            ],
                          )),
                      const SizedBox(width: TSizes.spaceBtwItems,),
                      SizedBox(width: TSizes.xl*2,
                        child: Text(item.price.toString(),style: Theme.of(context).textTheme.bodyLarge,),),
                      SizedBox(width: TDeviceUtils.isMobileScreen(context) ? TSizes.xl*1.4 : TSizes.xl*2,
                        child: Text(item.quantity.toString(),style: Theme.of(context).textTheme.bodyLarge,),),
                      SizedBox(width: TDeviceUtils.isMobileScreen(context) ? TSizes.xl*1.4 : TSizes.xl*2,
                        child: Text((item.price * item.quantity ).toString(),style: Theme.of(context).textTheme.bodyLarge,),)
                    ],
                  );
                },
              );

            }
          ),
          const SizedBox(height: TSizes.spaceBtwSections,),
          TRoundedContainer(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            backgroundColor: TColors.primaryBackground,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SubTotal' , style: Theme.of(context).textTheme.titleLarge,),
                    Obx(() => Text(subTotal?.value.toString() ?? ' ',style: Theme.of(context).textTheme.titleLarge,))
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount' , style: Theme.of(context).textTheme.titleLarge,),
                    Text('0.00',style: Theme.of(context).textTheme.titleLarge,)
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping' , style: Theme.of(context).textTheme.titleLarge,),
                    Text('143',style: Theme.of(context).textTheme.titleLarge,)
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tax' , style: Theme.of(context).textTheme.titleLarge,),
                    Text('32',style: Theme.of(context).textTheme.titleLarge,)
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total' , style: Theme.of(context).textTheme.titleLarge,),
                    Text('use calc',style: Theme.of(context).textTheme.titleLarge,)
                    // /TPricingCalculator.calculateTotalPrice(subTotal, '')
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
