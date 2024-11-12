import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/pages/account/safety_page.dart';
import '../../companents/filds/text_small.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../home/notification_page.dart';
import 'notification_settings_page.dart';

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
            _buildListTile(context: context, icon: EneftyIcons.security_bold, title: 'Kirish va xavfsizlik'.tr, onTap: () => Get.to(() => const SafetyPage(), transition: Transition.downToUp), status: 0),
            _buildListTile(context: context, icon: EneftyIcons.notification_bold, title: 'Bildirishnomalar'.tr, onTap: () => Get.to(() => const NotificationSettingsPage(), transition: Transition.fadeIn), status: 0),
            _buildListTile(context: context, icon: EneftyIcons.finger_cricle_bold, title: 'Biometriya orqali kirish'.tr, onTap: (){}, status: 1),
            _buildListTile(context: context, icon: EneftyIcons.language_circle_bold, title: 'Afzal til'.tr, lang: _getController.languageName(Get.locale.toString()), onTap: (){InstrumentComponents().languageDialog(context);}, status: 3)
          ]
      )
    );
  }
  Container _buildListTile({required BuildContext context,required IconData icon, required String title, required VoidCallback onTap, color, required int status, lang}) {
    lang ??= 'English';
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
            trailing: status == 0
                ? Icon(Icons.chevron_right, color: color)
                : status == 1
                ? Obx(() => CupertinoSwitch(value: _getController.getBiometricsValue.value, onChanged: (value) {_getController.saveBiometrics(value);}, activeColor: AppColors.blue, trackColor: AppColors.grey.withOpacity(0.5), focusColor: AppColors.blue, thumbColor: AppColors.white, applyTheme: true,))
                : TextSmall(text: lang, color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.grey, fontWeight: FontWeight.w400, fontSize: 14.sp)
        )
    );
  }
}

