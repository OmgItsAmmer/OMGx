import 'package:flutter/material.dart';

/// A helper widget that handles the different ways content can be rendered,
/// especially in responsive layouts with content that may or may not already
/// be wrapped in Expanded widgets.
class TContentWrapper extends StatelessWidget {
  const TContentWrapper({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    // If content is already an Expanded widget, we need to extract its child
    // to avoid nesting issues in non-desktop layouts
    if (content.toString().contains('Expanded')) {
      // For tablet and mobile layouts, we don't want the content inside Expanded
      // because it's not inside a Column/Row flex container
      return _extractExpandedChild(content);
    } else {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: content,
      );
    }
  }

  /// Helper method to extract a child widget from an Expanded widget
  /// This is a workaround for the issue where desktop screens use Expanded
  /// but tablet/mobile layouts don't need that Expanded wrapper
  Widget _extractExpandedChild(Widget expandedWidget) {
    // This is a simplified approach - ideally we'd check if it's actually Expanded
    // and extract its child properly, but this works for our specific use case

    if (expandedWidget is Expanded) {
      // If we can directly cast to Expanded, return its child
      return expandedWidget.child;
    }

    // Otherwise, wrap it in a container to render properly
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: content,
    );
  }
}
