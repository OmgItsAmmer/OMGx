import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:flutter/material.dart';

import 'responsive_screens/account_book_desktop.dart';
import 'responsive_screens/account_book_mobile.dart';
import 'responsive_screens/account_book_tablet.dart';

class AccountBookScreen extends StatelessWidget {
  const AccountBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: AccountBookDesktop(),
      tablet: AccountBookTablet(),
      mobile: AccountBookMobile(),
    );
  }
}
