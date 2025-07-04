import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';

import 'package:ecommerce_dashboard/views/brands/all_brands/responsive-screens/brand_desktop.dart';
import 'package:ecommerce_dashboard/views/brands/all_brands/responsive-screens/brand_mobile.dart';
import 'package:ecommerce_dashboard/views/brands/all_brands/responsive-screens/brand_tablet.dart';
import 'package:flutter/material.dart';

class AllBrands extends StatelessWidget {
  const AllBrands({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      //  title: 'Brands',

      desktop: AllBrandsDesktopScreen(),
      tablet: AllBrandsTabletScreen(),
      mobile: AllBrandsMobileScreen(),
    );
  }
}
