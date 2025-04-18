// common/widgets/loaders/t_strip_loader.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TStripLoader extends StatelessWidget {
  const TStripLoader({super.key, this.height = 20, this.width = 100});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Lottie.asset(
        'assets/images/animations/striploader.json',  // You’ll add the Lottie here
        fit: BoxFit.contain,
      ),
    );
  }
}
