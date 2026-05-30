import 'package:flutter/material.dart';

enum SnackType { success, error, info }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackType type = SnackType.info,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;

      case SnackType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;

      case SnackType.info:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 3),

          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
