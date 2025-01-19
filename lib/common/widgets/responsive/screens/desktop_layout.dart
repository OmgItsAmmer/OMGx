import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/layout/sidebar/tside_bar.dart';
import 'package:flutter/material.dart';

import '../../layout/headers/header.dart';

class DesktopLayout extends StatelessWidget {
   DesktopLayout({super.key, this.body});
final Widget? body;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Row(
        children: [
          const Expanded(
            flex: 1,
              child: TSideBar()),
          Expanded(
              flex: 5,
              child: Column(
            children: [
              //HEADER
              THeader(),
              //BODY
              body ?? const SizedBox()
            ],
          ))
        ],
      ),
    );
  }
}
