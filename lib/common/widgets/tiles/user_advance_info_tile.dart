import 'package:flutter/material.dart';

class OUserAdvanceInfoTile extends StatelessWidget {
  const OUserAdvanceInfoTile({
    super.key,
    required this.firstTile,
    required this.secondTile,
  });

  final String firstTile;
  final String secondTile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstTile,
          style: Theme.of(context).textTheme.headlineSmall,
          overflow: TextOverflow.ellipsis,
        ),
        // const SizedBox(height: TSizes.spaceBtwSections),
        Text(
          secondTile,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}