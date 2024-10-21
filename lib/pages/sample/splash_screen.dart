import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/pages/sample/sample_page.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../auth/language_page.dart';
import '../auth/login_page.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final GetController _getController = Get.put(GetController());

  void open() {
    //Get.offAll(() => LanguagePage(), transition: Transition.fadeIn);
    //Get.offAll(() => LoginPage(), transition: Transition.fadeIn);
    //Get.offAll(() => OnBoarding(), transition: Transition.fadeIn);
    //ApiController().login();

    print('${_getController.token} ${_getController.phoneNumber}');
    if (_getController.token != null && _getController.token!.isNotEmpty || _getController.phoneNumber != null && _getController.phoneNumber!.isNotEmpty) {
      ApiController().login();
    } else {
      //Get.offAll(() => LoginPage(), transition: Transition.downToUp);
      Get.offAll(() => LanguagePage(), transition: Transition.fadeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getController.tapTimes(open,1);
    return Scaffold(
      body: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/background.png'), fit: BoxFit.cover)),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: Container()),
                    SizedBox(height: Get.height * 0.07),
                    SizedBox(width: Get.width * 0.43, child: SvgPicture.asset('assets/svg_assets/logo.svg', color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.white, fit: BoxFit.contain)),
                    Flexible(child: Container()),
                    CupertinoActivityIndicator(radius: Get.width * 0.05, color: AppColors.white),
                    SizedBox(height: Get.height * 0.04),
                    Text('${'Version'.tr}: 1.0.0', style: TextStyle(fontSize: Get.width * 0.035, fontWeight: FontWeight.w500, color: AppColors.white)),
                    SizedBox(height: Get.height * 0.03)
                    /*_buildListTile(context: context, icon: EneftyIcons.profile_bold, title: 'Profilim', onTap: () => Get.to(() => const MyAccountPage(), transition: Transition.downToUp)),
                    _buildListTile(context: context, icon: EneftyIcons.wallet_2_bold, title: 'Hamyon', onTap: () => Get.to(() => TransferToWallet(index: 1), transition: Transition.downToUp)),
                    _buildListTile(context: context, icon: EneftyIcons.bookmark_2_bold, title: 'Saqlanganlar', onTap: () =>Get.to(() => ArxivPage(), transition: Transition.downToUp)),
                    _buildListTile(context: context, icon: EneftyIcons.heart_bold, title: 'Sevimlilar', onTap: () =>Get.to(() => FavoritesPage(), transition: Transition.downToUp)),
                    _buildListTile(context: context, icon: EneftyIcons.setting_3_bold, title: 'Sozlamalar', onTap: () =>Get.to(() => SettingsPage(), transition: Transition.downToUp)),
                    _buildListTile(context: context, icon: EneftyIcons.notification_bold, title: 'Bildirishnomalar', onTap: () =>Get.to(() => const NotificationPage(), transition: Transition.downToUp)),
                    _buildListTile(context: context, icon: Icons.help, title: 'Yordam', onTap: () => launchUrl(Uri.parse('https://hicom.uz/'), mode: LaunchMode.externalApplication)),
                    _buildListTile(context: context, icon: EneftyIcons.info_circle_bold, title: 'Batafsil', onTap: () =>launchUrl(Uri.parse('https://hicom.uz/'), mode: LaunchMode.externalApplication)),
                    _buildListTile(context: context, icon: EneftyIcons.happyemoji_bold, title: 'Ilova haqida', onTap: () => launchUrl(Uri.parse('https://hicom.uz/'), mode: LaunchMode.externalApplication)),
                    _buildListTile(context: context, icon: EneftyIcons.login_bold,color: Colors.red, title: 'Chiqish', onTap: () => InstrumentComponents().logOutDialog(context)),
                    SizedBox(height: 20.h),
                    TextSmall(text: 'Ilova versiyasi: 1.0.0', color: AppColors.black, fontSize: 12.sp),
                    SizedBox(height: Get.height * 0.1),
                    SizedBox(height: 400.h)*/
                  ]
              )
          )
      )
    );
  }
  Container _buildListTile({required BuildContext context,required IconData icon, required String title, required VoidCallback onTap, color}) {
    color ??= Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white;
    return Container(
        margin: const EdgeInsets.only(top: 13.0),
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
