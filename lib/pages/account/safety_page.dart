import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../companents/filds/text_small.dart';
import '../../resource/colors.dart';

class SafetyPage extends StatelessWidget {
  const SafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white, title: TextSmall(text: 'Kirish va xavfsizlik'.tr, color: AppColors.black, fontWeight: FontWeight.w500)),
      body: Column(
        children: [
          _buildListTile(
            icon:  EneftyIcons.profile_delete_bold,color: Colors.red,
            title: 'Hisobni o`chirish',
            onTap: (){},
          ),
        ],
      )
    );
  }
  Container _buildListTile({required IconData icon, required String title, required VoidCallback onTap, color = Colors.black}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        margin: const EdgeInsets.only(top: 13.0, left: 15.0, right: 15.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey.withOpacity(0.2)),
        child: ListTile(
            onTap: onTap,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            leading: Icon(icon, color: color),
            title: Text(title, style: TextStyle(fontSize: 14, color: color)),
            trailing: Icon(Icons.chevron_right, color: color)
        )
    );
  }
}