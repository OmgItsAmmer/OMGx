import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/variants/widgets/variant_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../utils/constants/colors.dart';

class OrderDetailScree extends StatelessWidget {
  const OrderDetailScree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text(
          '#ef4323',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          children: [
            Column(
              children: [
                const OOrderInfo(),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                Container(
                  height: 200,
                  width: 800,
                  decoration: BoxDecoration(
                    color: TColors.pureBlack,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2), // Shadow color
                        spreadRadius: 5, // Spread of the shadow
                        blurRadius: 10, // Blur intensity
                        offset: const Offset(
                            0, 5), // Offset for horizontal and vertical shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Order Summary'),
                      Expanded(
                        child: ListView.separated(
                            separatorBuilder: (_, __) => const SizedBox(
                                  height: TSizes.spaceBtwItems,
                                ),
                            itemCount: 3,
                            itemBuilder: (_, index) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(TImages.productImage1),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: '1x Price'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      readOnly: true,
                                      initialValue: '200',
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Quantity'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      readOnly: true,
                                      initialValue: '3',
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Total Price'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      readOnly: true,
                                      initialValue: '600',
                                    ),
                                  ),
                                ],
                              );
                            }),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OOrderInfo extends StatelessWidget {
  const OOrderInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 800,
      decoration: BoxDecoration(
        color: TColors.pureBlack,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2), // Shadow color
            spreadRadius: 5, // Spread of the shadow
            blurRadius: 10, // Blur intensity
            offset:
                const Offset(0, 5), // Offset for horizontal and vertical shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('Order Information'),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          Row(
            children: [
              const Expanded(
                child: OOrderInfoTile(
                  title: 'Date',
                  value: '07-08-2024',
                ),
              ),
              const Expanded(
                child: OOrderInfoTile(
                  title: 'Date',
                  value: '07-08-2024',
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('Status'),
                    ODropDownMenu(
                      itemsList: const ['Option 1', 'Option 2'],
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
              const Expanded(
                child: OOrderInfoTile(
                  title: 'Date',
                  value: '07-08-2024',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OOrderInfoTile extends StatelessWidget {
  const OOrderInfoTile({
    super.key,
    this.title,
    this.value,
  });

  final title;
  final value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        const SizedBox(
          height: TSizes.spaceBtwInputFields,
        ),
        Text(value)
      ],
    );
  }
}
