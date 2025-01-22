import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/dropdown_search/drop_down_searchbar.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 300  ,
     height: 60,
      child: OSearchDropDown(
        suggestions: ['Desi Ghee','Dalda'],
        onSelected: (value){},

      ),
    );
  }
}
