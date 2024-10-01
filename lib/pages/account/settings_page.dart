import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/account/safety_page.dart';
import '../../companents/filds/text_small.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: AppBar(backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
          foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
          surfaceTintColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
          title: TextSmall(text: 'Sozlamalar'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500)),
      body: Column(
        children: [
          _buildListTile(context: context, icon: EneftyIcons.security_bold, title: 'Kirish va xavfsizlik'.tr, onTap: () =>Get.to(() => SafetyPage(), transition: Transition.downToUp), status: 0),
          _buildListTile(context: context, icon: EneftyIcons.moon_bold, title: 'Mavzu'.tr, onTap: (){}, status: 1),
          _buildListTile(context: context, icon: EneftyIcons.language_circle_bold, title: 'Afzal til'.tr, onTap: (){}, status: 3),
        ]
      )
    );
  }
  Container _buildListTile({required BuildContext context,required IconData icon, required String title, required VoidCallback onTap, color, required int status}) {
    color ??= Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white;
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
            trailing: status == 0 ? Icon(Icons.chevron_right, color: color)
                : status == 1 ? CupertinoSwitch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                AdaptiveTheme.of(context).brightness == Brightness.light ? AdaptiveTheme.of(context).setDark() : AdaptiveTheme.of(context).setLight();
              },
              activeColor: AppColors.blue,
              trackColor: AppColors.grey.withOpacity(0.5),
              focusColor: AppColors.blue,
              thumbColor: AppColors.white,
              applyTheme: true,
            ) : TextSmall(text: 'O‘zbekcha',
                //color: AppColors.black.withOpacity(0.7),
                color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.grey,
                fontWeight: FontWeight.w400, fontSize: 14.sp)
        ),
    );
  }
}