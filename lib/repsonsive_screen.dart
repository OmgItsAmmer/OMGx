import 'package:flutter/material.dart';

import 'common/layouts/templates/site_template.dart';
import 'common/widgets/containers/rounded_container.dart';

class ResponsiveDesignScreen extends StatelessWidget {
  const ResponsiveDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TSiteTemplate(
          desktop: Desktop(), tablet: Desktop(), mobile: Desktop()),
    );
  }
}

class Desktop extends StatelessWidget {
  const Desktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        //First Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  TRoundedContainer(
                    height: 450,
                    child: Center(
                      child: Text('Box1'),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}