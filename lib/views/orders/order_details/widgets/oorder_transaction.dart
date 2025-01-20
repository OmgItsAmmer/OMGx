import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class OrderTransaction extends StatelessWidget {
  const OrderTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          //Adjust as per your newds
          Row(
            children: [
              Expanded(
                  flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                  child: Row(
                    children: [
                      const TRoundedImage(
                        imageurl: TImages.paypal,
                        isNetworkImage: false,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment via {order method}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ), //TODO add payment method to database
                          //Adjust your payment Method Fee if any
                          Text(
                            'Payment method fee 25',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ))
                    ],
                  )),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: Theme.of(context).textTheme.titleLarge,
                      ), //TODO add payment method to database
                      //Adjust your payment Method Fee if any
                      Text(
                        'April 21,2025',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.labelMedium,
                      ), //TODO add payment method to database
                      //Adjust your payment Method Fee if any
                      Text(
                        'total amount',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )),


            ],
          )
        ],
      ),
    );
  }
}
