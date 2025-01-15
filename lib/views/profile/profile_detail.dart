import 'package:flutter/material.dart';
import 'package:admin_dashboard_v3/common/widgets/appbar/TAppBar.dart';
import 'package:admin_dashboard_v3/common/widgets/table/big_table.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/profile/widgets/profile_menu.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';

class ProfileDetail extends StatelessWidget {
  ProfileDetail({super.key});

  final listOfMaps = [
    {
      'Order No': '001',
      'Order ID': 'A123',
      'Customer Name': 'John Doe',
      'Status': 'Shipped',
      'Cost': '\$100',
    },
    // other entries
  ];

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design
    var screenSize = MediaQuery.of(context).size;
    bool isWideScreen = screenSize.width > 1200;

    return Scaffold(
      appBar: const TAppBar(
        title: Text(
          'Customer Detail',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column for customer info and shipping
              Expanded(
                flex: isWideScreen ? 1 : 0,
                child: const Column(
                  children: [
                    CustomerInfoContainer(),
                    SizedBox(height: TSizes.spaceBtwItems),
                    ShippingContainer(),
                  ],
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              // Orders Table on large screens
              if (isWideScreen)
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: TColors.pureBlack,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text(
                            'Customer Orders',
                            style: Theme.of(context).textTheme.headlineSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        OBigTable(
                          items: listOfMaps,
                          columnKeys: const [
                            'Order No',
                            'Order ID',
                            'Customer Name',
                            'Status',
                            'Cost',
                          ],
                          enableDoubleTap: true,
                          innerTableItems: [],
                          innerColumnKeys: [],
                        ),
                      ],
                    ),
                  ),
                ),
              // For smaller screens, the Orders Table should stack below the customer info and shipping containers
              if (!isWideScreen)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: TColors.pureBlack,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text(
                            'Customer Orders',
                            style: Theme.of(context).textTheme.headlineSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        OBigTable(
                          items: listOfMaps,
                          columnKeys: const [
                            'Order No',
                            'Order ID',
                            'Customer Name',
                            'Status',
                            'Cost',
                          ],
                          enableDoubleTap: true,
                          innerTableItems: [],
                          innerColumnKeys: [],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerInfoContainer extends StatelessWidget {
  const CustomerInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensure it takes up available space
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > 800 ? 600 : double.infinity, // Responsive max width
      ),
      height: 550,
      decoration: BoxDecoration(
        color: TColors.pureBlack,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Customer Information',
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(TImages.user),
                ),
                const SizedBox(width: TSizes.spaceBtwSections),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ammer Saeed'),
                    Text('ammersaeed21@gmail.com'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfilemenu(
              onPressed: () {},
              title: "Username",
              value: 'ammersaeed',
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfilemenu(
              onPressed: () {},
              title: "City",
              value: 'Chishtian',
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfilemenu(
              onPressed: () {},
              title: "Phone Number",
              value: '03236508184',
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: OUserAdvanceInfoTile(firstTile: 'Last Order', secondTile: '7 Days Ago')),
                Expanded(child: OUserAdvanceInfoTile(firstTile: 'Average Order', secondTile: '3500')),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: OUserAdvanceInfoTile(firstTile: 'Last Order', secondTile: '7 Days Ago')),
                Expanded(child: OUserAdvanceInfoTile(firstTile: 'Average Order', secondTile: '3500')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShippingContainer extends StatelessWidget {
  const ShippingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > 800 ? 600 : double.infinity,
      ),
      height: 300,
      decoration: BoxDecoration(
        color: TColors.pureBlack,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Address Information',
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfilemenu(
              onPressed: () {},
              title: "Username",
              value: 'ammersaeed',
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfilemenu(
              onPressed: () {},
              title: "City",
              value: 'Chishtian',
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TProfilemenu(
              onPressed: () {},
              title: "Phone Number",
              value: '03236508184',
            ),
          ],
        ),
      ),
    );
  }
}

class OUserAdvanceInfoTile extends StatelessWidget {
  const OUserAdvanceInfoTile({
    super.key,
    required this.firstTile,
    required this.secondTile,
  });

  final String firstTile;
  final String secondTile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstTile,
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(
          secondTile,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
