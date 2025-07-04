import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/views/profile/profile/resposive_screens/profile_desktop.dart';
import 'package:ecommerce_dashboard/views/profile/profile/resposive_screens/profile_mobile.dart';
import 'package:ecommerce_dashboard/views/profile/profile/resposive_screens/profile_tablet.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: ProfileDesktop(),
      tablet: ProfileTablet(),
      mobile: ProfileMobile(),
    );
  }
}
