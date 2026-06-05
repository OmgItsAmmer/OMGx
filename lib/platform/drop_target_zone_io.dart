import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class PlatformDropTarget extends StatelessWidget {
  const PlatformDropTarget({
    super.key,
    required this.child,
    this.onFilesDropped,
  });

  final Widget child;
  final void Function(List<String> paths)? onFilesDropped;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) {
        if (onFilesDropped == null) return;
        onFilesDropped!(
          details.files.map((f) => f.path).whereType<String>().toList(),
        );
      },
      child: child,
    );
  }
}
