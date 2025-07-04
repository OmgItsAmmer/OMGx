import 'package:ecommerce_dashboard/common/widgets/layout/sidebar/tside_bar.dart';
import 'package:ecommerce_dashboard/common/widgets/responsive/content_wrapper.dart';
import 'package:flutter/material.dart';

import '../../layout/headers/header.dart';

class DesktopLayout extends StatelessWidget {
  DesktopLayout({super.key, this.body});
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(flex: 1, child: TSideBar()),
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //HEADER
                  THeader(),
                  //BODY
                  Expanded(child: body != null ? body! : const SizedBox())
                ],
              ))
        ],
      ),
    );
  }
}
