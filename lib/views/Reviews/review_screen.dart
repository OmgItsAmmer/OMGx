import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/Reviews/responsive-screens/review_desktop.dart';
import 'package:ecommerce_dashboard/views/Reviews/responsive-screens/review_mobile.dart';
import 'package:ecommerce_dashboard/views/Reviews/responsive-screens/review_tablet.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: ReviewDesktopScreen(),
      tablet: ReviewTabletScreen(),
      mobile: ReviewMobileScreen(),
    );
  }
}
