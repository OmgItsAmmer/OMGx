import 'package:ecommerce_dashboard/common/widgets/layout/headers/header.dart';
import 'package:ecommerce_dashboard/common/widgets/layout/sidebar/tside_bar.dart';
import 'package:ecommerce_dashboard/common/widgets/responsive/content_wrapper.dart';
import 'package:flutter/material.dart';

class TabletLayout extends StatelessWidget {
  TabletLayout({super.key, this.body});
  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: const TSideBar(),
        appBar: THeader(
          scaffoldKey: scaffoldKey,
        ),
        body:
            body != null ? TContentWrapper(content: body!) : const SizedBox());
  }
}
