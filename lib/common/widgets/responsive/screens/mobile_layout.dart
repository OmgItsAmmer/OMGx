import 'package:admin_dashboard_v3/common/widgets/layout/headers/header.dart';
import 'package:admin_dashboard_v3/common/widgets/layout/sidebar/tside_bar.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
   MobileLayout({super.key, this.body});
  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
        drawer: const TSideBar(),
        appBar:  THeader(scaffoldKey: scaffoldKey,),
        body: body ?? const SizedBox());
  }
}
