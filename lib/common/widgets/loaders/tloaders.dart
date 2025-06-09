import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

/// Data class to hold snackbar information for queuing
class _SnackBarItem {
  final String title;
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Duration duration;

  _SnackBarItem({
    required this.title,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.duration,
  });
}

class TLoader {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static final List<_SnackBarItem> _snackBarQueue = [];
  static bool _isShowingSnackBar = false;
  
  /// Set this key in your MaterialApp's navigatorKey property
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// Gets a safe context for showing snackbars, preferring overlay context if available
  static BuildContext? _getSafeContext() {
    try {
      // Try to get the navigator context first (better for dialogs/modals)
      if (_navigatorKey.currentContext != null) return _navigatorKey.currentContext!;
      // Fall back to current focus context
      final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
      if (context != null) return context;
      return null;
    } catch (e) {
      debugPrint('Error getting safe context: $e');
      return null;
    }
  }

  /// Hides any currently visible snackbar
  static hideSnackBar() {
    try {
      final context = _getSafeContext();
      if (context != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      debugPrint('Error hiding snackbar: $e');
    }
  }

  /// Shows a custom toast message
  static customToast({required String message}) {
    try {
      final context = _getSafeContext();
      if (context == null) {
        debugPrint('Cannot show custom toast: No valid context');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: THelperFunctions.isDarkMode(context)
                  ? TColors.darkerGrey.withOpacity(0.9)
                  : TColors.grey.withOpacity(0.9),
            ),
            child: Center(
                child: Text(
              message,
              style: Theme.of(context).textTheme.labelLarge,
            )),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error showing custom toast: $e');
      // Fallback to basic snackbar if custom toast fails
      _fallbackSnackbar(message: message);
    }
  }

  /// Shows a success snackbar
  static successSnackBar(
      {required String title, String message = '', int duration = 3}) {
    try {
      final context = _getSafeContext();
      if (context == null) {
        debugPrint('Cannot show success snackbar: No valid context');
        return;
      }

      _showAnimatedSnackBar(
        context: context,
        title: title,
        message: message,
        icon: Icons.check,
        backgroundColor: TColors.primary,
        duration: Duration(seconds: duration),
      );
    } catch (e) {
      debugPrint('Error showing success snackbar: $e');
      _fallbackSnackbar(title: title, message: message, isSuccess: true);
    }
  }

  /// Shows a warning snackbar
  static warningSnackBar({required String title, String message = ''}) {
    try {
      final context = _getSafeContext();
      if (context == null) {
        debugPrint('Cannot show warning snackbar: No valid context');
        return;
      }

      _showAnimatedSnackBar(
        context: context,
        title: title,
        message: message,
        icon: Icons.warning,
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('Error showing warning snackbar: $e');
      _fallbackSnackbar(title: title, message: message, isWarning: true);
    }
  }

  /// Shows an error snackbar
  static errorSnackBar({required String title, String message = ''}) {
    try {
      final context = _getSafeContext();
      if (context == null) {
        debugPrint('Cannot show error snackbar: No valid context');
        return;
      }

      _showAnimatedSnackBar(
        context: context,
        title: title,
        message: message,
        icon: Icons.warning,
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('Error showing error snackbar: $e');
      _fallbackSnackbar(title: title, message: message, isError: true);
    }
  }

  /// Shows an info snackbar
  static infoSnackBar(
      {required String title, String message = '', int duration = 3}) {
    try {
      final context = _getSafeContext();
      if (context == null) {
        debugPrint('Cannot show info snackbar: No valid context');
        return;
      }

      _showAnimatedSnackBar(
        context: context,
        title: title,
        message: message,
        icon: Icons.info,
        backgroundColor: TColors.info,
        duration: Duration(seconds: duration),
      );
    } catch (e) {
      debugPrint('Error showing info snackbar: $e');
      _fallbackSnackbar(title: title, message: message, isInfo: true);
    }
  }

  /// Shows an animated snackbar with pop-up effect in the center
  static void _showAnimatedSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Duration duration,
  }) {
    final snackBarItem = _SnackBarItem(
      title: title,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      duration: duration,
    );

    _snackBarQueue.add(snackBarItem);
    _processQueue();
  }

  /// Processes the snackbar queue to show them one by one
  static void _processQueue() {
    if (_isShowingSnackBar || _snackBarQueue.isEmpty) return;

    _isShowingSnackBar = true;
    final item = _snackBarQueue.removeAt(0);
    final context = _getSafeContext();
    
    if (context == null) {
      _isShowingSnackBar = false;
      return;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackBar(
        title: item.title,
        message: item.message,
        icon: item.icon,
        backgroundColor: item.backgroundColor,
        duration: item.duration,
        onDismiss: () {
          overlayEntry.remove();
          _isShowingSnackBar = false;
          // Process next item in queue after a small delay
          Future.delayed(const Duration(milliseconds: 100), () {
            _processQueue();
          });
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  /// Builds the content widget for snackbars
  static Widget _buildSnackBarContent({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Row(
        children: [
          Icon(icon, color: TColors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: TColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(color: TColors.white),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback method that tries to show a simpler snackbar when the main one fails
  static void _fallbackSnackbar(
      {String title = '',
      String message = '',
      bool isSuccess = false,
      bool isWarning = false,
      bool isError = false,
      bool isInfo = false}) {
    try {
      final context = _getSafeContext();
      if (context == null) return;

      Color bgColor = Colors.grey;
      if (isSuccess) bgColor = TColors.primary;
      if (isWarning) bgColor = Colors.orange;
      if (isError) bgColor = Colors.red.shade600;
      if (isInfo) bgColor = TColors.info;

      final displayMessage = message.isNotEmpty ? '$title: $message' : title;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(displayMessage),
          backgroundColor: bgColor,
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Even fallback snackbar failed: $e');
    }
  }
}

/// Custom animated snackbar widget that appears in the center with pop-up animation
class _AnimatedSnackBar extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Duration duration;
  final VoidCallback onDismiss;

  const _AnimatedSnackBar({
    required this.title,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Scale animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Fade animation controller for exit
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Pop-up scale animation (bounce effect)
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start the entrance animation
    _animationController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() async {
    await _fadeController.forward();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 100, // Position at bottom with some padding
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: GestureDetector(
                    onTap: _dismiss,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500), // Increased width
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.icon,
                            color: TColors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: TColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (widget.message.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.message,
                                    style: const TextStyle(
                                      color: TColors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}