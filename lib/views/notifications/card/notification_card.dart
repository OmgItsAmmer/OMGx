import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/helpers/helper_functions.dart';

class NotificationCard extends StatefulWidget {
  final String description;
  final NotificationType notificationType;
  final String date;
  final bool markAsRead;
  const NotificationCard({super.key, required this.description, required this.notificationType, required this.date, required this.markAsRead});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isHovered = false;



  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Smooth transition
        decoration: BoxDecoration(
          color: _isHovered
              ? TColors.primary.withOpacity(0.15) // Light blue tint on hover
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 0.5,
            color: _isHovered ? TColors.primary : Colors.transparent, // Add a subtle border on hover
          ),
          boxShadow: _isHovered
              ? [
            BoxShadow(
              color: TColors.primary.withValues(alpha:  0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: TRoundedContainer(
          backgroundColor: TColors.primaryBackground,
          width: double.infinity,
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Icon
                        TRoundedContainer(
                          backgroundColor: THelperFunctions.getNotificationColor(widget.notificationType),
                          child: Icon(
                            THelperFunctions.getNotificationIcon(widget.notificationType),
                            color: Colors.white,
                            size: 18, // Adjusted for a smaller size
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),

                        // Description
                        Text(
                          widget.description,
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Date
                  Text(widget.date, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TTableActionButtons(
                    view: true,
                    delete: true,
                    edit: true,
                    // View
                    //
                  ),
               //   GestureDetector(
                    //   onTap: () {},
                    //   child: const Icon(Iconsax.eye, color: Colors.black),
                    // ),
                    // const SizedBox(width: TSizes.spaceBtwItems),
                    //
                    // // Mark as Read
                    // GestureDetector(
                    //   onTap: () {},
                    //   child:  Icon(Iconsax.verify, color: (widget.markAsRead) ? TColors.primary : Colors.black ),
                    // ),
                    // const SizedBox(width: TSizes.spaceBtwItems),
                    //
                    // // Delete Icon
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: const Icon(Iconsax.trash, color: Colors.red),
                    // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
