import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/pages/account/my_account_page.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../companents/home/chashe_image.dart';
import '../../controllers/get_controller.dart';
import '../account/arxiv_page.dart';
import '../account/settings_page.dart';
import '../auth/login_page.dart';
import '../home/category_page.dart';
import '../home/transfer_to_wallet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:enefty_icons/enefty_icons.dart';

import 'guarantee_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final ScrollController _scrollController = ScrollController();
  final GetController _getController = Get.put(GetController());
  double _imageHeight = 0.28;

  @override
  void initState() {
    super.initState();
    ApiController().getProfile(isWorker: false);
    _scrollController.addListener(() {
      setState(() {
        _imageHeight = 0.28 - (_scrollController.offset / 1000);
        if (_imageHeight < 0.15) _imageHeight = 0.15;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _hasPhoto(String? url) {
    return url != null && url.isNotEmpty && url.toLowerCase() != 'null';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Obx(() => Column(
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: Get.height * _imageHeight,
                  width: Get.width,
                  child: Stack(
                      children: [
                        if (_hasPhoto(_getController.profileInfoModel.value.result?.first.photoUrl))
                          Positioned.fill(child: Container(margin: EdgeInsets.only(bottom: Get.height * 0.03), child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), child: ClipRRect(child: SizedBox(width: Get.width, child: CacheImage(keys: 'front', url: _getController.profileInfoModel.value.result!.first.photoUrl ?? 'https://avatars.mds.yandex.net/i?id=04a44da22808ead8020a647bb3f768d2_sr-7185373-images-thumbs&n=13', fit: BoxFit.cover))))))
                        else
                          Positioned.fill(child: Container(margin: EdgeInsets.only(bottom: Get.height * 0.03), color: Colors.grey.withAlpha(100), child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 1), child: ClipRRect(child: SizedBox(width: Get.width, child: Image.asset('assets/images/bar.png', fit: BoxFit.cover)))))),
                        Positioned(top: 60, left: 20, child: InkWell(onTap: () => Get.back(), child: const Icon(EneftyIcons.arrow_left_3_outline, color: AppColors.white, size: 24))),
                        Positioned(bottom: 0, child: Container(width: Get.width, height: Get.height * 0.1, decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))))),
                        Positioned(
                            bottom: Get.height * 0.03,
                            width: Get.width,
                            child: Center(
                                child: InkWell(
                                    onTap: () => Get.to(() => Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: PhotoView(
                                          filterQuality: FilterQuality.high,
                                          minScale: PhotoViewComputedScale.contained * 0.8,
                                          maxScale: PhotoViewComputedScale.covered * 1.8,
                                          initialScale: PhotoViewComputedScale.contained,
                                          basePosition: Alignment.center,
                                          imageProvider: NetworkImage(_getController.profileInfoModel.value.result!.first.photoUrl ?? 'https://avatars.mds.yandex.net/i?id=04a44da22808ead8020a647bb3f768d2_sr-7185373-images-thumbs&n=13'),
                                        )
                                    ), transition: Transition.fadeIn),
                                    child: SizedBox(width: 130.w, height: 130.h,
                                        child: Container(
                                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: 30, offset: Offset(0, 20))]),
                                            child: _getController.profileInfoModel.value.result?.isNotEmpty == true &&_getController.profileInfoModel.value.result!.first.photoUrl != null
                                                ? ClipRRect(borderRadius: BorderRadius.circular(500.r), child: CacheImage(keys: 'avatar', url: _getController.profileInfoModel.value.result!.first.photoUrl ?? 'https://avatars.mds.yandex.net/i?id=04a44da22808ead8020a647bb3f768d2_sr-7185373-images-thumbs&n=13', fit: BoxFit.cover))
                                                : ClipRRect(borderRadius: BorderRadius.circular(500.r), child: Image.asset('assets/images/user.png', fit: BoxFit.cover)
                                            )
                                        )
                                    )
                                )
                            )
                        )
                      ]
                  )
              ),
              if (_getController.token != null && _getController.token.isNotEmpty)
                TextSmall(text: '${_getController.profileInfoModel.value.result?.first.firstName ?? ''} ${_getController.profileInfoModel.value.result?.first.lastName ?? ''}', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)
              else
                TextSmall(text: 'Tizimga kirish', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),
              TextSmall(text: _getController.profileInfoModel.value.result?.first.phone ?? '', color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 15.sp),
              if (_getController.token != null && _getController.token.isNotEmpty)
                _buildListTile(context: context, icon: Icons.person, title: 'Hisobim'.tr, onTap: () {ApiController().getCountries(me: true);Get.to(() => const MyAccountPage(), transition: Transition.fadeIn);})
              else
                _buildListTile(context: context, icon: Icons.login, title: 'Hisobga kirish'.tr, onTap: () {_getController.logout();Get.offAll(() => const LoginPage(),transition: Transition.fadeIn);}),
              if (_getController.token != null && _getController.token.isNotEmpty)
              _buildListTile(context: context, icon: Icons.wallet, title: 'Hamyon'.tr, onTap: () => Get.to(() => TransferToWallet(index: 1), transition: Transition.fade)),
              if (_getController.token != null && _getController.token.isNotEmpty)
              _buildListTile(context: context, icon: Icons.shield, title: 'Kafolatlar'.tr, onTap: () => Get.to(() => GuaranteePage(), transition: Transition.fade)),
              if (_getController.token != null && _getController.token.isNotEmpty)
              _buildListTile(context: context, icon: Icons.bookmark, title: 'Arxiv'.tr, onTap: () => Get.to(() => ArxivPage(), transition: Transition.fadeIn)),
              if (_getController.token != null && _getController.token.isNotEmpty)
                _buildListTile(context: context, icon: Icons.favorite, title: 'Sevimlilar'.tr, onTap: () => Get.to(() => const CategoryPage(id: 0, open: 1), transition: Transition.fadeIn)),
              _buildListTile(context: context, icon: Icons.settings, title: 'Sozlamalar'.tr, onTap: () => Get.to(() => SettingsPage(), transition: Transition.fadeIn)),
              _buildListTile(context: context, icon: Icons.help, title: 'Yordam'.tr, onTap: () => launchUrl(Uri.parse(GetController().language.toString() == 'uz_UZ' ? 'https://hicom.uz/links/сontact_uz.html' : GetController().language.toString() == 'ru_RU' ? 'https://hicom.uz/links/сontact_ru.html' :  GetController().language.toString() == 'en_US' ? 'https://hicom.uz/links/сontact_en.html' : 'https://hicom.uz/links/сontact_uz-cyr.html'), mode: LaunchMode.externalApplication)),
              _buildListTile(context: context, icon: Icons.info, title: 'Maxfiylik siyosati'.tr, onTap: () => launchUrl(Uri.parse(GetController().language.toString() == 'uz_UZ' ? 'https://hicom.uz/doc/partner/private_policy_uz.html' : GetController().language.toString() == 'ru_RU' ? 'https://hicom.uz/doc/partner/private_policy_ru.html' :  GetController().language.toString() == 'en_US' ? 'https://hicom.uz/doc/partner/private_policy_en.html' : 'https://hicom.uz/doc/partner/private_policy_uz-cyr.html'), mode: LaunchMode.externalApplication)),
              if (_getController.token != null && _getController.token.isNotEmpty)
                _buildListTile(context: context, icon: Icons.logout, color: Colors.red, title: 'Chiqish'.tr, onTap: () => InstrumentComponents().logOutDialog(context)),
              SizedBox(height: 20.h),
              TextSmall(text: '${'Ilova versiyasi'.tr} ${_getController.version.value}', color: AppColors.black, fontSize: 12.sp),
              SizedBox(height: Get.height * 0.2)
            ]
        ))
      )
    );
  }

  Container _buildListTile({required BuildContext context, required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    color ??= Colors.black;
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: AppColors.grey.withOpacity(0.2)),
     // child: ListTile(onTap: onTap, leading: Icon(icon, color: color), title: TextSmall(text: title, color: color, fontSize: 16.sp, fontWeight: FontWeight.w500), trailing: Icon(Icons.chevron_right, color: color))
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10.w),
            TextSmall(text: title, color: color, fontSize: 16.sp, fontWeight: FontWeight.w500),
            const Spacer(),
            Icon(Icons.chevron_right, color: color)
          ]
        )
      )
    );
  }
}
