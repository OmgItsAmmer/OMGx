import 'package:ecommerce_dashboard/common/widgets/layout/sidebar/controller/sidebar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TMenuItem extends StatelessWidget {
  const TMenuItem({
    super.key,
    this.route = '',
    required this.itemName,
    required this.icon,
  });

  final String route;
  final String itemName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SideBarController());
    return InkWell(
      onTap: () => menuController.menuOnTap(route),
      onHover: (hovering) => hovering
          ? menuController.changeHoverItem(route)
          : menuController.changeHoverItem(''),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Container(
            decoration: BoxDecoration(
                color: menuController.isHovering(route) ||
                        menuController.isActive(route)
                    ? TColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: TSizes.lg,
                        top: TSizes.md,
                        right: TSizes.md,
                        bottom: TSizes.md),
                    child: menuController.isActive(route)
                        ? Icon(
                            icon,
                            color: TColors.white,
                          )
                        : Icon(
                            icon,
                            size: 22,
                            color: menuController.isHovering(route)
                                ? TColors.white
                                : TColors.darkerGrey,
                          )),
                if (menuController.isHovering(route) ||
                    menuController.isActive(route))
                  Flexible(
                    child: Text(
                      itemName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: TColors.white),
                    ),
                  )
                else
                  Flexible(
                    child: Text(
                      itemName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: TColors.darkerGrey),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
