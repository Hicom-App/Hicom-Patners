import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';

import '../../resource/colors.dart';

class ShowToast {
  static void show(String title, String message, int status, int position, {int duration = 2, IconData icon = LucideIcons.info}) {
    Get.snackbar(
        title,
        message,
        duration: Duration(seconds: duration),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        icon: Icon(icon, color: AppColors.white),
        borderRadius: 16,
        dismissDirection: DismissDirection.horizontal,
        animationDuration: const Duration(milliseconds: 600),
        mainButton: TextButton(style: TextButton.styleFrom(minimumSize: Size(32, 32), padding: EdgeInsets.zero), onPressed: () => Get.back(), child: Icon(LucideIcons.x, color: AppColors.white, size: 20)),
        snackPosition: position == 1 ? SnackPosition.BOTTOM : SnackPosition.TOP,
        backgroundColor: status == 1 ? AppColors.primaryColor : status == 2 ? AppColors.blue : AppColors.red,
        colorText: AppColors.white
    );
  }
}