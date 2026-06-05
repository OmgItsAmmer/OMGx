import 'package:flutter/material.dart';

class AnimatedDotLoader extends StatefulWidget {
  const AnimatedDotLoader({super.key});

  @override
  _AnimatedDotLoaderState createState() => _AnimatedDotLoaderState();
}

class _AnimatedDotLoaderState extends State<AnimatedDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _dotCount = IntTween(begin: 1, end: 3).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotCount,
      builder: (_, __) {
        return Text('.' * _dotCount.value,
            style: const TextStyle(fontSize: 18));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
