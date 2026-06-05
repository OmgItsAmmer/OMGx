import 'package:flutter/material.dart';

/// Web/mobile: no native drag-and-drop; child handles pick via button.
class PlatformDropTarget extends StatelessWidget {
  const PlatformDropTarget({
    super.key,
    required this.child,
    this.onFilesDropped,
  });

  final Widget child;
  final void Function(List<String> paths)? onFilesDropped;

  @override
  Widget build(BuildContext context) => child;
}
