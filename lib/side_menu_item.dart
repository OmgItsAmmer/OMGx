import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final bool isMinimized;
  final VoidCallback onTap;
  final bool isSelected;

  const SideMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isMinimized,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.blue : Colors.transparent,
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: isMinimized ? 10 : 20, // Reducing padding only for the minimized state
        ),
        child: Row(
          children: [
            icon,
            // Only show text when expanded
            AnimatedOpacity(
              opacity: isMinimized ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
