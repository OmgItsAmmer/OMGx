
import 'package:admin_dashboard_v3/common/layouts/templates/site_template.dart';

import 'package:admin_dashboard_v3/views/brands/all_brands/responsive-screens/brand_desktop.dart';
import 'package:admin_dashboard_v3/views/brands/all_brands/responsive-screens/brand_mobile.dart';
import 'package:admin_dashboard_v3/views/brands/all_brands/responsive-screens/brand_tablet.dart';
import 'package:flutter/material.dart';

class AllBrands extends StatelessWidget {
  const AllBrands({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
    //  title: 'Brands',
     
        desktop: const AllBrandsDesktopScreen(),
        tablet:  const AllBrandsTabletScreen(),
        mobile:  const AllBrandsMobileScreen(),
      
    );
  }
}
