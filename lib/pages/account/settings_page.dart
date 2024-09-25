import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../companents/filds/text_small.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, foregroundColor: AppColors.black, surfaceTintColor: AppColors.white, title: TextSmall(text: 'Sozlamalar'.tr, color: AppColors.black, fontWeight: FontWeight.w500)),
      body: Column(
        children: [
          _buildListTile(icon: EneftyIcons.security_bold,
              title: 'Kirish va xavfsizlik'.tr, onTap: (){}, status: 0),
          _buildListTile(icon: EneftyIcons.moon_bold, title: 'Mavzu'.tr, onTap: (){}, status: 1),
          _buildListTile(icon: EneftyIcons.language_circle_bold, title: 'Afzal til'.tr, onTap: (){}, status: 3),
        ]
      )
    );
  }
  Container _buildListTile({required IconData icon, required String title, required VoidCallback onTap, color = Colors.black,required int status}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        margin: const EdgeInsets.only(top: 13.0, left: 15.0, right: 15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.withOpacity(0.2)
        ),
        child: ListTile(
            onTap: onTap,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            leading: Icon(icon, color: color),
            title: Text(title, style: TextStyle(fontSize: 14, color: color)),
            trailing: status == 0 ? Icon(Icons.chevron_right, color: color)
                : status == 1 ? CupertinoSwitch(
              value: false,
              onChanged: (value) {},
              activeColor: AppColors.green,
              trackColor: AppColors.grey.withOpacity(0.5),
              focusColor: AppColors.green,
              thumbColor: AppColors.white,
              applyTheme: true,
            ) : TextSmall(text: 'English', color: AppColors.black.withOpacity(0.7), fontWeight: FontWeight.w400, fontSize: 14.sp)
        ),
    );
  }
}