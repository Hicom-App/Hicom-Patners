import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/pages/account/safety_page.dart';
import '../../companents/custom_app_bar.dart';
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
        appBar: CustomAppBar(title: 'Sozlamalar'.tr, isBack: true, isCenter: true),
        body: Column(
            children: [
              SizedBox(height: 20.h),
              if (_getController.token != null && _getController.token.isNotEmpty)
                _buildListTile(context: context, icon: EneftyIcons.security_bold, title: 'Kirish va xavfsizlik'.tr, onTap: () => Get.to(() => SafetyPage(), transition: Transition.downToUp), status: 0),
              _buildListTile(context: context, icon: EneftyIcons.notification_bold, title: 'Bildirishnomalar'.tr, onTap: (){}, status: 1, notify: false),
              if (_getController.token != null && _getController.token.isNotEmpty)
                _buildListTile(context: context, icon: EneftyIcons.finger_cricle_bold, title: 'Biometriya orqali kirish'.tr, onTap: (){}, status: 1, notify: true),
              _buildListTile(context: context, icon: EneftyIcons.language_circle_bold, title: 'Afzal til'.tr, lang: _getController.languageName(Get.locale.toString()), onTap: (){InstrumentComponents().languageDialog(context);}, status: 3)
            ]
        )
    );
  }
  Container _buildListTile({required BuildContext context,required IconData icon, required String title, required VoidCallback onTap, color, required int status, lang, notify = false}) {
    lang ??= 'English';
    color ??= Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white;
    return Container(
        height: 60.h,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        margin: const EdgeInsets.only(top: 13.0, left: 15.0, right: 15.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.grey.withOpacity(0.2)),
        child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: onTap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(
                children: [
                  Icon(icon, color: color),
                  SizedBox(width: 10.w),
                  Expanded(child: Text(title, style: TextStyle(fontSize: 14, color: color))),
                  status == 0
                      ? const Icon(Icons.chevron_right, color: Colors.grey)
                      : status == 1
                      ? Obx(() => CupertinoSwitch(
                      value: notify ? _getController.getBiometricsValue.value : _getController.getNotificationValue.value,
                      onChanged: (value) {
                        if (notify) {
                          _getController.saveBiometrics(value);
                        } else {
                          _getController.saveNotification(value);
                        }
                      },
                      activeColor: AppColors.blue,
                      trackColor: AppColors.grey.withOpacity(0.5),
                      focusColor: AppColors.blue,
                      thumbColor: AppColors.white,
                      applyTheme: true
                  ))
                      : TextSmall(text: lang, color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.grey, fontWeight: FontWeight.w400, fontSize: 14.sp)
                ]
            )
        )
    );
  }
}

