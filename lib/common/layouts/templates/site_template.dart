import 'package:admin_dashboard_v3/common/widgets/responsive/responsive_design.dart';
import 'package:admin_dashboard_v3/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:admin_dashboard_v3/common/widgets/responsive/screens/mobile_layout.dart';
import 'package:admin_dashboard_v3/common/widgets/responsive/screens/tablet_layout.dart';
import 'package:admin_dashboard_v3/common/widgets/search/search_overlay.dart';
import 'package:flutter/material.dart';

class TSiteTemplate extends StatelessWidget {
  const TSiteTemplate(
      {super.key,
      this.desktop,
      this.tablet,
      this.mobile,
      this.useLayout = true});
  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;
  final bool useLayout;
  @override
  Widget build(BuildContext context) {
    // Make sure content is not null for each layout
    final desktopContent = desktop ?? Container();
    final tabletContent = tablet ?? desktop ?? Container();
    final mobileContent = mobile ?? tablet ?? desktop ?? Container();

    return Scaffold(
      body: Stack(
        children: [
          TResponsiveWidget(
            desktop: useLayout
                ? DesktopLayout(body: desktopContent)
                : desktopContent,
            tablet:
                useLayout ? TabletLayout(body: tabletContent) : tabletContent,
            mobile:
                useLayout ? MobileLayout(body: mobileContent) : mobileContent,
          ),

          // Search overlay at the highest level
       //   const TSearchOverlay(),
        ],
      ),
    );
  }
}
