import 'package:ecommerce_dashboard/views/collections/collection_detail/responsive_screens/collection_detail_desktop.dart';
import 'package:flutter/material.dart';

class CollectionDetailTablet extends StatelessWidget {
  const CollectionDetailTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the same layout as desktop for tablet
    return const CollectionDetailDesktop();
  }
}
