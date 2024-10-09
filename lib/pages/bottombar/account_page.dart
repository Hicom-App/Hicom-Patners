import 'dart:ui';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/pages/account/my_account_page.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../account/arxiv_page.dart';
import '../account/favorites_page.dart';
import '../account/notification_page.dart';
import '../account/settings_page.dart';
import '../home/transfer_to_wallet.dart';
import 'package:url_launcher/url_launcher.dart';



class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GetController _getController = Get.put(GetController());
  double _imageHeight = 0.28; // Start height as 30% of screen height
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _imageHeight = 0.28 - (_scrollController.offset / 1000); // Adjust shrinking speed
        if (_imageHeight < 0.15) _imageHeight = 0.15; // Minimum height limit
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: RefreshComponent(
        refreshController: _getController.refreshAccountController,
        scrollController: _scrollController,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: Get.height * _imageHeight,
              width: Get.width,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.only(bottom: Get.height * 0.03),
                      child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), child: Image.network('https://i.pinimg.com/564x/2f/57/8d/2f578d07945132849b05fbdaf78cba38.jpg', fit: BoxFit.cover))
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: Get.width,
                      height: Get.height * 0.1,
                      decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)))
                    )
                  ),
                  Positioned(
                    bottom: Get.height * 0.03,
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 130.w,
                          height: 130.h,
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey,
                                    spreadRadius: 0,
                                    blurRadius: 30,
                                    offset: Offset(0, 20), // changes position of shadow
                                  ),
                                ]
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(400), child: Image.network('https://i.pinimg.com/564x/2f/57/8d/2f578d07945132849b05fbdaf78cba38.jpg', fit: BoxFit.cover)
                            )
                          )
                        )
                      ]
                    )
                  )
                ]
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextSmall(text: 'Dilshodjon', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 20),
                SizedBox(width: 5.w),
                TextSmall(text: 'Haydarov', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 20),

              ]
            ),
            //SizedBox(height: 5.h),
            TextSmall(text: '+998995340313', color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 15),
            // Your list tiles and other widgets
            _buildListTile(context: context, icon: EneftyIcons.profile_bold, title: 'Profilim', onTap: () => Get.to(() => const MyAccountPage(), transition: Transition.downToUp)),
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
            SizedBox(height: Get.height * 0.1)
          ]
        )
      )
    );
  }

  Container _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    color,
  }) {
    color ??= Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white;
    return Container(
      margin: EdgeInsets.only(top: 13.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: ListTile(
        onTap: onTap,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontSize: 16.sp)),
        trailing: Icon(Icons.chevron_right, color: color),
      ),
    );
  }
}
