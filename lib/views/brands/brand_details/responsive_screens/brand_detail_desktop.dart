import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

import '../../../../Models/brand/brand_model.dart';
import '../widgets/brand_info.dart';

class BrandDetailDesktop extends StatelessWidget {
  const BrandDetailDesktop({super.key, required this.brandModel});
  final BrandModel brandModel;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: BrandInfo(
                    brandModel: brandModel,
                  ),
                ),
              ),
              Expanded(
                  flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 0,
                  child: const SizedBox())
            ],
          ),
        ),
      ),
    ));
  }
}
